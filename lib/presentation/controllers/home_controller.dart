import 'package:get/get.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_books.dart';
import '../../domain/usecases/bookmark_book.dart';

class HomeController extends GetxController {
  final GetBooks getBooks;
  final BookmarkBook bookmarkBook;

  HomeController({
    required this.getBooks,
    required this.bookmarkBook,
  });

  // Observable states
  final RxList<Book> books = <Book>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;

  // Book categories
  final RxString selectedCategory = 'popular'.obs;
  final List<String> categories = [
    'popular',
    'fiction',
    'history',
    'science',
    'philosophy',
    'children',
  ];

  @override
  void onInit() {
    super.onInit();
    loadBooks();
  }

  Future<void> loadBooks({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      hasMore.value = true;
      books.clear();
    }

    if (!hasMore.value && !isRefresh) return;

    isLoading.value = true;
    errorMessage.value = '';

    final params = GetBooksParams(
      search: searchQuery.value.isEmpty ? null : searchQuery.value,
      topic: selectedCategory.value == 'popular' ? null : selectedCategory.value,
      sort: selectedCategory.value == 'popular' ? 'popular' : null,
      page: currentPage.value,
    );

    final result = await getBooks(params);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (bookListResponse) {
        if (isRefresh) {
          books.assignAll(bookListResponse.results);
        } else {
          books.addAll(bookListResponse.results);
        }
        
        hasMore.value = bookListResponse.next != null;
        currentPage.value++;
        isLoading.value = false;
      },
    );
  }

  Future<void> searchBooks(String query) async {
    searchQuery.value = query;
    await loadBooks(isRefresh: true);
  }

  Future<void> selectCategory(String category) async {
    selectedCategory.value = category;
    searchQuery.value = '';
    await loadBooks(isRefresh: true);
  }

  Future<void> toggleBookmark(Book book) async {
    final result = await bookmarkBook(book);
    
    result.fold(
      (failure) {
        Get.snackbar('Error', failure.message);
      },
      (success) {
        if (success) {
          Get.snackbar('Success', 'Book bookmarked successfully');
        }
      },
    );
  }

  void loadMoreBooks() {
    if (!isLoading.value && hasMore.value) {
      loadBooks();
    }
  }
}
