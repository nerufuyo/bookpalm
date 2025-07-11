import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

// Data sources
import '../../data/datasources/book_remote_data_source.dart';
import '../../data/datasources/book_remote_data_source_impl.dart';
import '../../data/datasources/book_local_data_source.dart';
import '../../data/datasources/book_local_data_source_impl.dart';

// Repositories
import '../../domain/repositories/book_repository.dart';
import '../../data/repositories/book_repository_impl.dart';

// Use cases
import '../../domain/usecases/get_books.dart';
import '../../domain/usecases/get_bookmarked_books.dart';
import '../../domain/usecases/bookmark_book.dart';
import '../../domain/usecases/is_book_bookmarked.dart';
import '../../domain/usecases/remove_bookmark.dart';
import '../../domain/usecases/get_book_by_id.dart';

// Core
import '../network/network_info.dart';
import '../network/network_info_impl.dart';
import '../database/database_helper.dart';
import '../services/connection_service.dart';

// Controllers
import '../../presentation/controllers/home_controller.dart';
import '../../presentation/controllers/bookmark_controller.dart';
import '../../presentation/controllers/book_detail_controller.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Controllers
  sl.registerLazySingleton(
    () => HomeController(
      getBooks: sl(),
      bookmarkBook: sl(),
      isBookBookmarked: sl(),
      removeBookmark: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => BookmarkController(
      getBookmarkedBooks: sl(),
      bookmarkBook: sl(),
      removeBookmark: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => BookDetailController(
      getBookById: sl(),
      bookmarkBook: sl(),
      removeBookmark: sl(),
      isBookBookmarked: sl(),
    ),
  );

  //! Use cases
  sl.registerLazySingleton(() => GetBooks(sl()));
  sl.registerLazySingleton(() => GetBookmarkedBooks(sl()));
  sl.registerLazySingleton(() => BookmarkBook(sl()));
  sl.registerLazySingleton(() => IsBookBookmarked(sl()));
  sl.registerLazySingleton(() => RemoveBookmark(sl()));
  sl.registerLazySingleton(() => GetBookById(sl()));

  //! Repository
  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //! Data sources
  sl.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<BookLocalDataSource>(
    () =>
        BookLocalDataSourceImpl(sharedPreferences: sl(), databaseHelper: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => DatabaseHelper.instance);
  sl.registerLazySingleton(() => ConnectionService());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
