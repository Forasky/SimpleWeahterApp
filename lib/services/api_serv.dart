import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Wweather {
  TextEditingController cityController = TextEditingController();
  var name;
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;

  // Future getTemperature(String city, String units) async {
  //   http.Response responce = await http.get(Uri.parse(
  //       'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=29e75f209ad00e2d850bcaf376406c7b&units=$units&lang=ru'));
  //   var results = jsonDecode(responce.body);
  //   return results;

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
  //}
}
