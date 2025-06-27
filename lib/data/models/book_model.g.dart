// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  subjects: (json['subjects'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  authors: (json['authors'] as List<dynamic>)
      .map((e) => PersonModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  bookshelves: (json['bookshelves'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  languages: (json['languages'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  copyright: json['copyright'] as bool?,
  mediaType: json['media_type'] as String,
  formats: Map<String, String>.from(json['formats'] as Map),
  downloadCount: (json['download_count'] as num).toInt(),
);

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subjects': instance.subjects,
  'authors': instance.authors,
  'bookshelves': instance.bookshelves,
  'languages': instance.languages,
  'copyright': instance.copyright,
  'media_type': instance.mediaType,
  'formats': instance.formats,
  'download_count': instance.downloadCount,
};
