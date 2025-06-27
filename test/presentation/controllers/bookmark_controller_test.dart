import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get/get.dart';
import 'package:bookpalm/presentation/controllers/bookmark_controller.dart';
import 'package:bookpalm/domain/usecases/get_bookmarked_books.dart';
import 'package:bookpalm/domain/usecases/bookmark_book.dart';
import 'package:bookpalm/domain/usecases/remove_bookmark.dart';
import 'package:bookpalm/domain/entities/book.dart';
import 'package:bookpalm/domain/entities/person.dart';
import 'package:bookpalm/core/error/failures.dart';
import 'package:bookpalm/core/utils/either.dart';
import 'package:bookpalm/core/usecases/usecase.dart';

@GenerateMocks([GetBookmarkedBooks, BookmarkBook, RemoveBookmark])
import 'bookmark_controller_test.mocks.dart';

void main() {
  late BookmarkController controller;
  late MockGetBookmarkedBooks mockGetBookmarkedBooks;
  late MockBookmarkBook mockBookmarkBook;
  late MockRemoveBookmark mockRemoveBookmark;

  // Test data
  final testBooks = [
    Book(
      id: 1,
      title: 'Bookmarked Book 1',
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
      title: 'Bookmarked Book 2',
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

  setUp(() {
    // Initialize mocks
    mockGetBookmarkedBooks = MockGetBookmarkedBooks();
    mockBookmarkBook = MockBookmarkBook();
    mockRemoveBookmark = MockRemoveBookmark();

    // Create controller with mocks
    controller = BookmarkController(
      getBookmarkedBooks: mockGetBookmarkedBooks,
      bookmarkBook: mockBookmarkBook,
      removeBookmark: mockRemoveBookmark,
    );

    // Initialize GetX for testing
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('BookmarkController', () {
    group('initialization', () {
      test('should initialize with default values', () {
        expect(controller.bookmarkedBooks, isEmpty);
        expect(controller.isLoading.value, isFalse);
        expect(controller.errorMessage.value, isEmpty);
      });
    });

    group('loadBookmarkedBooks', () {
      test('should load bookmarked books successfully', () async {
        // Arrange
        when(
          mockGetBookmarkedBooks(const NoParams()),
        ).thenAnswer((_) async => Either.right(testBooks));

        // Act
        await controller.loadBookmarkedBooks();

        // Assert
        expect(controller.bookmarkedBooks.length, equals(2));
        expect(
          controller.bookmarkedBooks[0].title,
          equals('Bookmarked Book 1'),
        );
        expect(
          controller.bookmarkedBooks[1].title,
          equals('Bookmarked Book 2'),
        );
        expect(controller.isLoading.value, isFalse);
        expect(controller.errorMessage.value, isEmpty);
        verify(mockGetBookmarkedBooks(const NoParams())).called(1);
      });

      test('should handle load bookmarked books failure', () async {
        // Arrange
        const failure = CacheFailure('Database error');
        when(
          mockGetBookmarkedBooks(const NoParams()),
        ).thenAnswer((_) async => Either.left(failure));

        // Act
        await controller.loadBookmarkedBooks();

        // Assert
        expect(controller.bookmarkedBooks, isEmpty);
        expect(controller.isLoading.value, isFalse);
        expect(controller.errorMessage.value, equals('Database error'));
        verify(mockGetBookmarkedBooks(const NoParams())).called(1);
      });

      test('should set loading state correctly during operation', () async {
        // Arrange
        when(
          mockGetBookmarkedBooks(const NoParams()),
        ).thenAnswer((_) async => Either.right(testBooks));

        // Act & Assert
        expect(controller.isLoading.value, isFalse);

        final future = controller.loadBookmarkedBooks();
        expect(controller.isLoading.value, isTrue);

        await future;
        expect(controller.isLoading.value, isFalse);
      });

      test('should replace existing books when loading', () async {
        // Arrange
        controller.bookmarkedBooks.add(testBooks.first);
        final newBooks = [testBooks.last];

        when(
          mockGetBookmarkedBooks(const NoParams()),
        ).thenAnswer((_) async => Either.right(newBooks));

        // Act
        await controller.loadBookmarkedBooks();

        // Assert
        expect(controller.bookmarkedBooks.length, equals(1));
        expect(controller.bookmarkedBooks.first.id, equals(2));
      });
    });

    group('removeBookmarkById', () {
      setUp(() {
        // Pre-populate bookmarked books
        controller.bookmarkedBooks.addAll(testBooks);
      });

      test('should remove bookmark successfully', () async {
        // Arrange
        final bookToRemove = testBooks.first;
        when(
          mockRemoveBookmark(bookToRemove.id),
        ).thenAnswer((_) async => Either.right(true));

        String? successMessage;
        String? errorMessage;

        // Act
        await controller.removeBookmarkById(
          bookToRemove,
          onSuccess: (message) => successMessage = message,
          onError: (message) => errorMessage = message,
        );

        // Assert
        expect(controller.bookmarkedBooks.length, equals(1));
        expect(
          controller.bookmarkedBooks.any((book) => book.id == bookToRemove.id),
          isFalse,
        );
        expect(successMessage, equals('Bookmark removed successfully'));
        expect(errorMessage, isNull);
        verify(mockRemoveBookmark(bookToRemove.id)).called(1);
      });

      test('should handle remove bookmark failure', () async {
        // Arrange
        final bookToRemove = testBooks.first;
        const failure = CacheFailure('Remove failed');
        when(
          mockRemoveBookmark(bookToRemove.id),
        ).thenAnswer((_) async => Either.left(failure));

        String? successMessage;
        String? errorMessage;

        // Act
        await controller.removeBookmarkById(
          bookToRemove,
          onSuccess: (message) => successMessage = message,
          onError: (message) => errorMessage = message,
        );

        // Assert
        // Book should be added back to the list
        expect(controller.bookmarkedBooks.length, equals(2));
        expect(
          controller.bookmarkedBooks.any((book) => book.id == bookToRemove.id),
          isTrue,
        );
        expect(successMessage, isNull);
        expect(errorMessage, equals('Remove failed'));
        verify(mockRemoveBookmark(bookToRemove.id)).called(1);
      });

      test('should immediately remove book from list for better UX', () async {
        // Arrange
        final bookToRemove = testBooks.first;
        final initialCount = controller.bookmarkedBooks.length;

        // Don't mock the remove call to simulate delayed response
        when(mockRemoveBookmark(bookToRemove.id)).thenAnswer((_) async {
          // Simulate delay
          await Future.delayed(const Duration(milliseconds: 100));
          return Either.right(true);
        });

        // Act
        final future = controller.removeBookmarkById(bookToRemove);

        // Assert - book should be removed immediately
        expect(controller.bookmarkedBooks.length, equals(initialCount - 1));
        expect(
          controller.bookmarkedBooks.any((book) => book.id == bookToRemove.id),
          isFalse,
        );

        // Wait for the operation to complete
        await future;
      });

      test('should handle remove operation returning false', () async {
        // Arrange
        final bookToRemove = testBooks.first;
        when(
          mockRemoveBookmark(bookToRemove.id),
        ).thenAnswer((_) async => Either.right(false));

        String? successMessage;
        String? errorMessage;

        // Act
        await controller.removeBookmarkById(
          bookToRemove,
          onSuccess: (message) => successMessage = message,
          onError: (message) => errorMessage = message,
        );

        // Assert
        expect(controller.bookmarkedBooks.length, equals(1));
        expect(successMessage, isNull);
        expect(errorMessage, isNull);
      });
    });

    group('refreshBookmarks', () {
      test('should call loadBookmarkedBooks', () async {
        // Arrange
        when(
          mockGetBookmarkedBooks(const NoParams()),
        ).thenAnswer((_) async => Either.right(testBooks));

        // Act
        await controller.refreshBookmarks();

        // Assert
        verify(mockGetBookmarkedBooks(const NoParams())).called(1);
        expect(controller.bookmarkedBooks.length, equals(2));
      });
    });

    group('reactive properties', () {
      test('should update reactive properties correctly', () {
        // Act & Assert
        controller.isLoading.value = true;
        expect(controller.isLoading.value, isTrue);

        controller.errorMessage.value = 'Test error';
        expect(controller.errorMessage.value, equals('Test error'));

        controller.bookmarkedBooks.add(testBooks.first);
        expect(controller.bookmarkedBooks.length, equals(1));
        expect(
          controller.bookmarkedBooks.first.title,
          equals('Bookmarked Book 1'),
        );
      });
    });

    group('edge cases', () {
      test('should handle empty bookmarks list', () async {
        // Arrange
        when(
          mockGetBookmarkedBooks(const NoParams()),
        ).thenAnswer((_) async => Either.right([]));

        // Act
        await controller.loadBookmarkedBooks();

        // Assert
        expect(controller.bookmarkedBooks, isEmpty);
        expect(controller.isLoading.value, isFalse);
        expect(controller.errorMessage.value, isEmpty);
      });

      test('should handle removing non-existent book', () async {
        // Arrange
        final nonExistentBook = Book(
          id: 999,
          title: 'Non-existent Book',
          subjects: [],
          authors: [],
          bookshelves: [],
          languages: ['en'],
          copyright: false,
          mediaType: 'Text',
          formats: {},
          downloadCount: 0,
        );

        controller.bookmarkedBooks.addAll(testBooks);
        final initialCount = controller.bookmarkedBooks.length;

        when(
          mockRemoveBookmark(nonExistentBook.id),
        ).thenAnswer((_) async => Either.right(true));

        // Act
        await controller.removeBookmarkById(nonExistentBook);

        // Assert
        // Original books should remain unchanged
        expect(controller.bookmarkedBooks.length, equals(initialCount));
        expect(controller.bookmarkedBooks, equals(testBooks));
      });
    });
  });
}
