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

  // Filter states
  final RxList<String> selectedLanguages = <String>[].obs;
  final RxString selectedSort = 'popular'.obs;
  final RxnInt authorYearStart = RxnInt();
  final RxnInt authorYearEnd = RxnInt();

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
      sort: selectedSort.value == 'popular' ? 'popular' : selectedSort.value,
      languages: selectedLanguages.isEmpty ? null : selectedLanguages.toList(),
      authorYearStart: authorYearStart.value,
      authorYearEnd: authorYearEnd.value,
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

  Future<void> applyFilters({
    List<String>? languages,
    String? sort,
    int? authorYearStart,
    int? authorYearEnd,
  }) async {
    selectedLanguages.assignAll(languages ?? []);
    selectedSort.value = sort ?? 'popular';
    this.authorYearStart.value = authorYearStart;
    this.authorYearEnd.value = authorYearEnd;
    
    await loadBooks(isRefresh: true);
  }

  Future<void> toggleBookmark(Book book) async {
    final result = await bookmarkBook(book);
    
    result.fold(
      (failure) {
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (success) {
        if (success) {
          Get.snackbar(
            'Success', 
            'Book bookmarked successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
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
