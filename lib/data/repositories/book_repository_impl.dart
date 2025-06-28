import '../../domain/entities/book.dart';
import '../../domain/entities/book_list_response.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_data_source.dart';
import '../datasources/book_local_data_source.dart';
import '../models/book_model.dart';
import '../models/person_model.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/utils/either.dart';
import '../../core/network/network_info.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;
  final BookLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  BookRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, BookListResponse>> getBooks({
    String? search,
    List<String>? languages,
    String? topic,
    int? authorYearStart,
    int? authorYearEnd,
    String? sort,
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBooks = await remoteDataSource.getBooks(
          search: search,
          languages: languages,
          topic: topic,
          authorYearStart: authorYearStart,
          authorYearEnd: authorYearEnd,
          sort: sort,
          page: page,
        );

        // Cache the response for offline use
        await localDataSource.cacheBookList(
          response: remoteBooks,
          search: search,
          languages: languages,
          topic: topic,
          authorYearStart: authorYearStart,
          authorYearEnd: authorYearEnd,
          sort: sort,
          page: page,
        );

        return Either.right(remoteBooks);
      } on ServerException catch (e) {
        // Try to get cached data if server fails
        final cachedBooks = await localDataSource.getCachedBookList(
          search: search,
          languages: languages,
          topic: topic,
          authorYearStart: authorYearStart,
          authorYearEnd: authorYearEnd,
          sort: sort,
          page: page,
        );
        if (cachedBooks != null) {
          return Either.right(cachedBooks);
        }
        return Either.left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        // Try to get cached data if network fails
        final cachedBooks = await localDataSource.getCachedBookList(
          search: search,
          languages: languages,
          topic: topic,
          authorYearStart: authorYearStart,
          authorYearEnd: authorYearEnd,
          sort: sort,
          page: page,
        );
        if (cachedBooks != null) {
          return Either.right(cachedBooks);
        }
        return Either.left(NetworkFailure(e.message));
      } catch (e) {
        return Either.left(GeneralFailure('Unexpected error: $e'));
      }
    } else {
      // No internet connection - try to get cached data
      try {
        final cachedBooks = await localDataSource.getCachedBookList(
          search: search,
          languages: languages,
          topic: topic,
          authorYearStart: authorYearStart,
          authorYearEnd: authorYearEnd,
          sort: sort,
          page: page,
        );
        if (cachedBooks != null) {
          return Either.right(cachedBooks);
        }
        return const Either.left(
          NetworkFailure('No internet connection and no cached data available'),
        );
      } on CacheException catch (e) {
        return Either.left(CacheFailure(e.message));
      } catch (e) {
        return Either.left(GeneralFailure('Unexpected error: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Book>> getBookById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBook = await remoteDataSource.getBookById(id);

        // Cache the book for offline use
        await localDataSource.cacheBook(remoteBook);

        return Either.right(remoteBook);
      } on ServerException catch (e) {
        // Try to get cached book if server fails
        final cachedBook = await localDataSource.getCachedBook(id);
        if (cachedBook != null) {
          return Either.right(cachedBook);
        }
        return Either.left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        // Try to get cached book if network fails
        final cachedBook = await localDataSource.getCachedBook(id);
        if (cachedBook != null) {
          return Either.right(cachedBook);
        }
        return Either.left(NetworkFailure(e.message));
      } catch (e) {
        return Either.left(GeneralFailure('Unexpected error: $e'));
      }
    } else {
      // No internet connection - try to get cached book
      try {
        final cachedBook = await localDataSource.getCachedBook(id);
        if (cachedBook != null) {
          return Either.right(cachedBook);
        }
        return const Either.left(
          NetworkFailure('No internet connection and book not cached'),
        );
      } on CacheException catch (e) {
        return Either.left(CacheFailure(e.message));
      } catch (e) {
        return Either.left(GeneralFailure('Unexpected error: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getBookmarkedBooks() async {
    try {
      final localBooks = await localDataSource.getBookmarkedBooks();
      return Either.right(localBooks);
    } on CacheException catch (e) {
      return Either.left(CacheFailure(e.message));
    } catch (e) {
      return Either.left(GeneralFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> bookmarkBook(Book book) async {
    try {
      final bookModel = BookModel(
        id: book.id,
        title: book.title,
        subjects: book.subjects,
        authors: book.authors
            .map(
              (author) => PersonModel(
                birthYear: author.birthYear,
                deathYear: author.deathYear,
                name: author.name,
              ),
            )
            .toList(),
        bookshelves: book.bookshelves,
        languages: book.languages,
        copyright: book.copyright,
        mediaType: book.mediaType,
        formats: book.formats,
        downloadCount: book.downloadCount,
      );

      final result = await localDataSource.bookmarkBook(bookModel);
      return Either.right(result);
    } on CacheException catch (e) {
      return Either.left(CacheFailure(e.message));
    } catch (e) {
      return Either.left(GeneralFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> removeBookmark(int bookId) async {
    try {
      final result = await localDataSource.removeBookmark(bookId);
      return Either.right(result);
    } on CacheException catch (e) {
      return Either.left(CacheFailure(e.message));
    } catch (e) {
      return Either.left(GeneralFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isBookmarked(int bookId) async {
    try {
      final result = await localDataSource.isBookmarked(bookId);
      return Either.right(result);
    } on CacheException catch (e) {
      return Either.left(CacheFailure(e.message));
    } catch (e) {
      return Either.left(GeneralFailure('Unexpected error: $e'));
    }
  }
}
