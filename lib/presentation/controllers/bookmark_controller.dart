import 'package:get/get.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_bookmarked_books.dart';
import '../../domain/usecases/bookmark_book.dart';
import '../../domain/usecases/remove_bookmark.dart';
import '../../core/usecases/usecase.dart';
import 'home_controller.dart';

class BookmarkController extends GetxController {
  final GetBookmarkedBooks getBookmarkedBooks;
  final BookmarkBook bookmarkBook;
  final RemoveBookmark removeBookmark;

  BookmarkController({
    required this.getBookmarkedBooks,
    required this.bookmarkBook,
    required this.removeBookmark,
  });

  // Observable states
  final RxList<Book> bookmarkedBooks = <Book>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarkedBooks();
  }

  Future<void> loadBookmarkedBooks() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getBookmarkedBooks(const NoParams());

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (books) {
        bookmarkedBooks.assignAll(books);
        isLoading.value = false;
      },
    );
  }

  Future<void> removeBookmarkById(
    Book book, {
    Function(String)? onSuccess,
    Function(String)? onError,
  }) async {
    // Remove from local list immediately for better UX
    bookmarkedBooks.removeWhere((b) => b.id == book.id);

    final result = await removeBookmark(book.id);

    result.fold(
      (failure) {
        // Add the book back to the list if removal failed
        bookmarkedBooks.add(book);
        if (onError != null) {
          onError(failure.message);
        }
      },
      (success) {
        if (success) {
          // Also update home controller if it exists
          try {
            final homeController = Get.find<HomeController>();
            homeController.bookmarkedBookIds.remove(book.id);
          } catch (e) {
            // HomeController not initialized, ignore
          }
          if (onSuccess != null) {
            onSuccess('Bookmark removed successfully');
          }
        }
      },
    );
  }

  Future<void> refreshBookmarks() async {
    await loadBookmarkedBooks();
  }
}
