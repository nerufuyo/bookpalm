// ignore_for_file: overridden_fields
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/book_list_response.dart' as entity;
import 'book_model.dart';

part 'book_list_response_model.g.dart';

@JsonSerializable()
class BookListResponseModel extends entity.BookListResponse {
  @override
  final List<BookModel> results;

  // ignore: use_super_parameters
  const BookListResponseModel({
    required int count,
    String? next,
    String? previous,
    required this.results,
  }) : super(count: count, next: next, previous: previous, results: results);

  factory BookListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BookListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookListResponseModelToJson(this);
}
