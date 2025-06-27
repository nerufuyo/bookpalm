import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_model.dart';
import 'book_local_data_source.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/storage_constants.dart';

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final SharedPreferences sharedPreferences;

  BookLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<BookModel>> getBookmarkedBooks() async {
    try {
      final jsonString = sharedPreferences.getString(StorageConstants.bookmarkedBooksKey);
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
      final jsonString = json.encode(bookmarkedBooks.map((b) => b.toJson()).toList());
      
      return await sharedPreferences.setString(StorageConstants.bookmarkedBooksKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to bookmark book: $e');
    }
  }

  @override
  Future<bool> removeBookmark(int bookId) async {
    try {
      final bookmarkedBooks = await getBookmarkedBooks();
      bookmarkedBooks.removeWhere((book) => book.id == bookId);
      
      final jsonString = json.encode(bookmarkedBooks.map((b) => b.toJson()).toList());
      
      return await sharedPreferences.setString(StorageConstants.bookmarkedBooksKey, jsonString);
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
}
