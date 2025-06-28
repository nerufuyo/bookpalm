import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_model.dart';
import '../models/book_list_response_model.dart';
import 'book_local_data_source.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/storage_constants.dart';
import '../../core/database/database_helper.dart';

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final SharedPreferences sharedPreferences;
  final DatabaseHelper databaseHelper;

  BookLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.databaseHelper,
  });

  @override
  Future<List<BookModel>> getBookmarkedBooks() async {
    try {
      final jsonString = sharedPreferences.getString(
        StorageConstants.bookmarkedBooksKey,
      );
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => BookModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get bookmarked books: $e');
    }
  }

  @override
  Future<bool> bookmarkBook(BookModel book) async {
    try {
      final bookmarkedBooks = await getBookmarkedBooks();

      // Check if book is already bookmarked
      if (bookmarkedBooks.any((b) => b.id == book.id)) {
        return true; // Already bookmarked
      }

      bookmarkedBooks.add(book);
      final jsonString = json.encode(
        bookmarkedBooks.map((b) => b.toJson()).toList(),
      );

      return await sharedPreferences.setString(
        StorageConstants.bookmarkedBooksKey,
        jsonString,
      );
    } catch (e) {
      throw CacheException('Failed to bookmark book: $e');
    }
  }

  @override
  Future<bool> removeBookmark(int bookId) async {
    try {
      final bookmarkedBooks = await getBookmarkedBooks();
      bookmarkedBooks.removeWhere((book) => book.id == bookId);

      final jsonString = json.encode(
        bookmarkedBooks.map((b) => b.toJson()).toList(),
      );

      return await sharedPreferences.setString(
        StorageConstants.bookmarkedBooksKey,
        jsonString,
      );
    } catch (e) {
      throw CacheException('Failed to remove bookmark: $e');
    }
  }

  @override
  Future<bool> isBookmarked(int bookId) async {
    try {
      final bookmarkedBooks = await getBookmarkedBooks();
      return bookmarkedBooks.any((book) => book.id == bookId);
    } catch (e) {
      throw CacheException('Failed to check bookmark status: $e');
    }
  }

  // Cache functionality implementation
  @override
  Future<BookListResponseModel?> getCachedBookList({
    String? search,
    List<String>? languages,
    String? topic,
    int? authorYearStart,
    int? authorYearEnd,
    String? sort,
    int page = 1,
  }) async {
    try {
      final cacheKey = databaseHelper.generateCacheKey(
        search: search,
        languages: languages,
        topic: topic,
        authorYearStart: authorYearStart,
        authorYearEnd: authorYearEnd,
        sort: sort,
      );
      return await databaseHelper.getCachedBookList(cacheKey, page);
    } catch (e) {
      throw CacheException('Failed to get cached book list: $e');
    }
  }

  @override
  Future<void> cacheBookList({
    required BookListResponseModel response,
    String? search,
    List<String>? languages,
    String? topic,
    int? authorYearStart,
    int? authorYearEnd,
    String? sort,
    int page = 1,
  }) async {
    try {
      final cacheKey = databaseHelper.generateCacheKey(
        search: search,
        languages: languages,
        topic: topic,
        authorYearStart: authorYearStart,
        authorYearEnd: authorYearEnd,
        sort: sort,
      );
      await databaseHelper.cacheBookList(response, cacheKey, page);
    } catch (e) {
      throw CacheException('Failed to cache book list: $e');
    }
  }

  @override
  Future<BookModel?> getCachedBook(int id) async {
    try {
      return await databaseHelper.getCachedBook(id);
    } catch (e) {
      throw CacheException('Failed to get cached book: $e');
    }
  }

  @override
  Future<void> cacheBook(BookModel book) async {
    try {
      await databaseHelper.cacheBook(book);
    } catch (e) {
      throw CacheException('Failed to cache book: $e');
    }
  }

  @override
  Future<void> clearOldCache() async {
    try {
      await databaseHelper.clearOldCache();
    } catch (e) {
      throw CacheException('Failed to clear old cache: $e');
    }
  }

  @override
  Future<Map<String, int>> getCacheStats() async {
    try {
      return await databaseHelper.getCacheStats();
    } catch (e) {
      throw CacheException('Failed to get cache stats: $e');
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      await databaseHelper.clearAllCache();
    } catch (e) {
      throw CacheException('Failed to clear all cache: $e');
    }
  }
}
