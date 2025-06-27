import '../entities/book.dart';
import '../entities/book_list_response.dart';
import '../../core/error/failures.dart';
import '../../core/utils/either.dart';

abstract class BookRepository {
  Future<Either<Failure, BookListResponse>> getBooks({
    String? search,
    List<String>? languages,
    String? topic,
    int? authorYearStart,
    int? authorYearEnd,
    String? sort,
    int page = 1,
  });

  Future<Either<Failure, Book>> getBookById(int id);

  Future<Either<Failure, List<Book>>> getBookmarkedBooks();

  Future<Either<Failure, bool>> bookmarkBook(Book book);

  Future<Either<Failure, bool>> removeBookmark(int bookId);

  Future<Either<Failure, bool>> isBookmarked(int bookId);
}
