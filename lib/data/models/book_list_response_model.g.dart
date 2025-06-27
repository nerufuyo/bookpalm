// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookListResponseModel _$BookListResponseModelFromJson(
  Map<String, dynamic> json,
) => BookListResponseModel(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>)
      .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BookListResponseModelToJson(
  BookListResponseModel instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};
