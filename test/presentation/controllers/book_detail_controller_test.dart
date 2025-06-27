import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get/get.dart';
import 'package:bookpalm/presentation/controllers/book_detail_controller.dart';
import 'package:bookpalm/domain/usecases/get_book_by_id.dart';
import 'package:bookpalm/domain/usecases/bookmark_book.dart';
import 'package:bookpalm/domain/usecases/remove_bookmark.dart';
import 'package:bookpalm/domain/usecases/is_book_bookmarked.dart';
import 'package:bookpalm/domain/entities/book.dart';
import 'package:bookpalm/domain/entities/person.dart';
import 'package:bookpalm/core/error/failures.dart';
import 'package:bookpalm/core/utils/either.dart';
import 'package:bookpalm/core/logging/app_logger.dart';

@GenerateMocks([GetBookById, BookmarkBook, RemoveBookmark, IsBookBookmarked])
import 'book_detail_controller_test.mocks.dart';

void main() {
  late BookDetailController controller;
  late MockGetBookById mockGetBookById;
  late MockBookmarkBook mockBookmarkBook;
  late MockRemoveBookmark mockRemoveBookmark;
  late MockIsBookBookmarked mockIsBookBookmarked;

  // Test data
  final testBook = Book(
    id: 1,
    title: 'Test Book',
    subjects: ['Fiction', 'Adventure'],
    authors: [Person(name: 'Test Author', birthYear: 1850, deathYear: 1920)],
    bookshelves: ['Best Books Ever'],
    languages: ['en'],
    copyright: false,
    mediaType: 'Text',
    formats: {
      'text/html': 'https://example.com/book.html',
      'application/epub+zip': 'https://example.com/book.epub',
    },
    downloadCount: 5000,
  );

  setUpAll(() {
    // Initialize logger for testing
    AppLogger.instance.initialize();
  });

  setUp(() {
    // Initialize mocks
    mockGetBookById = MockGetBookById();
    mockBookmarkBook = MockBookmarkBook();
    mockRemoveBookmark = MockRemoveBookmark();
    mockIsBookBookmarked = MockIsBookBookmarked();

    // Create controller with mocks
    controller = BookDetailController(
      getBookById: mockGetBookById,
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

  group('BookDetailController', () {
    group('initialization', () {
      test('should initialize with default values', () {
        expect(controller.book, isNull);
        expect(controller.isLoading, isFalse);
        expect(controller.errorMessage, isEmpty);
        expect(controller.isBookmarked, isFalse);
      });

      test('should provide reactive getters', () {
        expect(controller.bookRx, isA<Rxn<Book>>());
        expect(controller.isLoadingRx, isA<RxBool>());
        expect(controller.errorMessageRx, isA<RxString>());
        expect(controller.isBookmarkedRx, isA<RxBool>());
      });
    });

    group('loadBookDetails', () {
      test('should load book details successfully', () async {
        // Arrange
        when(
          mockGetBookById(any),
        ).thenAnswer((_) async => Either.right(testBook));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act
        await controller.loadBookDetails(1);

        // Assert
        expect(controller.book, equals(testBook));
        expect(controller.isLoading, isFalse);
        expect(controller.errorMessage, isEmpty);
        verify(mockGetBookById(1)).called(1);
        verify(mockIsBookBookmarked(1)).called(1);
      });

      test('should handle load book details failure', () async {
        // Arrange
        const failure = ServerFailure('Network error');
        when(
          mockGetBookById(any),
        ).thenAnswer((_) async => Either.left(failure));

        // Act
        await controller.loadBookDetails(1);

        // Assert
        expect(controller.book, isNull);
        expect(controller.isLoading, isFalse);
        expect(controller.errorMessage, equals('Network error'));
        verify(mockGetBookById(1)).called(1);
        verifyNever(mockIsBookBookmarked(any));
      });

      test('should set loading state correctly during operation', () async {
        // Arrange
        when(
          mockGetBookById(any),
        ).thenAnswer((_) async => Either.right(testBook));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.right(false));

        // Act & Assert
        expect(controller.isLoading, isFalse);

        final future = controller.loadBookDetails(1);
        expect(controller.isLoading, isTrue);

        await future;
        expect(controller.isLoading, isFalse);
      });
    });

    group('toggleBookmark', () {
      setUp(() {
        // Set up controller with a book
        controller.bookRx.value = testBook;
        controller.isBookmarkedRx.value = false;
      });

      test('should add bookmark when book is not bookmarked', () async {
        // Arrange
        when(mockBookmarkBook(any)).thenAnswer((_) async => Either.right(true));

        String? successMessage;
        String? errorMessage;

        // Act
        await controller.toggleBookmark(
          onSuccess: (message) => successMessage = message,
          onError: (message) => errorMessage = message,
        );

        // Assert
        expect(controller.isBookmarked, isTrue);
        expect(successMessage, equals('Book bookmarked successfully'));
        expect(errorMessage, isNull);
        verify(mockBookmarkBook(testBook)).called(1);
      });

      test('should remove bookmark when book is bookmarked', () async {
        // Arrange
        controller.isBookmarkedRx.value = true;
        when(
          mockRemoveBookmark(any),
        ).thenAnswer((_) async => Either.right(true));

        String? successMessage;
        String? errorMessage;

        // Act
        await controller.toggleBookmark(
          onSuccess: (message) => successMessage = message,
          onError: (message) => errorMessage = message,
        );

        // Assert
        expect(controller.isBookmarked, isFalse);
        expect(successMessage, equals('Book removed from bookmarks'));
        expect(errorMessage, isNull);
        verify(mockRemoveBookmark(testBook.id)).called(1);
      });

      test('should handle bookmark failure', () async {
        // Arrange
        const failure = CacheFailure('Storage error');
        when(
          mockBookmarkBook(any),
        ).thenAnswer((_) async => Either.left(failure));

        String? successMessage;
        String? errorMessage;

        // Act
        await controller.toggleBookmark(
          onSuccess: (message) => successMessage = message,
          onError: (message) => errorMessage = message,
        );

        // Assert
        expect(controller.isBookmarked, isFalse);
        expect(successMessage, isNull);
        expect(errorMessage, equals('Storage error'));
      });

      test('should do nothing when book is null', () async {
        // Arrange
        controller.bookRx.value = null;

        String? successMessage;
        String? errorMessage;

        // Act
        await controller.toggleBookmark(
          onSuccess: (message) => successMessage = message,
          onError: (message) => errorMessage = message,
        );

        // Assert
        expect(successMessage, isNull);
        expect(errorMessage, isNull);
        verifyNever(mockBookmarkBook(any));
        verifyNever(mockRemoveBookmark(any));
      });
    });

    group('utility methods', () {
      test('should clear error message', () {
        // Arrange
        controller.errorMessageRx.value = 'Some error';

        // Act
        controller.clearError();

        // Assert
        expect(controller.errorMessage, isEmpty);
      });
    });

    group('edge cases', () {
      test('should handle exception during book loading', () async {
        // Arrange
        when(mockGetBookById(any)).thenThrow(Exception('Unexpected error'));

        // Act
        await controller.loadBookDetails(1);

        // Assert
        expect(controller.book, isNull);
        expect(controller.isLoading, isFalse);
        expect(controller.errorMessage, equals('An unexpected error occurred'));
      });

      test('should handle bookmark status check failure gracefully', () async {
        // Arrange
        when(
          mockGetBookById(any),
        ).thenAnswer((_) async => Either.right(testBook));
        when(
          mockIsBookBookmarked(any),
        ).thenAnswer((_) async => Either.left(CacheFailure('Storage error')));

        // Act
        await controller.loadBookDetails(1);

        // Assert
        expect(controller.book, equals(testBook));
        expect(controller.isLoading, isFalse);
        expect(controller.errorMessage, isEmpty);
        // Bookmark status should remain unchanged (default false)
        expect(controller.isBookmarked, isFalse);
      });
    });
  });
}
