import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get/get.dart';
import 'package:bookpalm/presentation/controllers/home_controller.dart';
import 'package:bookpalm/domain/usecases/get_books.dart';
import 'package:bookpalm/domain/usecases/bookmark_book.dart';
import 'package:bookpalm/domain/usecases/remove_bookmark.dart';
import 'package:bookpalm/domain/usecases/is_book_bookmarked.dart';
import 'package:bookpalm/domain/entities/book.dart';
import 'package:bookpalm/domain/entities/person.dart';
import 'package:bookpalm/domain/entities/book_list_response.dart';
import 'package:bookpalm/core/error/failures.dart';
import 'package:bookpalm/core/utils/either.dart';

@GenerateMocks([GetBooks, BookmarkBook, RemoveBookmark, IsBookBookmarked])
import 'home_controller_test.mocks.dart';

void main() {
  late HomeController controller;
  late MockGetBooks mockGetBooks;
  late MockBookmarkBook mockBookmarkBook;
  late MockRemoveBookmark mockRemoveBookmark;
  late MockIsBookBookmarked mockIsBookBookmarked;

  // Test data
  final testBooks = [
    Book(
      id: 1,
      title: 'Test Book 1',
      subjects: ['Fiction'],
      authors: [Person(name: 'Author 1', birthYear: 1900, deathYear: 1980)],
      bookshelves: ['Popular Books'],
      languages: ['en'],
      copyright: false,
      mediaType: 'Text',
      formats: {'text/html': 'https://example.com/book1.html'},
      downloadCount: 1000,
    ),
    Book(
      id: 2,
      title: 'Test Book 2',
      subjects: ['History'],
      authors: [Person(name: 'Author 2', birthYear: 1950, deathYear: null)],
      bookshelves: ['History Collection'],
      languages: ['en', 'fr'],
      copyright: true,
      mediaType: 'Text',
      formats: {'text/html': 'https://example.com/book2.html'},
      downloadCount: 2000,
    ),
  ];

  final testBookListResponse = BookListResponse(
    count: 2,
    next: null,
    previous: null,
    results: testBooks,
  );

  final testBookListResponseWithNext = BookListResponse(
    count: 10,
    next: 'https://example.com/books?page=2',
    previous: null,
    results: testBooks,
  );

  setUp(() {
    // Initialize mocks
    mockGetBooks = MockGetBooks();
    mockBookmarkBook = MockBookmarkBook();
    mockRemoveBookmark = MockRemoveBookmark();
    mockIsBookBookmarked = MockIsBookBookmarked();

    // Create controller with mocks
    controller = HomeController(
      getBooks: mockGetBooks,
      bookmarkBook: mockBookmarkBook,
      removeBookmark: mockRemoveBookmark,
      isBookBookmarked: mockIsBookBookmarked,
    );

    // Initialize GetX for testing
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeController', () {
    group('initialization', () {
      test('should initialize with default values', () {
        expect(controller.books, isEmpty);
        expect(controller.isLoading.value, isFalse);
        expect(controller.errorMessage.value, isEmpty);
        expect(controller.searchQuery.value, isEmpty);
        expect(controller.hasMore.value, isTrue);
        expect(controller.currentPage.value, equals(1));
        expect(controller.bookmarkedBookIds, isEmpty);
        expect(controller.selectedLanguages, isEmpty);
        expect(controller.selectedSort.value, equals('popular'));
        expect(controller.selectedCategory.value, equals('popular'));
      });

      test('should have correct categories list', () {
        expect(controller.categories, contains('popular'));
        expect(controller.categories, contains('fiction'));
        expect(controller.categories, contains('history'));
        expect(controller.categories, contains('science'));
        expect(controller.categories, contains('philosophy'));
        expect(controller.categories, contains('children'));
      });
    });

    group('loadBooks', () {
      test('should load books successfully', () async {
        // Arrange
        when(
          mockGetBooks(any),
        ).thenAnswer((_) async => Either.right(testBookListResponse));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act
        await controller.loadBooks();

        // Assert
        expect(controller.books.length, equals(2));
        expect(controller.books[0].title, equals('Test Book 1'));
        expect(controller.books[1].title, equals('Test Book 2'));
        expect(controller.isLoading.value, isFalse);
        expect(controller.errorMessage.value, isEmpty);
        expect(controller.hasMore.value, isFalse);
        expect(controller.currentPage.value, equals(2));
        verify(mockGetBooks(any)).called(1);
      });

      test('should handle load books failure', () async {
        // Arrange
        const failure = ServerFailure('Network error');
        when(mockGetBooks(any)).thenAnswer((_) async => Either.left(failure));

        // Act
        await controller.loadBooks();

        // Assert
        expect(controller.books, isEmpty);
        expect(controller.isLoading.value, isFalse);
        expect(controller.errorMessage.value, equals('Network error'));
        verify(mockGetBooks(any)).called(1);
      });

      test('should refresh books when isRefresh is true', () async {
        // Arrange
        controller.books.addAll(testBooks);
        controller.currentPage.value = 3;
        controller.hasMore.value = false;

        when(
          mockGetBooks(any),
        ).thenAnswer((_) async => Either.right(testBookListResponse));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act
        await controller.loadBooks(isRefresh: true);

        // Assert
        expect(controller.currentPage.value, equals(2));
        expect(controller.hasMore.value, isFalse);
        verify(mockGetBooks(any)).called(1);
      });

      test('should load more books when hasMore is true', () async {
        // Arrange
        controller.books.addAll([testBooks.first]);
        controller.currentPage.value = 2;
        controller.hasMore.value = true;

        when(
          mockGetBooks(any),
        ).thenAnswer((_) async => Either.right(testBookListResponse));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act
        await controller.loadBooks();

        // Assert
        expect(controller.books.length, equals(3)); // 1 + 2 new books
        expect(controller.currentPage.value, equals(3));
      });

      test(
        'should not load when hasMore is false and not refreshing',
        () async {
          // Arrange
          controller.hasMore.value = false;

          // Act
          await controller.loadBooks();

          // Assert
          verifyNever(mockGetBooks(any));
        },
      );

      test('should set hasMore correctly based on response', () async {
        // Arrange
        when(
          mockGetBooks(any),
        ).thenAnswer((_) async => Either.right(testBookListResponseWithNext));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act
        await controller.loadBooks();

        // Assert
        expect(controller.hasMore.value, isTrue);
      });
    });

    group('searchBooks', () {
      test('should set search query and load books', () async {
        // Arrange
        when(
          mockGetBooks(any),
        ).thenAnswer((_) async => Either.right(testBookListResponse));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act
        await controller.searchBooks('test query');

        // Assert
        expect(controller.searchQuery.value, equals('test query'));
        verify(mockGetBooks(any)).called(1);
      });
    });

    group('selectCategory', () {
      test('should set category and clear search query', () async {
        // Arrange
        controller.searchQuery.value = 'existing query';
        when(
          mockGetBooks(any),
        ).thenAnswer((_) async => Either.right(testBookListResponse));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act
        await controller.selectCategory('fiction');

        // Assert
        expect(controller.selectedCategory.value, equals('fiction'));
        expect(controller.searchQuery.value, isEmpty);
        verify(mockGetBooks(any)).called(1);
      });
    });

    group('applyFilters', () {
      test('should apply filters and load books', () async {
        // Arrange
        when(
          mockGetBooks(any),
        ).thenAnswer((_) async => Either.right(testBookListResponse));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act
        await controller.applyFilters(
          languages: ['en', 'fr'],
          sort: 'title',
          authorYearStart: 1800,
          authorYearEnd: 2000,
        );

        // Assert
        expect(controller.selectedLanguages, equals(['en', 'fr']));
        expect(controller.selectedSort.value, equals('title'));
        expect(controller.authorYearStart.value, equals(1800));
        expect(controller.authorYearEnd.value, equals(2000));
        verify(mockGetBooks(any)).called(1);
      });

      test('should handle null filter values', () async {
        // Arrange
        when(
          mockGetBooks(any),
        ).thenAnswer((_) async => Either.right(testBookListResponse));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act
        await controller.applyFilters();

        // Assert
        expect(controller.selectedLanguages, isEmpty);
        expect(controller.selectedSort.value, equals('popular'));
        expect(controller.authorYearStart.value, isNull);
        expect(controller.authorYearEnd.value, isNull);
      });
    });

    group('toggleBookmark', () {
      test('should add bookmark when book is not bookmarked', () async {
        // Arrange
        final book = testBooks.first;
        when(
          mockBookmarkBook(book),
        ).thenAnswer((_) async => Either.right(true));

        String? successMessage;
        String? errorMessage;

        // Act
        await controller.toggleBookmark(
          book,
          onSuccess: (message) => successMessage = message,
          onError: (message) => errorMessage = message,
        );

        // Assert
        expect(controller.bookmarkedBookIds.contains(book.id), isTrue);
        expect(successMessage, equals('Book bookmarked successfully'));
        expect(errorMessage, isNull);
        verify(mockBookmarkBook(book)).called(1);
      });

      test('should remove bookmark when book is bookmarked', () async {
        // Arrange
        final book = testBooks.first;
        controller.bookmarkedBookIds.add(book.id);
        when(
          mockRemoveBookmark(book.id),
        ).thenAnswer((_) async => Either.right(true));

        String? successMessage;
        String? errorMessage;

        // Act
        await controller.toggleBookmark(
          book,
          onSuccess: (message) => successMessage = message,
          onError: (message) => errorMessage = message,
        );

        // Assert
        expect(controller.bookmarkedBookIds.contains(book.id), isFalse);
        expect(successMessage, equals('Book removed from bookmarks'));
        expect(errorMessage, isNull);
        verify(mockRemoveBookmark(book.id)).called(1);
      });

      test('should handle bookmark failure', () async {
        // Arrange
        final book = testBooks.first;
        const failure = CacheFailure('Storage error');
        when(
          mockBookmarkBook(book),
        ).thenAnswer((_) async => Either.left(failure));

        String? successMessage;
        String? errorMessage;

        // Act
        await controller.toggleBookmark(
          book,
          onSuccess: (message) => successMessage = message,
          onError: (message) => errorMessage = message,
        );

        // Assert
        expect(controller.bookmarkedBookIds.contains(book.id), isFalse);
        expect(successMessage, isNull);
        expect(errorMessage, equals('Storage error'));
      });
    });

    group('bookmark status checks', () {
      test('should check bookmark status successfully', () async {
        // Arrange
        final book = testBooks.first;
        when(
          mockIsBookBookmarked(book.id),
        ).thenAnswer((_) async => Either.right(true));

        // Act
        await controller.checkBookmarkStatus(book);

        // Assert
        expect(controller.bookmarkedBookIds.contains(book.id), isTrue);
        verify(mockIsBookBookmarked(book.id)).called(1);
      });

      test('should handle bookmark status check failure gracefully', () async {
        // Arrange
        final book = testBooks.first;
        when(
          mockIsBookBookmarked(book.id),
        ).thenAnswer((_) async => Either.left(CacheFailure('Error')));

        // Act
        await controller.checkBookmarkStatus(book);

        // Assert
        expect(controller.bookmarkedBookIds.contains(book.id), isFalse);
      });

      test('should load bookmark statuses for all books', () async {
        // Arrange
        controller.books.addAll(testBooks);
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act
        await controller.loadBookmarkStatuses();

        // Assert
        verify(mockIsBookBookmarked(1)).called(1);
        verify(mockIsBookBookmarked(2)).called(1);
      });
    });

    group('utility methods', () {
      test('isBookmarked should return correct status', () {
        // Arrange
        final book = testBooks.first;
        controller.bookmarkedBookIds.add(book.id);

        // Act & Assert
        expect(controller.isBookmarked(book), isTrue);

        controller.bookmarkedBookIds.remove(book.id);
        expect(controller.isBookmarked(book), isFalse);
      });

      test('loadMoreBooks should load more when conditions are met', () async {
        // Arrange
        controller.isLoading.value = false;
        controller.hasMore.value = true;
        when(
          mockGetBooks(any),
        ).thenAnswer((_) async => Either.right(testBookListResponse));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act
        controller.loadMoreBooks();

        // Allow async operation to complete
        await Future.delayed(Duration.zero);

        // Assert
        verify(mockGetBooks(any)).called(1);
      });

      test('loadMoreBooks should not load when loading', () {
        // Arrange
        controller.isLoading.value = true;
        controller.hasMore.value = true;

        // Act
        controller.loadMoreBooks();

        // Assert
        verifyNever(mockGetBooks(any));
      });

      test('loadMoreBooks should not load when no more books', () {
        // Arrange
        controller.isLoading.value = false;
        controller.hasMore.value = false;

        // Act
        controller.loadMoreBooks();

        // Assert
        verifyNever(mockGetBooks(any));
      });
    });

    group('reactive properties', () {
      test('should update reactive properties correctly', () {
        // Act & Assert
        controller.isLoading.value = true;
        expect(controller.isLoading.value, isTrue);

        controller.errorMessage.value = 'Test error';
        expect(controller.errorMessage.value, equals('Test error'));

        controller.searchQuery.value = 'search term';
        expect(controller.searchQuery.value, equals('search term'));

        controller.hasMore.value = false;
        expect(controller.hasMore.value, isFalse);

        controller.currentPage.value = 5;
        expect(controller.currentPage.value, equals(5));

        controller.selectedSort.value = 'title';
        expect(controller.selectedSort.value, equals('title'));

        controller.selectedCategory.value = 'fiction';
        expect(controller.selectedCategory.value, equals('fiction'));
      });
    });
  });
}
