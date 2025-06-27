import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/book.dart' as entity;
import 'person_model.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel extends entity.Book {
  @override
  final int id;
  
  @override
  final String title;
  
  @override
  final List<String> subjects;
  
  @override
  final List<PersonModel> authors;
  
  @override
  final List<String> bookshelves;
  
  @override
  final List<String> languages;
  
  @override
  final bool? copyright;
  
  @JsonKey(name: 'media_type')
  @override
  final String mediaType;
  
  @override
  final Map<String, String> formats;
  
  @JsonKey(name: 'download_count')
  @override
  final int downloadCount;

  const BookModel({
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
  }) : super(
          id: id,
          title: title,
          subjects: subjects,
          authors: authors,
          bookshelves: bookshelves,
          languages: languages,
          copyright: copyright,
          mediaType: mediaType,
          formats: formats,
          downloadCount: downloadCount,
        );

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}
