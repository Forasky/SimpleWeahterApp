/*
********************************************************************************
This is first design of WeatherScreen, so i don't want to delete this.
********************************************************************************
*/

import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_project/services/app_localizations.dart';
import 'package:final_project/services/location.dart';
import 'package:final_project/services/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;

class WeatherScreen_old extends StatefulWidget {
  @override
  _WeatherScreenState_old createState() => _WeatherScreenState_old();
}

class _WeatherScreenState_old extends State<WeatherScreen_old> {
  TextEditingController cityController = TextEditingController();
  var results;
  String wrCity = 'Введите город';

  var name;
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  Weather w;
  List tempList = [];
  List<String> iconList = [];
  List<String> dateList = [];
  String weatherIconUrl = 'http://openweathermap.org/img/wn/';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TempProvider()),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ru', 'RU'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          home: Center(
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
                          child: Row(
                            children: [
                              Text(
                                this.name != null
                                    ? AppLocalizations.of(context)
                                        .translate('now in')
                                    : AppLocalizations.of(context)
                                        .translate('insert city'),
                                style: GoogleFonts.josefinSans(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                this.name != null ? '  ${this.name}' : '',
                                style: GoogleFonts.josefinSans(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          this.temp != null
                              ? '${this.temp}'
                              : AppLocalizations.of(context)
                                  .translate('loading'),
                          style: GoogleFonts.josefinSans(
                            color: Colors.black,
                            fontSize: 46.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            this.currently != null
                                ? "${this.currently}"
                                : AppLocalizations.of(context)
                                    .translate('loading'),
                            style: GoogleFonts.josefinSans(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: wrCity,
                      ),
                      controller: cityController,
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue)),
                    onPressed: () async {
                      setState(() {
                        wrCity = 'insert city';
                      });
                      await getTemperature();
                      await getHourlyWeather(cityController.text);
                      getResult();
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('submit'),
                      style: GoogleFonts.josefinSans(),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: buildHourlyWeather(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ListView(
                        children: [
                          ListTile(
                            leading: FaIcon(FontAwesomeIcons.thermometer),
                            title: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('temp'),
                                  style: GoogleFonts.josefinSans(),
                                ),
                                Text(
                                  results == null ? ' ' : '  ${this.temp}',
                                  style: GoogleFonts.josefinSans(),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: FaIcon(FontAwesomeIcons.cloud),
                            title: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('weather'),
                                  style: GoogleFonts.josefinSans(),
                                ),
                                Text(
                                  results == null
                                      ? ' '
                                      : '  ${this.description}',
                                  style: GoogleFonts.josefinSans(),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: FaIcon(FontAwesomeIcons.sun),
                            title: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('humidity'),
                                  style: GoogleFonts.josefinSans(),
                                ),
                                Text(
                                  results == null ? ' ' : '  ${this.currently}',
                                  style: GoogleFonts.josefinSans(),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: FaIcon(FontAwesomeIcons.wind),
                            title: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('speedw'),
                                  style: GoogleFonts.josefinSans(),
                                ),
                                Text(
                                  results == null ? ' ' : '  ${this.windSpeed}',
                                  style: GoogleFonts.josefinSans(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getResult() {
    setState(() {
      this.name = results['name'];
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  getHourlyWeather(String cityName) async {
    String url = _getUrlCity(cityName);
    http.Response responce = await http.get(Uri.parse(url));
    Map<String, dynamic> hourlyData = json.decode(responce.body);
    tempList = [];
    iconList = [];
    dateList = [];
    int hourlySize = hourlyData['list'].length;
    tempList.add(hourlyData['list'][0]['main']['temp']);
    for (int i = 0; i < hourlySize; i++) {
      tempList.add(hourlyData['list'][i]['main']['temp']);
      iconList.add(hourlyData['list'][i]['weather'][0]['icon']);
      String date = hourlyData['list'][i]['dt_txt'];
      date = date.substring(11, 16);
      dateList.add(date);
    }
  }

  Container buildHourlyWeather() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            tempList.isEmpty == true ? tempList.length : tempList.length - 1,
        itemBuilder: (context, index) {
          return Container(
            width: 90.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(tempList[index].toInt().toString() + '°',
                    style: GoogleFonts.josefinSans(color: Colors.black)),
                Container(
                  height: 50.0,
                  width: 50.0,
                  child: Image(
                    image: NetworkImage(
                        '$weatherIconUrl${iconList[index]}@4x.png',
                        scale: 2),
                  ),
                ),
                Text(dateList[index],
                    style: GoogleFonts.josefinSans(color: Colors.black))
              ],
            ),
          );
        },
      ),
    );
  }

  String _getUrlCity(String cityName) {
    String url = 'https://api.openweathermap.org/data/2.5/forecast?';
    url += 'q=$cityName&';
    url += 'appid=29e75f209ad00e2d850bcaf376406c7b&';
    url += 'units=${Provider.of<TempProvider>(context, listen: false).temp}';
    print(url);
    return url;
  }

  Future getTemperature() async {
    http.Response responce = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=${cityController.text}&appid=29e75f209ad00e2d850bcaf376406c7b&units=${Provider.of<TempProvider>(context, listen: false).temp}&lang=ru'));
    results = jsonDecode(responce.body);
  }

  getHourlyWeatherLocation(double lat, double lon) async {
    //TODO add units for TempProvider
    String url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=29e75f209ad00e2d850bcaf376406c7b&units=metric&lang=ru';
    http.Response responce = await http.get(Uri.parse(url));
    Map<String, dynamic> hourlyDataLocation = json.decode(responce.body);
    tempList = [];
    iconList = [];
    dateList = [];
    int hourlySize = hourlyDataLocation['list'].length;
    tempList.add(hourlyDataLocation['list'][0]['main']['temp']);
    for (int i = 0; i < hourlySize; i++) {
      tempList.add(hourlyDataLocation['list'][i]['main']['temp']);
      iconList.add(hourlyDataLocation['list'][i]['weather'][0]['icon']);
      String date = hourlyDataLocation['list'][i]['dt_txt'];
      date = date.substring(11, 16);
      dateList.add(date);
    }
  }

  getGeoWeather() async {
    //TODO add units for TempProvider
    LocationCoordinates loc = LocationCoordinates();
    double lat = 0;
    double lon = 0;
    loc.checkPermision();
    loc.getCurrentLocation().whenComplete(
        () => {lat = loc.getLatitude(), lon = loc.getLongitude()});
    http.Response responce = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=29e75f209ad00e2d850bcaf376406c7b'));
    print(
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=29e75f209ad00e2d850bcaf376406c7b');
    results = jsonDecode(responce.body);
    print(responce.body);
    getHourlyWeatherLocation(lat, lon);
    getResult();
  }
  // {
  //   "coord":
  //   {
  //     "lon":27.5667,
  //     "lat":53.9
  //   },
  //   "weather":
  //   [{
  //     "id":801,
  //     "main":"Clouds",
  //     "description":"небольшая облачность",
  //     "icon":"02d"
  //   }],
  //   "base":"stations",
  //   "main":
  //   {
  //     "temp":24.86,
  //     "feels_like":24.68,
  //     "temp_min":24.86,
  //     "temp_max":24.86,
  //     "pressure":1013,
  //     "humidity":49,
  //     "sea_level":1013,
  //     "grnd_level":988
  //   },
  //   "visibility":10000,
  //   "wind":
  //   {
  //     "speed":5.31,
  //     "deg":290,
  //     "gust":5.82
  //   },
  //   "clouds":
  //   {
  //     "all":24
  //   },
  //   "dt":1627045351,
  //   "sys":
  //   {
  //     "type":1,
  //     "id":8939,
  //     "country":"BY",
  //     "sunrise":1627006137,
  //     "sunset":1627064589
  //   },
  //   "timezone":10800,
  //   "id":625144,
  //   "name":"Минск",
  //   "cod":200
  //  }

  //   setState(() {
  //     this.name = results['name'];
  //     this.temp = results['main']['temp'];
  //     this.description = results['weather'][0]['description'];
  //     this.currently = results['weather'][0]['main'];
  //     this.humidity = results['main']['humidity'];
  //     this.windSpeed = results['wind']['speed'];
  //   });
  // }
}
