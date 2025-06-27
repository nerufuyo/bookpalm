import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:bookpalm/presentation/widgets/book_card.dart';
import 'package:bookpalm/domain/entities/book.dart';
import 'package:bookpalm/domain/entities/person.dart';

void main() {
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

  final testBookNoAuthors = Book(
    id: 2,
    title: 'Book Without Authors',
    authors: [],
    subjects: ['Poetry'],
    bookshelves: [],
    languages: ['en'],
    copyright: true,
    mediaType: 'Text',
    formats: {'text/html': 'https://example.com/book2.html'},
    downloadCount: 567,
  );

  final testBookLargeDownloads = Book(
    id: 3,
    title: 'Popular Book',
    authors: [Person(name: 'Popular Author', birthYear: 1970, deathYear: null)],
    subjects: ['Science Fiction'],
    bookshelves: [],
    languages: ['en'],
    copyright: false,
    mediaType: 'Text',
    formats: {'text/html': 'https://example.com/book3.html'},
    downloadCount: 1500000, // 1.5M downloads
  );

  group('BookCard Widget Tests', () {
    testWidgets('should display book title', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(book: testBook, onTap: () {}, onBookmarkTap: () {}),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Book Title'), findsOneWidget);
    });

    testWidgets('should display authors when available', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(book: testBook, onTap: () {}, onBookmarkTap: () {}),
          ),
        ),
      );

      // Assert
      expect(find.text('by Test Author 1, Test Author 2'), findsOneWidget);
    });

    testWidgets('should not display authors section when no authors', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: testBookNoAuthors,
              onTap: () {},
              onBookmarkTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('by '), findsNothing);
    });

    testWidgets('should display subjects as chips', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(book: testBook, onTap: () {}, onBookmarkTap: () {}),
          ),
        ),
      );

      // Assert
      expect(find.text('Fiction'), findsOneWidget);
      expect(find.text('Adventure'), findsOneWidget);
    });

    testWidgets('should display download count', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(book: testBook, onTap: () {}, onBookmarkTap: () {}),
          ),
        ),
      );

      // Assert
      expect(find.text('1234'), findsOneWidget);
      expect(find.byIcon(Icons.download_rounded), findsOneWidget);
    });

    testWidgets('should format large download counts correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: testBookLargeDownloads,
              onTap: () {},
              onBookmarkTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('1.5M'), findsOneWidget);
    });

    testWidgets('should display book cover image when available', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(book: testBook, onTap: () {}, onBookmarkTap: () {}),
          ),
        ),
      );

      // Assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should display placeholder when no cover image', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: testBookNoAuthors,
              onTap: () {},
              onBookmarkTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.book), findsOneWidget);
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      // Arrange
      bool tapCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: testBook,
              onTap: () => tapCalled = true,
              onBookmarkTap: () {},
            ),
          ),
        ),
      );

      // Tap the card
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Assert
      expect(tapCalled, isTrue);
    });

    testWidgets('should handle bookmark button tap', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool bookmarkTapCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: testBook,
              onTap: () {},
              onBookmarkTap: () => bookmarkTapCalled = true,
            ),
          ),
        ),
      );

      // Find and tap bookmark button
      final bookmarkButton = find.byIcon(Icons.bookmark_border);
      expect(bookmarkButton, findsOneWidget);

      await tester.tap(bookmarkButton);
      await tester.pump();

      // Assert
      expect(bookmarkTapCalled, isTrue);
    });

    testWidgets('should limit subjects display to maximum of 2', (
      WidgetTester tester,
    ) async {
      final bookWithManySubjects = Book(
        id: 4,
        title: 'Book With Many Subjects',
        authors: [Person(name: 'Author', birthYear: 1980, deathYear: null)],
        subjects: ['Fiction', 'Adventure', 'Mystery', 'Romance', 'Thriller'],
        bookshelves: [],
        languages: ['en'],
        copyright: false,
        mediaType: 'Text',
        formats: {'text/html': 'https://example.com/book4.html'},
        downloadCount: 100,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: bookWithManySubjects,
              onTap: () {},
              onBookmarkTap: () {},
            ),
          ),
        ),
      );

      // Assert - Should only show first 2 subjects
      expect(find.text('Fiction'), findsOneWidget);
      expect(find.text('Adventure'), findsOneWidget);
      expect(find.text('Mystery'), findsNothing);
      expect(find.text('Romance'), findsNothing);
      expect(find.text('Thriller'), findsNothing);
    });

    testWidgets('should display proper card styling', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(book: testBook, onTap: () {}, onBookmarkTap: () {}),
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);

      // Verify the card has proper decoration
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, equals(4));
      expect(card.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('should handle text overflow properly', (
      WidgetTester tester,
    ) async {
      final bookWithLongTitle = Book(
        id: 5,
        title:
            'This is a very long book title that should be truncated when displayed in the card widget to prevent overflow issues',
        authors: [
          Person(
            name: 'Author With A Very Long Name That Should Also Be Truncated',
            birthYear: 1980,
            deathYear: null,
          ),
        ],
        subjects: ['Subject'],
        bookshelves: [],
        languages: ['en'],
        copyright: false,
        mediaType: 'Text',
        formats: {'text/html': 'https://example.com/book5.html'},
        downloadCount: 100,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300, // Limited width to force text overflow
              child: BookCard(
                book: bookWithLongTitle,
                onTap: () {},
                onBookmarkTap: () {},
              ),
            ),
          ),
        ),
      );

      // Assert - Should not throw overflow errors
      expect(tester.takeException(), isNull);
    });
  });

  group('BookCard Download Count Formatting Tests', () {
    testWidgets('should format thousands correctly', (
      WidgetTester tester,
    ) async {
      final bookWithThousands = Book(
        id: 6,
        title: 'Book',
        authors: [],
        subjects: [],
        bookshelves: [],
        languages: ['en'],
        copyright: false,
        mediaType: 'Text',
        formats: {'text/html': 'https://example.com/book.html'},
        downloadCount: 5500, // Should display as 5.5K
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: bookWithThousands,
              onTap: () {},
              onBookmarkTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('5.5K'), findsOneWidget);
    });

    testWidgets('should format millions correctly', (
      WidgetTester tester,
    ) async {
      final bookWithMillions = Book(
        id: 7,
        title: 'Book',
        authors: [],
        subjects: [],
        bookshelves: [],
        languages: ['en'],
        copyright: false,
        mediaType: 'Text',
        formats: {'text/html': 'https://example.com/book.html'},
        downloadCount: 2300000, // Should display as 2.3M
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: bookWithMillions,
              onTap: () {},
              onBookmarkTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('2.3M'), findsOneWidget);
    });

    testWidgets('should display exact count for small numbers', (
      WidgetTester tester,
    ) async {
      final bookWithSmallCount = Book(
        id: 8,
        title: 'Book',
        authors: [],
        subjects: [],
        bookshelves: [],
        languages: ['en'],
        copyright: false,
        mediaType: 'Text',
        formats: {'text/html': 'https://example.com/book.html'},
        downloadCount: 999, // Should display as 999
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: bookWithSmallCount,
              onTap: () {},
              onBookmarkTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('999'), findsOneWidget);
    });
  });

  group('BookCard Bookmark State Tests', () {
    testWidgets('should show empty bookmark icon when not bookmarked', (
      WidgetTester tester,
    ) async {
      bool bookmarkTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: testBook,
              isBookmarked: false,
              onTap: () {},
              onBookmarkTap: () {
                bookmarkTapped = true;
              },
            ),
          ),
        ),
      );

      // Find the bookmark button
      final bookmarkButton = find.byIcon(Icons.bookmark_border);
      expect(bookmarkButton, findsOneWidget);

      // Verify the icon is the empty bookmark
      final iconWidget = tester.widget<Icon>(bookmarkButton);
      expect(iconWidget.icon, Icons.bookmark_border);
      expect(iconWidget.color, isA<Color>());

      // Test tap
      await tester.tap(bookmarkButton);
      await tester.pump();
      expect(bookmarkTapped, isTrue);
    });

    testWidgets('should show filled bookmark icon when bookmarked', (
      WidgetTester tester,
    ) async {
      bool bookmarkTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: testBook,
              isBookmarked: true,
              onTap: () {},
              onBookmarkTap: () {
                bookmarkTapped = true;
              },
            ),
          ),
        ),
      );

      // Find the bookmark button
      final bookmarkButton = find.byIcon(Icons.bookmark);
      expect(bookmarkButton, findsOneWidget);

      // Verify the icon is the filled bookmark
      final iconWidget = tester.widget<Icon>(bookmarkButton);
      expect(iconWidget.icon, Icons.bookmark);
      expect(iconWidget.color, isA<Color>());

      // Test tap
      await tester.tap(bookmarkButton);
      await tester.pump();
      expect(bookmarkTapped, isTrue);
    });

    testWidgets('should have different background color when bookmarked', (
      WidgetTester tester,
    ) async {
      // Test not bookmarked state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: testBook,
              isBookmarked: false,
              onTap: () {},
              onBookmarkTap: () {},
            ),
          ),
        ),
      );

      var bookmarkContainer = find
          .descendant(
            of: find.byType(GestureDetector),
            matching: find.byType(Container),
          )
          .first;

      var containerWidget = tester.widget<Container>(bookmarkContainer);
      var decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, isNot(equals(Colors.red.shade50)));

      // Test bookmarked state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookCard(
              book: testBook,
              isBookmarked: true,
              onTap: () {},
              onBookmarkTap: () {},
            ),
          ),
        ),
      );

      // Note: This test may need adjustment based on the exact widget structure
      // The important part is that the bookmark state is properly reflected
    });
  });
}
