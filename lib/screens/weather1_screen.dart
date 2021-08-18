import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_project/services/app_localizations.dart';
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

  var name;
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var lat;
  var lon;
  var icon;
  var lastupdate;
  var sunrise;
  var sunshine;
  var time;
  String textFor;
  bool isDayTime;
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
      child: MaterialApp(
        color: Colors.grey,
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
          // ignore: missing_return
          onRefresh: name != null ? () => getTemperature(name) : () {},
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1.0],
                colors: [
                  Colors.deepOrange[400],
                  Colors.blueGrey,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  searchBar(),
                  if (results != null)
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        children: [
                          CityView(city: name, latitude: lat, longitude: lon),
                          TempShow(
                            temp: temp,
                            idIcon: icon,
                            textFor: textFor,
                          ),
                          Center(
                            child: Text(
                              '${this.currently}',
                              style: GoogleFonts.comfortaa(
                                  fontSize: 30,
                                  decoration: TextDecoration.none,
                                  color: Colors.black),
                            ),
                          ),
                          buildHourlyWeather(),
                          LastUpdated(
                            lastupdated: lastupdate,
                          ),
                        ],
                      ),
                    )
                  else
                    Text('insert city',
                        style: GoogleFonts.comfortaa(
                            fontSize: 20,
                            decoration: TextDecoration.none,
                            color: Colors.black))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  searchBar() {
    return Container(
      padding: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                getTemperature(cityController.text);
                getHourlyWeather(cityController.text);
              },
              icon: FaIcon(FontAwesomeIcons.search)),
          SizedBox(
              width: 300,
              child: TextField(
                controller: cityController,
                decoration: InputDecoration.collapsed(hintText: "Enter City"),
              ))
        ],
      ),
    );
  }

  Container buildHourlyWeather() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
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
                Text(tempList[index].toInt().toString() + ' ' + textFor + '°',
                    style: GoogleFonts.josefinSans(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: 18)),
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
                    style: GoogleFonts.josefinSans(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: 15))
              ],
            ),
          );
        },
      ),
    );
  }

  getResult() {
    setState(() {
      this.lat = results['coord']['lat'];
      this.lon = results['coord']['lon'];
      this.icon = results['weather'][0]['icon'];
      this.currently = results['weather'][0]['description'];
      this.name = results['name'];
      this.humidity = results['main']['humidity'];
      this.temp = results['main']['temp'];
      this.windSpeed = results['wind']['speed'];
      this.sunrise = results['sys']['sunrise'];
      this.sunshine = results['sys']['sunset'];
      this.time = results['dt'];
      this.lastupdate =
          DateTime.fromMillisecondsSinceEpoch(results['dt'] * 1000);
    });
    if (time > sunrise && time < sunshine)
      this.isDayTime = true;
    else
      this.isDayTime = false;
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
    if (Provider.of<TempProvider>(context, listen: false).temp == 'metric')
      textFor = 'C';
    else
      textFor = 'F';
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
              decoration: TextDecoration.none,
              color: Colors.black,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.mapMarkedAlt,
              color: Colors.black,
              size: 18,
            ),
            Text(' ${this.longitude}  ${this.latitude}',
                style: GoogleFonts.poiretOne(
                    fontSize: 18,
                    decoration: TextDecoration.none,
                    color: Colors.black)),
          ],
        )
      ],
    );
  }
}

class TempShow extends StatelessWidget {
  final double temp;
  final String idIcon;
  final String textFor;
  const TempShow({Key key, this.temp, this.idIcon, this.textFor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text('${this.temp} ' + textFor + '°',
                  style: GoogleFonts.comfortaa(
                    fontSize: 30,
                    decoration: TextDecoration.none,
                    color: Colors.black,
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

class LastUpdated extends StatelessWidget {
  final DateTime lastupdated;
  const LastUpdated({Key key, this.lastupdated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Last updated on ${DateFormat.jm().add_yMd().format(this.lastupdated)}',
            style: GoogleFonts.comfortaa(
                fontSize: 15,
                decoration: TextDecoration.none,
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}
