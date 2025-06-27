import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import '../models/book_list_response_model.dart';
import 'book_remote_data_source.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/api_constants.dart';

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final http.Client client;

  BookRemoteDataSourceImpl({required this.client});

  @override
  Future<BookListResponseModel> getBooks({
    String? search,
    List<String>? languages,
    String? topic,
    int? authorYearStart,
    int? authorYearEnd,
    String? sort,
    int page = 1,
  }) async {
    final uri = _buildBooksUri(
      search: search,
      languages: languages,
      topic: topic,
      authorYearStart: authorYearStart,
      authorYearEnd: authorYearEnd,
      sort: sort,
      page: page,
    );

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return BookListResponseModel.fromJson(jsonData);
    } else {
      throw ServerException('Failed to load books: ${response.statusCode}');
    }
  }

  @override
  Future<BookModel> getBookById(int id) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/books/$id');
    
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return BookModel.fromJson(jsonData);
    } else {
      throw ServerException('Failed to load book: ${response.statusCode}');
    }
  }

  Uri _buildBooksUri({
    String? search,
    List<String>? languages,
    String? topic,
    int? authorYearStart,
    int? authorYearEnd,
    String? sort,
    int page = 1,
  }) {
    final queryParams = <String, String>{
      'page': page.toString(),
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    
    if (languages != null && languages.isNotEmpty) {
      queryParams['languages'] = languages.join(',');
    }
    
    if (topic != null && topic.isNotEmpty) {
      queryParams['topic'] = topic;
    }
    
    if (authorYearStart != null) {
      queryParams['author_year_start'] = authorYearStart.toString();
    }
    
    if (authorYearEnd != null) {
      queryParams['author_year_end'] = authorYearEnd.toString();
    }
    
    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }

    return Uri.parse('${ApiConstants.baseUrl}/books').replace(
      queryParameters: queryParams,
    );
  }
}
