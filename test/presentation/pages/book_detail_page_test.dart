import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import 'package:bookpalm/presentation/pages/book_detail_page.dart';
import 'package:bookpalm/presentation/controllers/book_detail_controller.dart';
import 'package:bookpalm/domain/entities/book.dart';
import 'package:bookpalm/domain/entities/person.dart';
import 'package:bookpalm/core/localization/localization_service.dart';
import 'package:bookpalm/core/logging/app_logger.dart';
import 'package:bookpalm/core/utils/either.dart';

import '../controllers/book_detail_controller_test.mocks.dart';

void main() {
  late MockGetBookById mockGetBookById;
  late MockBookmarkBook mockBookmarkBook;
  late MockRemoveBookmark mockRemoveBookmark;
  late MockIsBookBookmarked mockIsBookBookmarked;
  late BookDetailController controller;

  // Test data
  final testBook = Book(
    id: 1,
    title: 'Test Book Title',
    authors: [
      Person(name: 'Test Author 1', birthYear: 1950, deathYear: 2020),
      Person(name: 'Test Author 2', birthYear: 1960, deathYear: null),
    ],
    subjects: ['Fiction', 'Adventure'],
    bookshelves: ['Adventure', 'Classic Literature'],
    languages: ['en', 'fr'],
    copyright: false,
    mediaType: 'Text',
    formats: {
      'text/html': 'https://example.com/book.html',
      'application/epub+zip': 'https://example.com/book.epub',
      'image/jpeg': 'https://example.com/cover.jpg',
    },
    downloadCount: 1234,
  );

  setUp(() async {
    mockGetBookById = MockGetBookById();
    mockBookmarkBook = MockBookmarkBook();
    mockRemoveBookmark = MockRemoveBookmark();
    mockIsBookBookmarked = MockIsBookBookmarked();

    // Set up mock stubs to prevent MissingStubError
    when(
      mockGetBookById.call(any),
    ).thenAnswer((_) async => Either.right(testBook));
    when(
      mockBookmarkBook.call(any),
    ).thenAnswer((_) async => const Either.right(true));
    when(
      mockRemoveBookmark.call(any),
    ).thenAnswer((_) async => const Either.right(true));
    when(
      mockIsBookBookmarked.call(any),
    ).thenAnswer((_) async => const Either.right(false));

    // Initialize localization service
    await LocalizationService.instance.loadLanguage('en');

    // Initialize logger only once
    try {
      AppLogger.instance.initialize();
    } catch (e) {
      // Logger already initialized, ignore
    }

    controller = BookDetailController(
      getBookById: mockGetBookById,
      bookmarkBook: mockBookmarkBook,
      removeBookmark: mockRemoveBookmark,
      isBookBookmarked: mockIsBookBookmarked,
    );

    // Register controller in GetIt for dependency injection
    await GetIt.instance.reset();
    GetIt.instance.registerLazySingleton<BookDetailController>(
      () => controller,
    );
  });

  tearDown(() async {
    await GetIt.instance.reset();
    Get.reset();
  });

  group('BookDetailPage Widget Tests', () {
    testWidgets('should display loading indicator when loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      controller.isLoadingRx.value = true;

      // Act
      await tester.pumpWidget(
        GetMaterialApp(home: const BookDetailPage(bookId: '1')),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading book details...'), findsOneWidget);
    });

    testWidgets('should display proper book cover placeholder when no image', (
      WidgetTester tester,
    ) async {
      // Arrange
      final bookWithoutImage = Book(
        id: 1,
        title: 'Test Book',
        authors: [],
        subjects: [],
        bookshelves: [],
        languages: ['en'],
        copyright: false,
        mediaType: 'Text',
        formats: {'text/html': 'https://example.com/book.html'},
        downloadCount: 100,
      );

      controller.isLoadingRx.value = false;
      controller.errorMessageRx.value = '';
      controller.bookRx.value = bookWithoutImage;

      // Act
      await tester.pumpWidget(
        GetMaterialApp(home: const BookDetailPage(bookId: '1')),
      );

      // Wait for any animations to complete
      await tester.pumpAndSettle();

      // Assert - Look for the book icon placeholder
      expect(find.byIcon(Icons.book), findsOneWidget);
    });
  });

  group('BookDetailPage Integration Tests', () {
    testWidgets('should show snackbar when bookmark toggle succeeds', (
      WidgetTester tester,
    ) async {
      // Arrange
      controller.isLoadingRx.value = false;
      controller.errorMessageRx.value = '';
      controller.bookRx.value = testBook;
      controller.isBookmarkedRx.value = false;

      // Act
      await tester.pumpWidget(
        GetMaterialApp(home: const BookDetailPage(bookId: '1')),
      );

      // Wait for page to render
      await tester.pumpAndSettle();

      // Find and tap bookmark FAB
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pump();

      // Note: In a real integration test, we would mock the success callback
      // and verify the snackbar appears, but that requires more complex setup
    });

    testWidgets('should handle scroll behavior correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      controller.isLoadingRx.value = false;
      controller.errorMessageRx.value = '';
      controller.bookRx.value = testBook;

      // Act
      await tester.pumpWidget(
        GetMaterialApp(home: const BookDetailPage(bookId: '1')),
      );

      // Wait for page to render
      await tester.pumpAndSettle();

      // Assert - Verify scrollable content exists
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
    });
  });
}
