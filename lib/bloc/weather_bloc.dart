import "dart:async";
import 'dart:convert';
import 'package:final_project/models/weather_model.dart';
import 'package:final_project/services/helping_classes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'change_temp_bloc.dart';

class TempBloc extends Cubit<WeatherBlocState> {
  static const _api = '29e75f209ad00e2d850bcaf376406c7b';
  static const adress = 'http://api.openweathermap.org/data/2.5';
  final getit = GetIt.instance.get<ChangeTempBloc>();
  late double lat;
  late double lon;

  TempBloc(WeatherBlocState initialState) : super(initialState);

  Future getTemperatureNow(String city, String locale) async {
    final responce = await http.get(
      Uri.parse(
          '$adress/weather?q=$city&appid=$_api&units=${getit.state.temp}&lang=$locale'),
    );
    var getCoord = jsonDecode(responce.body);
    lat = getCoord['coord']['lat'];
    lon = getCoord['coord']['lon'];
    final url =
        '$adress/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$_api&units=${getit.state.temp}';
    final result = await http.get(Uri.parse(url));
    emit(
      WeatherBlocState(
        temperature: Temperature.fromJson(
          jsonDecode(result.body),
        ),
        currentCity: '$city',
      ),
    );
  }

  Future getTemperatureFormMap(double lat, double lon, String locale) async {
    final url =
        '$adress/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$_api&units=${getit.state.temp}';
    final result = await http.get(Uri.parse(url));
    emit(
      WeatherBlocState(
        temperature: Temperature.fromJson(
          jsonDecode(result.body),
        ),
        currentCity: LocalizationKeys.locationFromMap,
      ),
    );
  }

  void getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final location = await Geolocator.getCurrentPosition();
    try {
      lat = location.latitude;
      lon = location.longitude;
    } catch (e) {
    } finally {
      final url =
          '$adress/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$_api&units=${getit.state.temp}';
      final result = await http.get(
        Uri.parse(url),
      );
      emit(
        WeatherBlocState(
          temperature: Temperature.fromJson(
            jsonDecode(result.body),
          ),
          currentCity: LocalizationKeys.yourLocation,
        ),
      );
    }
  }
}
