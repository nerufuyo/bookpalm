import 'person.dart';

class Book {
  final int id;
  final String title;
  final List<String> subjects;
  final List<Person> authors;
  final List<String> bookshelves;
  final List<String> languages;
  final bool? copyright;
  final String mediaType;
  final Map<String, String> formats;
  final int downloadCount;

  const Book({
    required this.id,
    required this.title,
    required this.subjects,
    required this.authors,
    required this.bookshelves,
    required this.languages,
    this.copyright,
    required this.mediaType,
    required this.formats,
    required this.downloadCount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
