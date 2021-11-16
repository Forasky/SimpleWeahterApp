import "dart:async";
import 'dart:convert';
import 'package:final_project/services/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'weather_bloc.g.dart';

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

class TempBloc extends Cubit<Temperature> {
  static const _api = '29e75f209ad00e2d850bcaf376406c7b';
  final getit = GetIt.instance.get<ChangeTempBloc>();

  TempBloc(Temperature initialState) : super(initialState);

  Future getTemperatureNow(String city, String locale) async {
    http.Response responce = await http.get(
      Uri.parse(
          'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_api&units=${getit.state.temp}&lang=$locale'),
    );
    var getCoord = jsonDecode(responce.body);
    var lat = getCoord['coord']['lat'];
    var lon = getCoord['coord']['lon'];
    String url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$_api&units=${getit.state.temp}';
    http.Response result = await http.get(Uri.parse(url));
    emit(
      Temperature.fromJson(
        jsonDecode(result.body),
      ),
    );
  }
}
