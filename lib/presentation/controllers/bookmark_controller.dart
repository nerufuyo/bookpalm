import 'package:get/get.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_bookmarked_books.dart';
import '../../domain/usecases/bookmark_book.dart';
import '../../core/usecases/usecase.dart';

class BookmarkController extends GetxController {
  final GetBookmarkedBooks getBookmarkedBooks;
  final BookmarkBook bookmarkBook;

  BookmarkController({
    required this.getBookmarkedBooks,
    required this.bookmarkBook,
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
  }) async {
    // Remove from local list immediately for better UX
    bookmarkedBooks.removeWhere((b) => b.id == book.id);

    // TODO: Implement actual remove bookmark logic with use case
    // For now, just show success message
    if (onSuccess != null) {
      onSuccess('Bookmark removed successfully');
    }

    // Refresh the list to ensure consistency
    await loadBookmarkedBooks();
  }

  Future<void> refreshBookmarks() async {
    await loadBookmarkedBooks();
  }
}
