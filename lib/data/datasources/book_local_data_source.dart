import '../models/book_model.dart';

abstract class BookLocalDataSource {
  Future<List<BookModel>> getBookmarkedBooks();
  Future<bool> bookmarkBook(BookModel book);
  Future<bool> removeBookmark(int bookId);
  Future<bool> isBookmarked(int bookId);
}
