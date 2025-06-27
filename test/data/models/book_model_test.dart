import 'package:flutter_test/flutter_test.dart';
import 'package:bookpalm/data/models/book_model.dart';
import 'package:bookpalm/data/models/person_model.dart';
import 'package:bookpalm/domain/entities/book.dart';

void main() {
  group('BookModel', () {
    late Map<String, dynamic> testJson;
    late BookModel testBookModel;

    setUp(() {
      testJson = {
        'id': 1,
        'title': 'Test Book',
        'subjects': ['Fiction', 'Adventure'],
        'authors': [
          {'name': 'Test Author', 'birth_year': 1900, 'death_year': 1980},
        ],
        'bookshelves': ['Popular Books'],
        'languages': ['en', 'fr'],
        'copyright': false,
        'media_type': 'Text',
        'formats': {
          'text/html': 'https://example.com/book.html',
          'application/epub+zip': 'https://example.com/book.epub',
        },
        'download_count': 5000,
      };

      testBookModel = BookModel(
        id: 1,
        title: 'Test Book',
        subjects: ['Fiction', 'Adventure'],
        authors: [
          PersonModel(name: 'Test Author', birthYear: 1900, deathYear: 1980),
        ],
        bookshelves: ['Popular Books'],
        languages: ['en', 'fr'],
        copyright: false,
        mediaType: 'Text',
        formats: {
          'text/html': 'https://example.com/book.html',
          'application/epub+zip': 'https://example.com/book.epub',
        },
        downloadCount: 5000,
      );
    });

    group('constructor', () {
      test('should create BookModel with all properties', () {
        expect(testBookModel.id, equals(1));
        expect(testBookModel.title, equals('Test Book'));
        expect(testBookModel.subjects, equals(['Fiction', 'Adventure']));
        expect(testBookModel.authors.length, equals(1));
        expect(testBookModel.authors.first.name, equals('Test Author'));
        expect(testBookModel.bookshelves, equals(['Popular Books']));
        expect(testBookModel.languages, equals(['en', 'fr']));
        expect(testBookModel.copyright, equals(false));
        expect(testBookModel.mediaType, equals('Text'));
        expect(
          testBookModel.formats['text/html'],
          equals('https://example.com/book.html'),
        );
        expect(testBookModel.downloadCount, equals(5000));
      });

      test('should extend Book entity', () {
        expect(testBookModel, isA<Book>());
      });

      test('should create BookModel with null copyright', () {
        final bookWithNullCopyright = BookModel(
          id: 2,
          title: 'Book Without Copyright',
          subjects: [],
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

      test('should create BookModel with empty collections', () {
        final emptyBook = BookModel(
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
      });
    });

    group('fromJson', () {
      test('should create BookModel from valid JSON', () {
        final bookModel = BookModel.fromJson(testJson);

        expect(bookModel.id, equals(1));
        expect(bookModel.title, equals('Test Book'));
        expect(bookModel.subjects, equals(['Fiction', 'Adventure']));
        expect(bookModel.authors.length, equals(1));
        expect(bookModel.authors.first.name, equals('Test Author'));
        expect(bookModel.authors.first.birthYear, equals(1900));
        expect(bookModel.authors.first.deathYear, equals(1980));
        expect(bookModel.bookshelves, equals(['Popular Books']));
        expect(bookModel.languages, equals(['en', 'fr']));
        expect(bookModel.copyright, equals(false));
        expect(bookModel.mediaType, equals('Text'));
        expect(
          bookModel.formats['text/html'],
          equals('https://example.com/book.html'),
        );
        expect(bookModel.downloadCount, equals(5000));
      });

      test('should handle JSON with null copyright', () {
        final jsonWithNullCopyright = Map<String, dynamic>.from(testJson);
        jsonWithNullCopyright['copyright'] = null;

        final bookModel = BookModel.fromJson(jsonWithNullCopyright);
        expect(bookModel.copyright, isNull);
      });

      test('should handle JSON with empty arrays', () {
        final jsonWithEmptyArrays = {
          'id': 4,
          'title': 'Empty Arrays Book',
          'subjects': <String>[],
          'authors': <Map<String, dynamic>>[],
          'bookshelves': <String>[],
          'languages': <String>[],
          'copyright': false,
          'media_type': 'Text',
          'formats': <String, String>{},
          'download_count': 0,
        };

        final bookModel = BookModel.fromJson(jsonWithEmptyArrays);
        expect(bookModel.subjects, isEmpty);
        expect(bookModel.authors, isEmpty);
        expect(bookModel.bookshelves, isEmpty);
        expect(bookModel.languages, isEmpty);
        expect(bookModel.formats, isEmpty);
      });

      test('should handle JSON with multiple authors', () {
        final jsonWithMultipleAuthors = Map<String, dynamic>.from(testJson);
        jsonWithMultipleAuthors['authors'] = [
          {'name': 'First Author', 'birth_year': 1800, 'death_year': 1880},
          {'name': 'Second Author', 'birth_year': 1850, 'death_year': null},
        ];

        final bookModel = BookModel.fromJson(jsonWithMultipleAuthors);
        expect(bookModel.authors.length, equals(2));
        expect(bookModel.authors[0].name, equals('First Author'));
        expect(bookModel.authors[1].name, equals('Second Author'));
        expect(bookModel.authors[1].deathYear, isNull);
      });

      test('should handle JSON with snake_case field mapping', () {
        // Test that media_type and download_count are properly mapped
        expect(testJson.containsKey('media_type'), isTrue);
        expect(testJson.containsKey('download_count'), isTrue);

        final bookModel = BookModel.fromJson(testJson);
        expect(bookModel.mediaType, equals('Text'));
        expect(bookModel.downloadCount, equals(5000));
      });

      test('should handle JSON with various format types', () {
        final jsonWithManyFormats = Map<String, dynamic>.from(testJson);
        jsonWithManyFormats['formats'] = {
          'text/html': 'https://example.com/book.html',
          'application/epub+zip': 'https://example.com/book.epub',
          'text/plain': 'https://example.com/book.txt',
          'application/pdf': 'https://example.com/book.pdf',
          'image/jpeg': 'https://example.com/cover.jpg',
          'application/rdf+xml': 'https://example.com/metadata.rdf',
        };

        final bookModel = BookModel.fromJson(jsonWithManyFormats);
        expect(bookModel.formats.length, equals(6));
        expect(
          bookModel.formats['application/pdf'],
          equals('https://example.com/book.pdf'),
        );
        expect(
          bookModel.formats['image/jpeg'],
          equals('https://example.com/cover.jpg'),
        );
      });
    });

    group('toJson', () {
      test('should convert BookModel to JSON', () {
        final json = testBookModel.toJson();

        expect(json['id'], equals(1));
        expect(json['title'], equals('Test Book'));
        expect(json['subjects'], equals(['Fiction', 'Adventure']));
        expect(json['authors'], isA<List>());
        expect((json['authors'] as List).length, equals(1));
        expect(json['bookshelves'], equals(['Popular Books']));
        expect(json['languages'], equals(['en', 'fr']));
        expect(json['copyright'], equals(false));
        expect(json['media_type'], equals('Text'));
        expect(json['formats'], isA<Map>());
        expect(json['download_count'], equals(5000));
      });

      test('should handle null copyright in JSON output', () {
        final bookWithNullCopyright = BookModel(
          id: 5,
          title: 'Null Copyright Book',
          subjects: [],
          authors: [],
          bookshelves: [],
          languages: ['en'],
          copyright: null,
          mediaType: 'Text',
          formats: {},
          downloadCount: 100,
        );

        final json = bookWithNullCopyright.toJson();
        expect(json['copyright'], isNull);
      });

      test('should properly serialize authors', () {
        final json = testBookModel.toJson();
        final authorsJson = json['authors'] as List;

        expect(authorsJson.length, equals(1));
        expect(authorsJson.first, isA<Map<String, dynamic>>());

        final authorJson = authorsJson.first as Map<String, dynamic>;
        expect(authorJson['name'], equals('Test Author'));
        expect(authorJson['birth_year'], equals(1900));
        expect(authorJson['death_year'], equals(1980));
      });

      test('should use snake_case for field names in JSON', () {
        final json = testBookModel.toJson();

        expect(json.containsKey('media_type'), isTrue);
        expect(json.containsKey('download_count'), isTrue);
        expect(json.containsKey('mediaType'), isFalse);
        expect(json.containsKey('downloadCount'), isFalse);
      });
    });

    group('JSON roundtrip', () {
      test('should maintain data integrity through JSON roundtrip', () {
        // Convert to JSON and back
        final json = testBookModel.toJson();
        final recreatedModel = BookModel.fromJson(json);

        expect(recreatedModel.id, equals(testBookModel.id));
        expect(recreatedModel.title, equals(testBookModel.title));
        expect(recreatedModel.subjects, equals(testBookModel.subjects));
        expect(
          recreatedModel.authors.length,
          equals(testBookModel.authors.length),
        );
        expect(
          recreatedModel.authors.first.name,
          equals(testBookModel.authors.first.name),
        );
        expect(recreatedModel.bookshelves, equals(testBookModel.bookshelves));
        expect(recreatedModel.languages, equals(testBookModel.languages));
        expect(recreatedModel.copyright, equals(testBookModel.copyright));
        expect(recreatedModel.mediaType, equals(testBookModel.mediaType));
        expect(recreatedModel.formats, equals(testBookModel.formats));
        expect(
          recreatedModel.downloadCount,
          equals(testBookModel.downloadCount),
        );
      });

      test('should handle complex data through roundtrip', () {
        final complexBook = BookModel(
          id: 999,
          title: 'Complex Book with Special Characters: "Quotes" & Symbols',
          subjects: ['Fiction', 'Science Fiction', 'Adventure', 'Philosophy'],
          authors: [
            PersonModel(name: 'Author One', birthYear: 1800, deathYear: 1880),
            PersonModel(name: 'Author Two', birthYear: 1950, deathYear: null),
            PersonModel(
              name: 'Unknown Author',
              birthYear: null,
              deathYear: null,
            ),
          ],
          bookshelves: ['Classic Literature', 'Science Fiction', 'Philosophy'],
          languages: ['en', 'fr', 'de', 'es'],
          copyright: true,
          mediaType: 'Text',
          formats: {
            'text/html': 'https://example.com/complex.html',
            'application/epub+zip': 'https://example.com/complex.epub',
            'text/plain': 'https://example.com/complex.txt',
            'application/pdf': 'https://example.com/complex.pdf',
          },
          downloadCount: 1500000,
        );

        final json = complexBook.toJson();
        final recreated = BookModel.fromJson(json);

        expect(recreated.id, equals(complexBook.id));
        expect(recreated.title, equals(complexBook.title));
        expect(recreated.subjects.length, equals(4));
        expect(recreated.authors.length, equals(3));
        expect(recreated.authors[2].birthYear, isNull);
        expect(recreated.languages.length, equals(4));
        expect(recreated.formats.length, equals(4));
        expect(recreated.downloadCount, equals(1500000));
      });
    });

    group('inheritance behavior', () {
      test('should behave as Book entity', () {
        final Book entityBook = testBookModel;

        expect(entityBook.id, equals(1));
        expect(entityBook.title, equals('Test Book'));
        expect(entityBook.authors.first.name, equals('Test Author'));
      });

      test('should maintain equality with same ID', () {
        final anotherBookModel = BookModel(
          id: 1, // Same ID
          title: 'Different Title',
          subjects: ['Different Subject'],
          authors: [],
          bookshelves: [],
          languages: ['de'],
          mediaType: 'Audio',
          formats: {},
          downloadCount: 999,
        );

        expect(testBookModel == anotherBookModel, isTrue);
        expect(testBookModel.hashCode, equals(anotherBookModel.hashCode));
      });
    });

    group('edge cases', () {
      test('should handle very large download counts', () {
        final jsonWithLargeCount = Map<String, dynamic>.from(testJson);
        jsonWithLargeCount['download_count'] = 999999999;

        final bookModel = BookModel.fromJson(jsonWithLargeCount);
        expect(bookModel.downloadCount, equals(999999999));
      });

      test('should handle zero download count', () {
        final jsonWithZeroCount = Map<String, dynamic>.from(testJson);
        jsonWithZeroCount['download_count'] = 0;

        final bookModel = BookModel.fromJson(jsonWithZeroCount);
        expect(bookModel.downloadCount, equals(0));
      });

      test('should handle special characters in strings', () {
        final jsonWithSpecialChars = Map<String, dynamic>.from(testJson);
        jsonWithSpecialChars['title'] =
            'Book with "Quotes" & <Tags> and émojis 📚';
        jsonWithSpecialChars['subjects'] = ['Spéçîål Çhäracters', 'Üñîçødé'];

        final bookModel = BookModel.fromJson(jsonWithSpecialChars);
        expect(bookModel.title, contains('📚'));
        expect(bookModel.subjects.first, contains('Çhäracters'));
      });
    });
  });
}
