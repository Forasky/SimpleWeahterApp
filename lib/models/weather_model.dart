import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

class WeatherBlocState {
  WeatherBlocState({
    required this.temperature,
    required this.currentCity,
  });
  final Temperature temperature;
  final String currentCity;
}

@JsonSerializable()
class Temperature {
  Temperature({
    required this.current,
    required this.hourly,
    required this.daily,
    required this.hasData,
  });

  final Current current;
  final List<Current> hourly;
  final List<Daily> daily;
  final bool hasData;
  final String message = '';

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);
}

@JsonSerializable()
class Current {
  Current({
    required this.dt,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.weather,
  });

  final DateTime dt;
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final List<Weather> weather;

  factory Current.fromJson(Map<String, dynamic> json) =>
      _$CurrentFromJson(json);
}

@JsonSerializable()
class Weather {
  Weather({
    required this.description,
    required this.icon,
  });

  final String description;
  final String icon;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}

@JsonSerializable()
class Daily {
  Daily({
    required this.dt,
    required this.temp,
    required this.weather,
  });

  final DateTime dt;
  final Temp temp;
  final List<Weather> weather;

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);
}

@JsonSerializable()
class Temp {
  Temp({
    required this.day,
    required this.night,
  });

  final double day;
  final double night;

  factory Temp.fromJson(Map<String, dynamic> json) => _$TempFromJson(json);
}
