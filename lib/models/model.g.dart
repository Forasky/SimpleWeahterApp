// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Model _$ModelFromJson(Map<String, dynamic> json) => Model(
      city: (json['city'] as List<dynamic>)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

City _$CityFromJson(Map<String, dynamic> json) => City(
      id: json['id'] as int,
      name: json['name'] as String,
      country: json['country'] as String,
    );
