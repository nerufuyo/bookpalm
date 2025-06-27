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

  Future<void> removeBookmark(Book book) async {
    // This will be implemented when we add the remove bookmark use case
    // For now, we'll just refresh the list
    await loadBookmarkedBooks();
  }
}
