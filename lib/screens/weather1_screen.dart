import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_project/services/app_localizations.dart';
import 'package:final_project/services/location.dart';
import 'package:final_project/services/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController cityController = TextEditingController();
  var results;

  String name;
  double lat;
  double lon;
  double feellike;
  String icon;
  double temp;
  String currently;
  double humidity;
  double windSpeed;
  double visibility;
  double pressure;
  var lastupdate;
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
          debugShowCheckedModeBanner: false,
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
          home: RefreshIndicator(
            color: Colors.transparent,
            backgroundColor: Colors.transparent,
            onRefresh: name != null ? () => getTemperature(name) : () {},
            child: Column(
              children: [
                searchBar(),
                if (results != null)
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      children: [
                        CityView(city: name, latitude: lat, longitude: lon),
                        TempShow(temp: temp, feelLike: feellike, idIcon: icon),
                        Center(
                          child: Text(
                            '${this.currently}',
                            style: GoogleFonts.comfortaa(
                                fontSize: 30, color: Colors.white),
                          ),
                        ),
                        buildHourlyWeather(),
                        OtherWidgets(
                          humidity: humidity,
                          visible: visibility,
                          windSpeed: windSpeed,
                          pressure: pressure,
                        ),
                        LastUpdated(
                          lastupdated: lastupdate,
                        ),
                      ],
                    ),
                  )
                else
                  Text('insert city',
                      style: GoogleFonts.comfortaa(
                          fontSize: 20, color: Colors.black))
              ],
            ),
          ),
        ),
      ),
    );
  }

  searchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () => getTemperature(cityController.text),
                icon: FaIcon(FontAwesomeIcons.search)),
            Expanded(
                child: TextField(
              controller: cityController,
              decoration: InputDecoration.collapsed(hintText: "Enter City"),
            ))
          ],
        ),
      ),
    );
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

  getResult() {
    setState(() {
      this.lat = results['coord']['lat'] as double;
      this.lon = results['coord']['lon'] as double;
      this.icon = results['weather'][0]['icon'];
      this.currently = results['weather'][0]['description'];
      this.name = results['name'];
      this.feellike = results['main']['feels_like'] as double;
      this.humidity = results['main']['humidity'];
      this.pressure = results['main']['pressure'];
      this.temp = results['main']['temp'] as double;
      this.visibility = results['visibility'];
      this.windSpeed = results['wind']['speed'] as double;
      this.lastupdate =
          DateTime.fromMillisecondsSinceEpoch(results['dt'] * 1000);
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

  String _getUrlCity(String cityName) {
    String url = 'https://api.openweathermap.org/data/2.5/forecast?';
    url += 'q=$cityName&';
    url += 'appid=29e75f209ad00e2d850bcaf376406c7b&';
    url += 'units=${Provider.of<TempProvider>(context, listen: false).temp}';
    print(url);
    return url;
  }

  Future getTemperature(String city) async {
    http.Response responce = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=29e75f209ad00e2d850bcaf376406c7b&units=${Provider.of<TempProvider>(context, listen: false).temp}&lang=ru'));
    results = jsonDecode(responce.body);
    getResult();
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
}

class CityView extends StatelessWidget {
  final String city;
  final double longitude;
  final double latitude;
  const CityView({Key key, this.city, this.latitude, this.longitude})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${this.city}',
            style: GoogleFonts.poiretOne(
              fontSize: 50,
              color: Colors.white,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.mapMarkedAlt,
              color: Colors.white,
              size: 18,
            ),
            Text('${this.longitude}, ${this.latitude}',
                style:
                    GoogleFonts.poiretOne(fontSize: 15, color: Colors.white)),
          ],
        )
      ],
    );
  }
}

class TempShow extends StatelessWidget {
  final double temp;
  final double feelLike;
  final String idIcon;
  const TempShow({Key key, this.temp, this.feelLike, this.idIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text('${this.temp}°',
                  style: GoogleFonts.comfortaa(
                    fontSize: 30,
                    color: Colors.white,
                  )),
              Text('Feels like ${this.feelLike}°',
                  style: GoogleFonts.comfortaa(
                    fontSize: 15,
                    color: Colors.white,
                  )),
            ],
          ),
          Image.network(
              'http://openweathermap.org/img/wn/${this.idIcon}@4x.png'),
        ],
      ),
    );
  }
}

class OtherWidgets extends StatelessWidget {
  final double visible;
  final double humidity;
  final double windSpeed;
  final double pressure;
  const OtherWidgets(
      {Key key, this.humidity, this.visible, this.windSpeed, this.pressure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Humidity',
                  style:
                      GoogleFonts.comfortaa(fontSize: 15, color: Colors.white),
                ),
                SizedBox(
                  width: 40.0,
                ),
                Text(
                  '${this.humidity}%',
                  style:
                      GoogleFonts.comfortaa(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Vision',
                  style:
                      GoogleFonts.comfortaa(fontSize: 15, color: Colors.white),
                ),
                SizedBox(
                  width: 40.0,
                ),
                Text(
                  '${this.visible} m',
                  style:
                      GoogleFonts.comfortaa(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Wind Speed',
                  style:
                      GoogleFonts.comfortaa(fontSize: 15, color: Colors.white),
                ),
                SizedBox(
                  width: 40.0,
                ),
                Text(
                  '${this.windSpeed} m/s',
                  style:
                      GoogleFonts.comfortaa(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Pressure',
                  style:
                      GoogleFonts.comfortaa(fontSize: 15, color: Colors.white),
                ),
                SizedBox(
                  width: 40.0,
                ),
                Text(
                  '${this.pressure} hPa',
                  style:
                      GoogleFonts.comfortaa(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LastUpdated extends StatelessWidget {
  final DateTime lastupdated;
  const LastUpdated({Key key, this.lastupdated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.timesCircle,
            color: Colors.black,
            size: 15,
          ),
          Text(
            'Last updated on ${DateFormat.jm().add_yMd().format(this.lastupdated)}',
            style: GoogleFonts.comfortaa(fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
