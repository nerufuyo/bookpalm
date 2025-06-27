import 'book.dart';

class BookListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Book> results;

  const BookListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });
}
