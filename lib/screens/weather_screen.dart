import 'package:final_project/services/api_serv.dart';
import 'package:final_project/services/app_localizations.dart';
import 'package:final_project/services/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Weather wt = Weather();
  TextEditingController cityController = TextEditingController();
  var results;
  String wrCity = 'Введите город';

  var name;
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: Center(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        this.name != null
                            ? AppLocalizations.of(context)
                                .translate('now in' /* + '${this.name}'*/)
                            : AppLocalizations.of(context)
                                .translate('insert city'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      this.temp != null
                          ? AppLocalizations.of(context).translate('C°')
                          : AppLocalizations.of(context).translate('loading'),
                      style: TextStyle(
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
                            : AppLocalizations.of(context).translate('loading'),
                        style: TextStyle(
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
                  results = await wt.getTemperature(cityController.text);
                  getResult();
                },
                child: Text(AppLocalizations.of(context).translate('submit')),
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 100,
                      color: Colors.red,
                    ),
                    Container(
                      width: 100,
                      color: Colors.green,
                    ),
                    Container(
                      width: 100,
                      color: Colors.black,
                    ),
                    Container(
                      width: 100,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ListView(
                    children: [
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.thermometer),
                        title: Text(this.temp != null
                            ? AppLocalizations.of(context).translate('temp')
                            : AppLocalizations.of(context)
                                .translate('loading')),
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.cloud),
                        title: Text(this.description != null
                            ? AppLocalizations.of(context).translate('weather')
                            : AppLocalizations.of(context)
                                .translate('loading')),
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.sun),
                        title: Text(this.humidity != null
                            ? AppLocalizations.of(context).translate('humidity')
                            : AppLocalizations.of(context)
                                .translate('loading')),
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.wind),
                        title: Text(this.temp != null
                            ? AppLocalizations.of(context).translate('speedw')
                            : AppLocalizations.of(context)
                                .translate('loading')),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getResult() {
    setState(() {
      try {
        this.name = results['name'];
        this.temp = results['main']['temp'];
        this.description = results['weather'][0]['description'];
        this.currently = results['weather'][0]['main'];
        this.humidity = results['main']['humidity'];
        this.windSpeed = results['wind']['speed'];
      } on Exception catch (_) {}
    });
  }

  // Future getTemperature() async {
  //   http.Response responce = await http.get(Uri.parse(
  //       'http://api.openweathermap.org/data/2.5/weather?q=${cityController.text}&appid=29e75f209ad00e2d850bcaf376406c7b&units=metric&lang=ru'));
  //   var results = jsonDecode(responce.body);

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
