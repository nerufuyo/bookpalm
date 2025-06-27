import 'package:get/get.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_books.dart';
import '../../domain/usecases/bookmark_book.dart';
import '../../domain/usecases/is_book_bookmarked.dart';
import '../../domain/usecases/remove_bookmark.dart';
import 'bookmark_controller.dart';

class HomeController extends GetxController {
  final GetBooks getBooks;
  final BookmarkBook bookmarkBook;
  final IsBookBookmarked isBookBookmarked;
  final RemoveBookmark removeBookmark;

  HomeController({
    required this.getBooks,
    required this.bookmarkBook,
    required this.isBookBookmarked,
    required this.removeBookmark,
  });

  // Observable states
  final RxList<Book> books = <Book>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;
  final RxSet<int> bookmarkedBookIds = <int>{}.obs;

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
      topic: selectedCategory.value == 'popular'
          ? null
          : selectedCategory.value,
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
      (bookListResponse) async {
        if (isRefresh) {
          books.assignAll(bookListResponse.results);
        } else {
          books.addAll(bookListResponse.results);
        }

        hasMore.value = bookListResponse.next != null;
        currentPage.value++;
        isLoading.value = false;

        // Load bookmark statuses for new books
        await loadBookmarkStatuses();
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

  Future<void> toggleBookmark(
    Book book, {
    Function(String)? onSuccess,
    Function(String)? onError,
  }) async {
    final isCurrentlyBookmarked = bookmarkedBookIds.contains(book.id);

    if (isCurrentlyBookmarked) {
      final result = await removeBookmark(book.id);

      result.fold(
        (failure) {
          if (onError != null) {
            onError(failure.message);
          }
        },
        (success) {
          if (success) {
            // Remove from bookmarked set
            bookmarkedBookIds.remove(book.id);
            // Also refresh bookmark controller if it exists
            try {
              final bookmarkController = Get.find<BookmarkController>();
              bookmarkController.loadBookmarkedBooks();
            } catch (e) {
              // BookmarkController not initialized, ignore
            }
            if (onSuccess != null) {
              onSuccess('Book removed from bookmarks');
            }
          }
        },
      );
      return;
    }

    final result = await bookmarkBook(book);

    result.fold(
      (failure) {
        if (onError != null) {
          onError(failure.message);
        }
      },
      (success) {
        if (success) {
          // Add to bookmarked set
          bookmarkedBookIds.add(book.id);
          // Also refresh bookmark controller if it exists
          try {
            final bookmarkController = Get.find<BookmarkController>();
            bookmarkController.loadBookmarkedBooks();
          } catch (e) {
            // BookmarkController not initialized, ignore
          }
          if (onSuccess != null) {
            onSuccess('Book bookmarked successfully');
          }
        }
      },
    );
  }

  Future<void> checkBookmarkStatus(Book book) async {
    final result = await isBookBookmarked(book.id);
    result.fold(
      (failure) {
        // Handle error silently for bookmark status check
      },
      (isBookmarked) {
        if (isBookmarked) {
          bookmarkedBookIds.add(book.id);
        } else {
          bookmarkedBookIds.remove(book.id);
        }
      },
    );
  }

  Future<void> loadBookmarkStatuses() async {
    for (final book in books) {
      await checkBookmarkStatus(book);
    }
  }

  bool isBookmarked(Book book) {
    return bookmarkedBookIds.contains(book.id);
  }

  void loadMoreBooks() {
    if (!isLoading.value && hasMore.value) {
      loadBooks();
    }
  }
}
