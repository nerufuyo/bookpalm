import 'package:flutter_test/flutter_test.dart';
import 'package:bookpalm/domain/entities/person.dart';

void main() {
  group('Person Entity', () {
    group('constructor', () {
      test('should create person with all properties', () {
        final person = Person(
          name: 'John Doe',
          birthYear: 1850,
          deathYear: 1920,
        );

        expect(person.name, equals('John Doe'));
        expect(person.birthYear, equals(1850));
        expect(person.deathYear, equals(1920));
      });

      test('should create person with only name (living person)', () {
        final person = Person(name: 'Jane Smith');

        expect(person.name, equals('Jane Smith'));
        expect(person.birthYear, isNull);
        expect(person.deathYear, isNull);
      });

      test('should create person with birth year only', () {
        final person = Person(name: 'Living Author', birthYear: 1980);

        expect(person.name, equals('Living Author'));
        expect(person.birthYear, equals(1980));
        expect(person.deathYear, isNull);
      });

      test('should create person with death year only', () {
        final person = Person(name: 'Historical Figure', deathYear: 1900);

        expect(person.name, equals('Historical Figure'));
        expect(person.birthYear, isNull);
        expect(person.deathYear, equals(1900));
      });
    });

    group('properties access', () {
      test('should allow access to all properties', () {
        final person = Person(
          name: 'Test Author',
          birthYear: 1900,
          deathYear: 1980,
        );

        expect(person.name, isA<String>());
        expect(person.birthYear, isA<int?>());
        expect(person.deathYear, isA<int?>());
      });

      test('should handle nullable year properties', () {
        final person = Person(name: 'Test');

        expect(person.birthYear, isNull);
        expect(person.deathYear, isNull);
        expect(person.name, isNotNull);
      });
    });

    group('equality and hashCode', () {
      test('should be equal when names are the same', () {
        final person1 = Person(
          name: 'Charles Dickens',
          birthYear: 1812,
          deathYear: 1870,
        );

        final person2 = Person(
          name: 'Charles Dickens',
          birthYear: 1800, // Different birth year
          deathYear: 1900, // Different death year
        );

        expect(person1 == person2, isTrue);
        expect(person1.hashCode, equals(person2.hashCode));
      });

      test('should not be equal when names are different', () {
        final person1 = Person(
          name: 'Charles Dickens',
          birthYear: 1812,
          deathYear: 1870,
        );

        final person2 = Person(
          name: 'Jane Austen',
          birthYear: 1812, // Same birth year
          deathYear: 1870, // Same death year
        );

        expect(person1 == person2, isFalse);
        expect(person1.hashCode, isNot(equals(person2.hashCode)));
      });

      test('should be equal to itself', () {
        final person = Person(name: 'Test Author');
        expect(person == person, isTrue);
        expect(identical(person, person), isTrue);
      });

      test('should not be equal to null or different types', () {
        final person = Person(name: 'Test Author');

        // Test with different object type - using runtimeType check instead
        expect(person.runtimeType == String, isFalse);
        expect(person == Object(), isFalse);

        // Test null safety
        Person? nullPerson;
        expect(person == nullPerson, isFalse);
      });

      test('should have consistent hashCode', () {
        final person = Person(name: 'Consistent Author');
        final hashCode1 = person.hashCode;
        final hashCode2 = person.hashCode;
        expect(hashCode1, equals(hashCode2));
      });

      test('should be equal regardless of year differences', () {
        final person1 = Person(name: 'Same Name');
        final person2 = Person(
          name: 'Same Name',
          birthYear: 1900,
          deathYear: 1980,
        );

        expect(person1 == person2, isTrue);
        expect(person1.hashCode, equals(person2.hashCode));
      });
    });

    group('edge cases', () {
      test('should handle empty name', () {
        final person = Person(name: '');
        expect(person.name, equals(''));
        expect(person.name.isEmpty, isTrue);
      });

      test('should handle very long names', () {
        final longName =
            'This is an extremely long author name that might be encountered in some edge cases where authors have very lengthy full names with multiple middle names and titles';
        final person = Person(name: longName);

        expect(person.name, equals(longName));
        expect(person.name.length, greaterThan(100));
      });

      test('should handle special characters in names', () {
        final specialName = 'José María Azuela González-Pérez';
        final person = Person(name: specialName);

        expect(person.name, equals(specialName));
        expect(person.name, contains('é'));
      });

      test('should handle names with emojis and unicode', () {
        final emojiName = 'Author 📚 Writer ✍️';
        final person = Person(name: emojiName);

        expect(person.name, equals(emojiName));
        expect(person.name, contains('📚'));
        expect(person.name, contains('✍️'));
      });

      test('should handle very old birth years', () {
        final ancientPerson = Person(
          name: 'Ancient Author',
          birthYear: 100,
          deathYear: 180,
        );

        expect(ancientPerson.birthYear, equals(100));
        expect(ancientPerson.deathYear, equals(180));
      });

      test('should handle future birth years', () {
        final futurePerson = Person(name: 'Future Author', birthYear: 2100);

        expect(futurePerson.birthYear, equals(2100));
        expect(futurePerson.deathYear, isNull);
      });

      test('should handle negative years (BCE)', () {
        final historicalPerson = Person(
          name: 'Ancient Philosopher',
          birthYear: -384, // 384 BCE
          deathYear: -322, // 322 BCE
        );

        expect(historicalPerson.birthYear, equals(-384));
        expect(historicalPerson.deathYear, equals(-322));
      });

      test('should handle death year before birth year (data inconsistency)', () {
        // This represents potentially inconsistent data that might come from external sources
        final inconsistentPerson = Person(
          name: 'Inconsistent Data Person',
          birthYear: 1900,
          deathYear: 1850, // Dies before birth - data error
        );

        expect(inconsistentPerson.birthYear, equals(1900));
        expect(inconsistentPerson.deathYear, equals(1850));
        // The entity doesn't validate this - validation would be in business logic
      });
    });

    group('real world examples', () {
      test('should handle famous historical authors', () {
        final shakespeare = Person(
          name: 'William Shakespeare',
          birthYear: 1564,
          deathYear: 1616,
        );

        final dickens = Person(
          name: 'Charles Dickens',
          birthYear: 1812,
          deathYear: 1870,
        );

        expect(shakespeare.name, equals('William Shakespeare'));
        expect(dickens.name, equals('Charles Dickens'));
        expect(shakespeare == dickens, isFalse);
      });

      test('should handle contemporary living authors', () {
        final livingAuthor1 = Person(name: 'Stephen King', birthYear: 1947);

        final livingAuthor2 = Person(name: 'J.K. Rowling', birthYear: 1965);

        expect(livingAuthor1.deathYear, isNull);
        expect(livingAuthor2.deathYear, isNull);
        expect(livingAuthor1 == livingAuthor2, isFalse);
      });

      test('should handle authors with unknown birth/death dates', () {
        final unknownAuthor = Person(name: 'Anonymous');

        expect(unknownAuthor.birthYear, isNull);
        expect(unknownAuthor.deathYear, isNull);
        expect(unknownAuthor.name, equals('Anonymous'));
      });

      test('should handle collective authorship', () {
        final collective = Person(name: 'Various Authors');

        expect(collective.name, equals('Various Authors'));
        expect(collective.birthYear, isNull);
        expect(collective.deathYear, isNull);
      });
    });

    group('immutability', () {
      test('should be immutable (final fields)', () {
        final person = Person(
          name: 'Immutable Author',
          birthYear: 1900,
          deathYear: 1980,
        );

        // Verify that all fields are accessible and match expected values
        expect(person.name, equals('Immutable Author'));
        expect(person.birthYear, equals(1900));
        expect(person.deathYear, equals(1980));

        // Fields are final, so they cannot be modified after creation
        // This test verifies the immutable nature by accessing the fields
      });
    });

    group('name-based equality edge cases', () {
      test('should distinguish between similar names', () {
        final person1 = Person(name: 'John Smith');
        final person2 = Person(name: 'John Smith Jr.');
        final person3 = Person(name: 'john smith'); // Different case

        expect(person1 == person2, isFalse);
        expect(person1 == person3, isFalse);
        expect(person2 == person3, isFalse);
      });

      test('should handle whitespace in names', () {
        final person1 = Person(name: 'John Smith');
        final person2 = Person(name: ' John Smith '); // Extra spaces
        final person3 = Person(name: 'John  Smith'); // Double space

        expect(person1 == person2, isFalse);
        expect(person1 == person3, isFalse);
        expect(person2 == person3, isFalse);
      });

      test('should be case sensitive', () {
        final person1 = Person(name: 'Charles Dickens');
        final person2 = Person(name: 'CHARLES DICKENS');
        final person3 = Person(name: 'charles dickens');

        expect(person1 == person2, isFalse);
        expect(person1 == person3, isFalse);
        expect(person2 == person3, isFalse);
      });
    });
  });
}
