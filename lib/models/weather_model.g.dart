// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Temperature _$TemperatureFromJson(Map<String, dynamic> json) => Temperature(
      current: Current.fromJson(json['current'] as Map<String, dynamic>),
      hourly: (json['hourly'] as List<dynamic>)
          .map((e) => Current.fromJson(e as Map<String, dynamic>))
          .toList(),
      daily: (json['daily'] as List<dynamic>)
          .map((e) => Daily.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasData: true,
    );

Current _$CurrentFromJson(Map<String, dynamic> json) => Current(
      dt: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      pressure: json['pressure'] as int,
      humidity: json['humidity'] as int,
      windSpeed: (json['wind_speed'] as num).toDouble(),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Daily _$DailyFromJson(Map<String, dynamic> json) => Daily(
      dt: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: Temp.fromJson(json['temp'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Temp _$TempFromJson(Map<String, dynamic> json) => Temp(
      day: (json['day'] as num).toDouble(),
      night: (json['night'] as num).toDouble(),
    );
