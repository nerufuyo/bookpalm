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
        return Either.right(remoteBooks);
      } on ServerException catch (e) {
        return Either.left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Either.left(NetworkFailure(e.message));
      } catch (e) {
        return Either.left(GeneralFailure('Unexpected error: $e'));
      }
    } else {
      return const Either.left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Book>> getBookById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBook = await remoteDataSource.getBookById(id);
        return Either.right(remoteBook);
      } on ServerException catch (e) {
        return Either.left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Either.left(NetworkFailure(e.message));
      } catch (e) {
        return Either.left(GeneralFailure('Unexpected error: $e'));
      }
    } else {
      return const Either.left(NetworkFailure('No internet connection'));
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
        authors: book.authors.map((author) => PersonModel(
          birthYear: author.birthYear,
          deathYear: author.deathYear,
          name: author.name,
        )).toList(),
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
