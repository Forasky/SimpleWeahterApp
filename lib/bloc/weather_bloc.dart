import "dart:async";
import 'dart:convert';
import 'package:final_project/models/weather_model.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'change_temp_bloc.dart';

class TempBloc extends Cubit<Temperature> {
  static const _api = '29e75f209ad00e2d850bcaf376406c7b';
  static const adress = 'http://api.openweathermap.org/data/2.5';
  final getit = GetIt.instance.get<ChangeTempBloc>();

  TempBloc(Temperature initialState) : super(initialState);

  Future getTemperatureNow(String city, String locale) async {
    final responce = await http.get(
      Uri.parse(
          '$adress/weather?q=$city&appid=$_api&units=${getit.state.temp}&lang=$locale'),
    );
    var getCoord = jsonDecode(responce.body);
    var lat = getCoord['coord']['lat'];
    var lon = getCoord['coord']['lon'];
    final url =
        '$adress/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$_api&units=${getit.state.temp}';
    final result = await http.get(Uri.parse(url));
    emit(
      Temperature.fromJson(
        jsonDecode(result.body),
      ),
    );
  }
}
