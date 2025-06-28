import '../models/book_model.dart';
import '../models/book_list_response_model.dart';

abstract class BookLocalDataSource {
  // Bookmark functionality
  Future<List<BookModel>> getBookmarkedBooks();
  Future<bool> bookmarkBook(BookModel book);
  Future<bool> removeBookmark(int bookId);
  Future<bool> isBookmarked(int bookId);

  // Cache functionality
  Future<BookListResponseModel?> getCachedBookList({
    String? search,
    List<String>? languages,
    String? topic,
    int? authorYearStart,
    int? authorYearEnd,
    String? sort,
    int page = 1,
  });

  Future<void> cacheBookList({
    required BookListResponseModel response,
    String? search,
    List<String>? languages,
    String? topic,
    int? authorYearStart,
    int? authorYearEnd,
    String? sort,
    int page = 1,
  });

  Future<BookModel?> getCachedBook(int id);
  Future<void> cacheBook(BookModel book);

  Future<void> clearOldCache();
  Future<Map<String, int>> getCacheStats();
  Future<void> clearAllCache();
}
