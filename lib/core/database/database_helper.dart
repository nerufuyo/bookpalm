import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/models/book_model.dart';
import '../../data/models/book_list_response_model.dart';

class DatabaseHelper {
  static const _databaseName = "bookpalm.db";
  static const _databaseVersion = 1;

  static const String tableCachedBooks = 'cached_books';
  static const String tableCachedBookLists = 'cached_book_lists';

  // Book columns
  static const String columnBookId = 'id';
  static const String columnBookData = 'book_data';
  static const String columnCachedAt = 'cached_at';

  // Book list columns
  static const String columnListKey = 'list_key';
  static const String columnListData = 'list_data';
  static const String columnListPage = 'page';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCachedBooks (
        $columnBookId INTEGER PRIMARY KEY,
        $columnBookData TEXT NOT NULL,
        $columnCachedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableCachedBookLists (
        $columnListKey TEXT PRIMARY KEY,
        $columnListData TEXT NOT NULL,
        $columnListPage INTEGER NOT NULL,
        $columnCachedAt INTEGER NOT NULL
      )
    ''');
  }

  // Cache a single book
  Future<int> cacheBook(BookModel book) async {
    Database db = await database;
    Map<String, dynamic> row = {
      columnBookId: book.id,
      columnBookData: json.encode(book.toJson()),
      columnCachedAt: DateTime.now().millisecondsSinceEpoch,
    };
    return await db.insert(
      tableCachedBooks,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get cached book by ID
  Future<BookModel?> getCachedBook(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableCachedBooks,
      where: '$columnBookId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      final bookData = json.decode(maps.first[columnBookData]);
      return BookModel.fromJson(bookData);
    }
    return null;
  }

  // Cache book list response
  Future<int> cacheBookList(
    BookListResponseModel response,
    String cacheKey,
    int page,
  ) async {
    Database db = await database;
    Map<String, dynamic> row = {
      columnListKey: cacheKey,
      columnListData: json.encode(response.toJson()),
      columnListPage: page,
      columnCachedAt: DateTime.now().millisecondsSinceEpoch,
    };

    // Cache individual books as well
    for (var book in response.results) {
      await cacheBook(book);
    }

    return await db.insert(
      tableCachedBookLists,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get cached book list
  Future<BookListResponseModel?> getCachedBookList(
    String cacheKey,
    int page,
  ) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableCachedBookLists,
      where: '$columnListKey = ? AND $columnListPage = ?',
      whereArgs: [cacheKey, page],
    );
    if (maps.isNotEmpty) {
      final listData = json.decode(maps.first[columnListData]);
      return BookListResponseModel.fromJson(listData);
    }
    return null;
  }

  // Generate cache key for book list requests
  String generateCacheKey({
    String? search,
    List<String>? languages,
    String? topic,
    int? authorYearStart,
    int? authorYearEnd,
    String? sort,
  }) {
    final params = {
      'search': search ?? '',
      'languages': languages?.join(',') ?? '',
      'topic': topic ?? '',
      'authorYearStart': authorYearStart?.toString() ?? '',
      'authorYearEnd': authorYearEnd?.toString() ?? '',
      'sort': sort ?? '',
    };
    return params.entries
        .where((e) => e.value.isNotEmpty)
        .map((e) => '${e.key}:${e.value}')
        .join('|');
  }

  // Clear old cache entries (older than 7 days)
  Future<void> clearOldCache() async {
    Database db = await database;
    final cutoffTime = DateTime.now()
        .subtract(const Duration(days: 7))
        .millisecondsSinceEpoch;

    await db.delete(
      tableCachedBooks,
      where: '$columnCachedAt < ?',
      whereArgs: [cutoffTime],
    );

    await db.delete(
      tableCachedBookLists,
      where: '$columnCachedAt < ?',
      whereArgs: [cutoffTime],
    );
  }

  // Get cache size info
  Future<Map<String, int>> getCacheStats() async {
    Database db = await database;

    final booksCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $tableCachedBooks'),
        ) ??
        0;

    final listsCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $tableCachedBookLists'),
        ) ??
        0;

    return {'cached_books': booksCount, 'cached_lists': listsCount};
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    Database db = await database;
    await db.delete(tableCachedBooks);
    await db.delete(tableCachedBookLists);
  }
}
