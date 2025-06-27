import 'package:get/get.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_book_by_id.dart';
import '../../domain/usecases/bookmark_book.dart';
import '../../domain/usecases/remove_bookmark.dart';
import '../../domain/usecases/is_book_bookmarked.dart';
import '../../core/logging/app_logger.dart';
import 'home_controller.dart';
import 'bookmark_controller.dart';

class BookDetailController extends GetxController {
  final GetBookById _getBookById;
  final BookmarkBook _bookmarkBook;
  final RemoveBookmark _removeBookmark;
  final IsBookBookmarked _isBookBookmarked;

  BookDetailController({
    required GetBookById getBookById,
    required BookmarkBook bookmarkBook,
    required RemoveBookmark removeBookmark,
    required IsBookBookmarked isBookBookmarked,
  }) : _getBookById = getBookById,
       _bookmarkBook = bookmarkBook,
       _removeBookmark = removeBookmark,
       _isBookBookmarked = isBookBookmarked;

  // Observable states
  final Rxn<Book> _book = Rxn<Book>();
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isBookmarked = false.obs;

  // Getters for read-only access
  Book? get book => _book.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isBookmarked => _isBookmarked.value;

  // Reactive getters for UI
  Rxn<Book> get bookRx => _book;
  RxBool get isLoadingRx => _isLoading;
  RxString get errorMessageRx => _errorMessage;
  RxBool get isBookmarkedRx => _isBookmarked;

  @override
  void onInit() {
    super.onInit();
    AppLogger.instance.info(
      'BookDetailController initialized',
      tag: 'BookDetailController',
    );
  }

  @override
  void onClose() {
    AppLogger.instance.info(
      'BookDetailController disposed',
      tag: 'BookDetailController',
    );
    super.onClose();
  }

