// ignore_for_file: overridden_fields
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/book.dart' as entity;
import 'person_model.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel extends entity.Book {
  @override
  final List<PersonModel> authors;

  @JsonKey(name: 'media_type')
  @override
  final String mediaType;

  @JsonKey(name: 'download_count')
  @override
  final int downloadCount;

  const BookModel({
    required super.id,
    required super.title,
    required super.subjects,
    required this.authors,
    required super.bookshelves,
    required super.languages,
    super.copyright,
    required this.mediaType,
    required super.formats,
    required this.downloadCount,
  }) : super(
         authors: authors,
         mediaType: mediaType,
         downloadCount: downloadCount,
       );

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$BookModelToJson(this);
    // Manually convert authors to JSON
    json['authors'] = authors.map((author) => author.toJson()).toList();
    return json;
  }
}
