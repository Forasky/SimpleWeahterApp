// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Model {
    Model({
        required this.city,
    });

    final List<City> city;

    factory Model.fromJson(Map<String, dynamic> json) =>
      _$ModelFromJson(json);
}

@JsonSerializable()
class City {
    City({
        required this.id,
        required this.name,
        required this.country,
    });

    final int id;
    final String name;
    final String country;

    factory City.fromJson(Map<String, dynamic> json) =>
      _$CityFromJson(json);
}
