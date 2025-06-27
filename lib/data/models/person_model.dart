// ignore_for_file: overridden_fields
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/person.dart' as entity;

part 'person_model.g.dart';

@JsonSerializable()
class PersonModel extends entity.Person {
  @JsonKey(name: 'birth_year')
  @override
  final int? birthYear;

  @JsonKey(name: 'death_year')
  @override
  final int? deathYear;

  const PersonModel({this.birthYear, this.deathYear, required super.name})
    : super(birthYear: birthYear, deathYear: deathYear);

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonModelToJson(this);
}
