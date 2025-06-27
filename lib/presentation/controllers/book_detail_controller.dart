import 'package:get/get.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_book_by_id.dart';
import '../../domain/usecases/bookmark_book.dart';
import '../../domain/usecases/remove_bookmark.dart';
import '../../domain/usecases/is_book_bookmarked.dart';
import 'home_controller.dart';
import 'bookmark_controller.dart';

class BookDetailController extends GetxController {
  final GetBookById getBookById;
  final BookmarkBook bookmarkBook;
  final RemoveBookmark removeBookmark;
  final IsBookBookmarked isBookBookmarked;

  BookDetailController({
    required this.getBookById,
    required this.bookmarkBook,
    required this.removeBookmark,
    required this.isBookBookmarked,
  });

  // Observable states
  final Rxn<Book> book = Rxn<Book>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isBookmarked = false.obs;

  Future<void> loadBookDetails(int bookId) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getBookById(bookId);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (bookData) async {
        book.value = bookData;
        isLoading.value = false;
        // Check bookmark status
        await checkBookmarkStatus(bookId);
      },
    );
  }

  Future<void> checkBookmarkStatus(int bookId) async {
    final result = await isBookBookmarked(bookId);
    result.fold(
      (failure) {
        // Handle error silently
      },
      (bookmarked) {
        isBookmarked.value = bookmarked;
      },
    );
  }

  Future<void> toggleBookmark({
    Function(String)? onSuccess,
    Function(String)? onError,
  }) async {
    if (book.value == null) return;

    if (isBookmarked.value) {
      // Remove bookmark
      final result = await removeBookmark(book.value!.id);
      result.fold(
        (failure) {
          if (onError != null) {
            onError(failure.message);
          }
        },
        (success) {
          if (success) {
            isBookmarked.value = false;
            // Sync with other controllers
            _syncWithOtherControllers(book.value!, false);
            if (onSuccess != null) {
              onSuccess('Book removed from bookmarks');
            }
          }
        },
      );
    } else {
      // Add bookmark
      final result = await bookmarkBook(book.value!);
      result.fold(
        (failure) {
          if (onError != null) {
            onError(failure.message);
          }
        },
        (success) {
          if (success) {
            isBookmarked.value = true;
            // Sync with other controllers
            _syncWithOtherControllers(book.value!, true);
            if (onSuccess != null) {
              onSuccess('Book bookmarked successfully');
            }
          }
        },
      );
    }
  }

  void _syncWithOtherControllers(Book book, bool bookmarked) {
    try {
      final homeController = Get.find<HomeController>();
      if (bookmarked) {
        homeController.bookmarkedBookIds.add(book.id);
      } else {
        homeController.bookmarkedBookIds.remove(book.id);
      }
    } catch (e) {
      // HomeController not initialized, ignore
    }

    try {
      final bookmarkController = Get.find<BookmarkController>();
      bookmarkController.loadBookmarkedBooks();
    } catch (e) {
      // BookmarkController not initialized, ignore
    }
  }
}