  Future<void> loadBookDetails(int bookId) async {
    final stopwatch = Stopwatch()..start();
    AppLogger.instance.info(
      'Loading book details for ID: $bookId',
      tag: 'BookDetailController',
    );

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final result = await _getBookById(bookId);

      result.fold(
        (failure) {
          AppLogger.instance.error(
            'Failed to load book details: ${failure.message}',
            tag: 'BookDetailController',
          );
          _errorMessage.value = failure.message;
          _isLoading.value = false;
        },
        (bookData) async {
          AppLogger.instance.info(
            'Book details loaded successfully: ${bookData.title}',
            tag: 'BookDetailController',
          );
          _book.value = bookData;
          _isLoading.value = false;

          // Check bookmark status asynchronously without blocking UI
          await _checkBookmarkStatus(bookId);
        },
      );
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        'Unexpected error loading book details',
        tag: 'BookDetailController',
        error: error,
        stackTrace: stackTrace,
      );
      _errorMessage.value = 'An unexpected error occurred';
      _isLoading.value = false;
    } finally {
      stopwatch.stop();
      AppLogger.instance.debug(
        'Book details loading completed in ${stopwatch.elapsedMilliseconds}ms',
        tag: 'BookDetailController',
      );
    }
  }

  Future<void> _checkBookmarkStatus(int bookId) async {
    AppLogger.instance.debug(
      'Checking bookmark status for book ID: $bookId',
      tag: 'BookDetailController',
    );

    try {
      final result = await _isBookBookmarked(bookId);
      result.fold(
        (failure) {
          AppLogger.instance.warning(
            'Failed to check bookmark status: ${failure.message}',
            tag: 'BookDetailController',
          );
          // Keep current bookmark state on error
        },
        (bookmarked) {
          AppLogger.instance.debug(
            'Bookmark status checked: $bookmarked',
            tag: 'BookDetailController',
          );
          _isBookmarked.value = bookmarked;
        },
      );
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        'Unexpected error checking bookmark status',
        tag: 'BookDetailController',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> toggleBookmark({
    Function(String)? onSuccess,
    Function(String)? onError,
  }) async {
    if (_book.value == null) {
      AppLogger.instance.warning(
        'Cannot toggle bookmark: book is null',
        tag: 'BookDetailController',
      );
      return;
    }

    final book = _book.value!;
    final wasBookmarked = _isBookmarked.value;
    AppLogger.instance.info(
      'Toggling bookmark for book: ${book.title} (current state: $wasBookmarked)',
      tag: 'BookDetailController',
    );

    try {
      if (wasBookmarked) {
        await _removeBookmarkAction(book, onSuccess, onError);
      } else {
        await _addBookmarkAction(book, onSuccess, onError);
      }
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        'Unexpected error toggling bookmark',
        tag: 'BookDetailController',
        error: error,
        stackTrace: stackTrace,
      );
      onError?.call('An unexpected error occurred');
    }
  }

  Future<void> _removeBookmarkAction(
    Book book,
    Function(String)? onSuccess,
    Function(String)? onError,
  ) async {
    AppLogger.instance.debug(
      'Removing bookmark for book: ${book.title}',
      tag: 'BookDetailController',
    );

    final result = await _removeBookmark(book.id);
    result.fold(
      (failure) {
        AppLogger.instance.error(
          'Failed to remove bookmark: ${failure.message}',
          tag: 'BookDetailController',
        );
        onError?.call(failure.message);
      },
      (success) {
        if (success) {
          AppLogger.instance.info(
            'Bookmark removed successfully for book: ${book.title}',
            tag: 'BookDetailController',
          );
          _isBookmarked.value = false;
          _syncWithOtherControllers(book, false);
          onSuccess?.call('Book removed from bookmarks');
        } else {
          AppLogger.instance.warning(
            'Bookmark removal returned false',
            tag: 'BookDetailController',
          );
          onError?.call('Failed to remove bookmark');
        }
      },
    );
  }

  Future<void> _addBookmarkAction(
    Book book,
    Function(String)? onSuccess,
    Function(String)? onError,
  ) async {
    AppLogger.instance.debug(
      'Adding bookmark for book: ${book.title}',
      tag: 'BookDetailController',
    );

    final result = await _bookmarkBook(book);
    result.fold(
      (failure) {
        AppLogger.instance.error(
          'Failed to add bookmark: ${failure.message}',
          tag: 'BookDetailController',
        );
        onError?.call(failure.message);
      },
      (success) {
        if (success) {
          AppLogger.instance.info(
            'Bookmark added successfully for book: ${book.title}',
            tag: 'BookDetailController',
          );
          _isBookmarked.value = true;
          _syncWithOtherControllers(book, true);
          onSuccess?.call('Book bookmarked successfully');
        } else {
          AppLogger.instance.warning(
            'Bookmark addition returned false',
            tag: 'BookDetailController',
          );
          onError?.call('Failed to add bookmark');
        }
      },
    );
  }

  void _syncWithOtherControllers(Book book, bool bookmarked) {
    AppLogger.instance.debug(
      'Syncing bookmark state with other controllers',
      tag: 'BookDetailController',
    );

    try {
      final homeController = Get.find<HomeController>();
      if (bookmarked) {
        homeController.bookmarkedBookIds.add(book.id);
      } else {
        homeController.bookmarkedBookIds.remove(book.id);
      }
      AppLogger.instance.debug(
        'HomeController synced successfully',
        tag: 'BookDetailController',
      );
    } catch (error) {
      AppLogger.instance.debug(
        'HomeController not found or not initialized',
        tag: 'BookDetailController',
      );
    }

    try {
      final bookmarkController = Get.find<BookmarkController>();
      bookmarkController.loadBookmarkedBooks();
      AppLogger.instance.debug(
        'BookmarkController synced successfully',
        tag: 'BookDetailController',
      );
    } catch (error) {
      AppLogger.instance.debug(
        'BookmarkController not found or not initialized',
        tag: 'BookDetailController',
      );
    }
  }

  void refreshBookDetails() {
    if (_book.value != null) {
      AppLogger.instance.info(
        'Refreshing book details for: ${_book.value!.title}',
        tag: 'BookDetailController',
      );
      loadBookDetails(_book.value!.id);
    }
  }

  void clearError() {
    AppLogger.instance.debug(
      'Clearing error message',
      tag: 'BookDetailController',
    );
    _errorMessage.value = '';
  }
}
