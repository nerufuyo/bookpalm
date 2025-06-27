import '../models/book_model.dart';
import '../models/book_list_response_model.dart';

abstract class BookRemoteDataSource {
  Future<BookListResponseModel> getBooks({
    String? search,
    List<String>? languages,
    String? topic,
    int? authorYearStart,
    int? authorYearEnd,
    String? sort,
    int page = 1,
  });
  
  Future<BookModel> getBookById(int id);
}
