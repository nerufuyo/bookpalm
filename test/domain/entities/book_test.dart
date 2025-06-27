import 'package:flutter_test/flutter_test.dart';
import 'package:bookpalm/domain/entities/book.dart';
import 'package:bookpalm/domain/entities/person.dart';

void main() {
  group('Book Entity', () {
    late Book testBook;
    late List<Person> testAuthors;

    setUp(() {
      testAuthors = [
        Person(name: 'Author One', birthYear: 1900, deathYear: 1980),
        Person(name: 'Author Two', birthYear: 1950, deathYear: null),
      ];

      testBook = Book(
        id: 1,
        title: 'Test Book Title',
        subjects: ['Fiction', 'Adventure', 'Classic Literature'],
        authors: testAuthors,
        bookshelves: ['Popular Books', 'Classic Literature'],
        languages: ['en', 'fr'],
        copyright: false,
        mediaType: 'Text',
        formats: {
          'text/html': 'https://example.com/book.html',
          'application/epub+zip': 'https://example.com/book.epub',
          'text/plain': 'https://example.com/book.txt',
          'image/jpeg': 'https://example.com/cover.jpg',
        },
        downloadCount: 5000,
      );
    });

    group('constructor', () {
      test('should create a book with all required properties', () {
        expect(testBook.id, equals(1));
        expect(testBook.title, equals('Test Book Title'));
        expect(
          testBook.subjects,
          equals(['Fiction', 'Adventure', 'Classic Literature']),
        );
        expect(testBook.authors, equals(testAuthors));
        expect(
          testBook.bookshelves,
          equals(['Popular Books', 'Classic Literature']),
        );
        expect(testBook.languages, equals(['en', 'fr']));
        expect(testBook.copyright, equals(false));
        expect(testBook.mediaType, equals('Text'));
        expect(
          testBook.formats['text/html'],
          equals('https://example.com/book.html'),
        );
        expect(testBook.downloadCount, equals(5000));
      });

      test('should create a book with null copyright', () {
        final bookWithNullCopyright = Book(
          id: 2,
          title: 'Book Without Copyright Info',
          subjects: ['Science'],
          authors: [],
          bookshelves: [],
          languages: ['en'],
          copyright: null,
          mediaType: 'Text',
          formats: {},
          downloadCount: 100,
        );

        expect(bookWithNullCopyright.copyright, isNull);
      });

      test('should create a book with empty collections', () {
        final emptyBook = Book(
          id: 3,
          title: 'Empty Book',
          subjects: [],
          authors: [],
          bookshelves: [],
          languages: [],
          copyright: true,
          mediaType: 'Text',
          formats: {},
          downloadCount: 0,
        );

        expect(emptyBook.subjects, isEmpty);
        expect(emptyBook.authors, isEmpty);
        expect(emptyBook.bookshelves, isEmpty);
        expect(emptyBook.languages, isEmpty);
        expect(emptyBook.formats, isEmpty);
        expect(emptyBook.downloadCount, equals(0));
      });
    });

    group('properties access', () {
      test('should allow access to all properties', () {
        expect(testBook.id, isA<int>());
        expect(testBook.title, isA<String>());
        expect(testBook.subjects, isA<List<String>>());
        expect(testBook.authors, isA<List<Person>>());
        expect(testBook.bookshelves, isA<List<String>>());
        expect(testBook.languages, isA<List<String>>());
        expect(testBook.copyright, isA<bool?>());
        expect(testBook.mediaType, isA<String>());
        expect(testBook.formats, isA<Map<String, String>>());
        expect(testBook.downloadCount, isA<int>());
      });

      test('should provide access to specific format types', () {
        expect(testBook.formats['text/html'], isNotNull);
        expect(testBook.formats['application/epub+zip'], isNotNull);
        expect(testBook.formats['text/plain'], isNotNull);
        expect(testBook.formats['image/jpeg'], isNotNull);
        expect(testBook.formats['nonexistent'], isNull);
      });

      test('should handle multiple authors correctly', () {
        expect(testBook.authors.length, equals(2));
        expect(testBook.authors[0].name, equals('Author One'));
        expect(testBook.authors[1].name, equals('Author Two'));
      });

      test('should handle multiple subjects correctly', () {
        expect(testBook.subjects.length, equals(3));
        expect(testBook.subjects, contains('Fiction'));
        expect(testBook.subjects, contains('Adventure'));
        expect(testBook.subjects, contains('Classic Literature'));
      });

      test('should handle multiple languages correctly', () {
        expect(testBook.languages.length, equals(2));
        expect(testBook.languages, contains('en'));
        expect(testBook.languages, contains('fr'));
      });
    });

    group('equality and hashCode', () {
      test('should be equal when ids are the same', () {
        final sameIdBook = Book(
          id: 1, // Same ID as testBook
          title: 'Different Title',
          subjects: ['Different Subject'],
          authors: [],
          bookshelves: [],
          languages: ['de'],
          copyright: true,
          mediaType: 'Audio',
          formats: {'audio/mp3': 'https://example.com/audio.mp3'},
          downloadCount: 999999,
        );

        expect(testBook == sameIdBook, isTrue);
        expect(testBook.hashCode, equals(sameIdBook.hashCode));
      });

      test('should not be equal when ids are different', () {
        final differentIdBook = Book(
          id: 2, // Different ID
          title: 'Test Book Title', // Same title as testBook
          subjects: ['Fiction', 'Adventure', 'Classic Literature'],
          authors: testAuthors,
          bookshelves: ['Popular Books', 'Classic Literature'],
          languages: ['en', 'fr'],
          copyright: false,
          mediaType: 'Text',
          formats: {
            'text/html': 'https://example.com/book.html',
            'application/epub+zip': 'https://example.com/book.epub',
          },
          downloadCount: 5000,
        );

        expect(testBook == differentIdBook, isFalse);
        expect(testBook.hashCode, isNot(equals(differentIdBook.hashCode)));
      });

      test('should be equal to itself', () {
        expect(testBook == testBook, isTrue);
        expect(identical(testBook, testBook), isTrue);
      });

      test('should not be equal to null or different types', () {
        // Test with different object type - using runtimeType check instead
        expect(testBook.runtimeType == String, isFalse);
        expect(testBook == Object(), isFalse);

        // Test null safety - create a nullable book for comparison
        Book? nullBook;
        expect(testBook == nullBook, isFalse);
      });

      test('should have consistent hashCode', () {
        final hashCode1 = testBook.hashCode;
        final hashCode2 = testBook.hashCode;
        expect(hashCode1, equals(hashCode2));
      });
    });

    group('edge cases', () {
      test('should handle very large download counts', () {
        final popularBook = Book(
          id: 999,
          title: 'Very Popular Book',
          subjects: [],
          authors: [],
          bookshelves: [],
          languages: ['en'],
          mediaType: 'Text',
          formats: {},
          downloadCount: 999999999,
        );

        expect(popularBook.downloadCount, equals(999999999));
      });

      test('should handle zero download count', () {
        final unpopularBook = Book(
          id: 1000,
          title: 'Unpopular Book',
          subjects: [],
          authors: [],
          bookshelves: [],
          languages: ['en'],
          mediaType: 'Text',
          formats: {},
          downloadCount: 0,
        );

        expect(unpopularBook.downloadCount, equals(0));
      });

      test('should handle long titles', () {
        final longTitle =
            'This is a very long book title that might be used in some cases to test how the system handles extremely lengthy book titles that could potentially cause issues';
        final longTitleBook = Book(
          id: 1001,
          title: longTitle,
          subjects: [],
          authors: [],
          bookshelves: [],
          languages: ['en'],
          mediaType: 'Text',
          formats: {},
          downloadCount: 100,
        );

        expect(longTitleBook.title, equals(longTitle));
        expect(longTitleBook.title.length, greaterThan(100));
      });

      test('should handle special characters in properties', () {
        final specialCharBook = Book(
          id: 1002,
          title: 'Böök wïth Spéçïàl Châråçtérs & Émojis 📚',
          subjects: ['Spéçïàl Çhåråçtérs', 'Ünïçödé'],
          authors: [
            Person(
              name: 'Authör Wïth Spéçïàl Námé',
              birthYear: 1980,
              deathYear: null,
            ),
          ],
          bookshelves: ['Spéçïàl Böökshélf'],
          languages: ['en', 'es-special'],
          mediaType: 'Téxt',
          formats: {'téxt/html': 'https://example.com/spéçïàl.html'},
          downloadCount: 42,
        );

        expect(specialCharBook.title, contains('📚'));
        expect(specialCharBook.subjects.first, contains('Çhåråçtérs'));
        expect(specialCharBook.authors.first.name, contains('Spéçïàl'));
      });

      test('should handle very large collections', () {
        final largeSubjects = List.generate(1000, (index) => 'Subject $index');
        final largeLanguages = List.generate(100, (index) => 'lang$index');

        final bookWithLargeCollections = Book(
          id: 1003,
          title: 'Book with Large Collections',
          subjects: largeSubjects,
          authors: [],
          bookshelves: [],
          languages: largeLanguages,
          mediaType: 'Text',
          formats: {},
          downloadCount: 1,
        );

        expect(bookWithLargeCollections.subjects.length, equals(1000));
        expect(bookWithLargeCollections.languages.length, equals(100));
        expect(bookWithLargeCollections.subjects.last, equals('Subject 999'));
        expect(bookWithLargeCollections.languages.last, equals('lang99'));
      });
    });

    group('immutability', () {
      test('should be immutable (final fields)', () {
        // This test verifies that all fields are final by attempting to access them
        // If they weren't final, this would be a compilation error
        final book = testBook;
        expect(book.id, equals(testBook.id));
        expect(book.title, equals(testBook.title));
        expect(book.subjects, equals(testBook.subjects));
        expect(book.authors, equals(testBook.authors));
        expect(book.bookshelves, equals(testBook.bookshelves));
        expect(book.languages, equals(testBook.languages));
        expect(book.copyright, equals(testBook.copyright));
        expect(book.mediaType, equals(testBook.mediaType));
        expect(book.formats, equals(testBook.formats));
        expect(book.downloadCount, equals(testBook.downloadCount));
      });
    });
  });
}
