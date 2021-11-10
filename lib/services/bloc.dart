import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(
          ThemeState(
            theme: ThemeMode.system,
            wasDark: ThemeMode.system == ThemeMode.dark ? true : false,
          ),
        );

  void changeLight() => emit(
        ThemeState(
          theme: ThemeMode.light,
          wasDark: false,
        ),
      );

  void changeDark() => emit(
        ThemeState(
          theme: ThemeMode.dark,
          wasDark: true,
        ),
      );
}

class MyTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
  );
}

class ThemeState {
  ThemeMode theme;
  bool wasDark;

  ThemeState({required this.theme, required this.wasDark});
}

class ChangeTempBloc extends Cubit<TempState> {
  final locate = GetIt.instance;
  ChangeTempBloc()
      : super(
          TempState(
            temp: 'metric',
            wasImperial: false,
          ),
        );

  void changeMetric() => emit(
        TempState(
          temp: 'metric',
          wasImperial: false,
        ),
      );

  void changeFarengeit() => emit(
        TempState(
          temp: 'imperial',
          wasImperial: true,
        ),
      );
}

class TempState {
  String temp;
  bool wasImperial;
  TempState({
    required this.temp,
    required this.wasImperial,
  });
}

class ThemeBloc extends Cubit<AllColors> {
  DateTime now = DateTime.now();
  ThemeBloc(AllColors initialState) : super(initialState);

  void isDay() => emit(
        AllColors(
          nowText: Colors.black,
          nowTheme: Colors.white,
        ),
      );

  void isNight() => emit(
        AllColors(
          nowText: Colors.black,
          nowTheme: Colors.grey,
        ),
      );

  void checkDay(int sunrise, int sunshine) {
    DateTime now = DateTime.now();
    if (now.isAfter(
              DateTime.fromMillisecondsSinceEpoch(sunrise * 1000),
            ) ==
            true &&
        now.isBefore(
          DateTime.fromMillisecondsSinceEpoch(sunshine * 1000),
        )) {
      isDay();
    } else
      isNight();
  }
}

class AllColors {
  Color nowText;
  Color nowTheme;

  AllColors({
    required this.nowText,
    required this.nowTheme,
  });
}

class TempBloc extends Cubit<WeatherClass> {
  static const _api = '29e75f209ad00e2d850bcaf376406c7b';
  WeatherClass wc = WeatherClass(hasData: false);
  ThemeBloc tb = ThemeBloc(
      AllColors(nowText: Colors.transparent, nowTheme: Colors.transparent));
  final getit = GetIt.instance.get<ChangeTempBloc>().state.temp;

  TempBloc(WeatherClass initialState) : super(WeatherClass(hasData: false));

  Future getTemperatureNow(String city, String locale) async {
    if (city != wc.city) wc.hasData = false;
    http.Response responce = await http.get(
      Uri.parse(
          'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_api&units=$getit&lang=$locale'),
    );
    var results = jsonDecode(responce.body);
    wc.lat = results['coord']['lat'];
    wc.lon = results['coord']['lon'];
    String url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_api&units=$getit';
    http.Response responceHourly = await http.get(Uri.parse(url));
    Map<String, dynamic> hourlyData = json.decode(responceHourly.body);
    url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=${wc.lat}&lon=${wc.lon}&exclude=minutely,hourly&appid=$_api&units=$getit';
    http.Response responceDaily = await http.get(Uri.parse(url));
    wc.tempList = [];
    wc.iconList = [];
    wc.dateList = [];
    int hourlySize = hourlyData['list'].length;
    wc.tempList.add(hourlyData['list'][0]['main']['temp']);
    for (int i = 0; i < hourlySize; i++) {
      wc.tempList.add(hourlyData['list'][i]['main']['temp']);
      wc.iconList.add(hourlyData['list'][i]['weather'][0]['icon']);
      DateTime date = DateTime.parse(hourlyData['list'][i]['dt_txt']);
      wc.dateList.add(date);
    }
    Map<String, dynamic> dailyData = json.decode(responceDaily.body);
    wc.dailytempList = [];
    wc.dailyiconList = [];
    wc.dailydateList = [];
    wc.dailynightList = [];
    int dailySize = dailyData['daily'].length;
    wc.dailytempList.add(dailyData['daily'][0]['temp']['day']);
    for (int i = 0; i < dailySize; i++) {
      wc.dailytempList.add(dailyData['daily'][i]['temp']['day']);
      wc.dailyiconList.add(dailyData['daily'][i]['weather'][0]['icon']);
      wc.dailynightList.add(dailyData['daily'][i]['temp']['night']);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          dailyData['daily'][i]['dt'] * 1000);
      wc.dailydateList.add(date);
    }
    emit(
      WeatherClass(
        hasData: true,
        city: city,
        lat: wc.lat,
        lon: wc.lon,
        temp: results['main']['temp'],
        pressure: results['main']['pressure'],
        currently: results['weather'][0]['description'],
        humidity: results['main']['humidity'],
        windSpeed: results['wind']['speed'],
        icon: results['weather'][0]['icon'],
        lastupdate: DateTime.fromMillisecondsSinceEpoch(
          results['dt'] * 1000,
        ),
        sunrise: results['sys']['sunrise'],
        sunshine: results['sys']['sunset'],
        feelsLike: results['main']['feels_like'],
        tempList: wc.tempList,
        iconList: wc.iconList,
        dateList: wc.dateList,
        dailytempList: wc.dailytempList,
        dailyiconList: wc.dailyiconList,
        dailydateList: wc.dailydateList,
        dailynightList: wc.dailynightList,
      ),
    );
    emit(state);
    //tb.checkDay(wc.sunrise, wc.sunshine);
  }
}

class WeatherClass {
  WeatherClass({
    Key? key,
    required this.hasData,
    this.city,
    this.lat,
    this.lon,
    this.temp,
    this.currently,
    this.humidity,
    this.windSpeed,
    this.icon,
    this.lastupdate,
    this.sunrise,
    this.sunshine,
    this.feelsLike,
    this.pressure,
    this.tempList = const [],
    this.iconList = const [],
    this.dateList = const [],
    this.dailytempList = const [],
    this.dailyiconList = const [],
    this.dailydateList = const [],
    this.dailynightList = const [],
  }) : super();
  var city;
  var lat;
  var lon;
  var temp;
  var currently;
  var humidity;
  var windSpeed;
  var icon;
  var lastupdate;
  var sunrise;
  var sunshine;
  var feelsLike;
  var pressure;
  List<double> tempList;
  List<String> iconList;
  List<DateTime> dateList;
  List dailytempList;
  List<String> dailyiconList;
  List<DateTime> dailydateList;
  List dailynightList;
  late bool hasData;
}

class SearchBloc extends Cubit<CityList> {
  CityList cl = CityList();
  SearchBloc(CityList initialState) : super(initialState);

  Future getText() async {
    final text = await rootBundle.loadString('assets/cities/city_list.json');
    cl.items = jsonDecode(text) as List<dynamic>;
    cl.foundUsers = cl.items;
  }

  void textChanged(String text) {
    List<dynamic> results = [];
    if (text.isEmpty) {
      results = cl.items;
    } else {
      results = cl.items
          .where(
              (city) => city["name"].toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
    cl.foundUsers = results;
  }
}

class CityList {
  List<dynamic> items = [];
  List<dynamic> foundUsers = [];
}
