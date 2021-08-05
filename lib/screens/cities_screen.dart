import 'package:final_project/services/api_serv.dart';
import 'package:final_project/services/datdbase_class.dart';
import 'package:final_project/services/themes.dart';
import 'package:final_project/tables/city.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

var name;
var temp;
var currently;
late List<City> cities;

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  @override
  void initState() {
    super.initState();
    refreshCities().whenComplete(() {
      setState(() {});
    });
  }

  Future refreshCities() async {
    cities = await DatabaseClass.instance.getCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          for (var i = 0; i < cities.length; i++) CityWidget(),
          AddCity(),
        ],
      ),
    );
  }
}

class CityWidget extends StatefulWidget {
  @override
  _CityWidgetState createState() => _CityWidgetState();
}

class _CityWidgetState extends State<CityWidget> {
  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: 110,
      child: Scaffold(
        body: Container(
          height: 110,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage('assets/images/rain.gif'),
              fit: BoxFit.fill,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Город',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  '33 С0',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCity extends StatefulWidget {
  @override
  _AddCity createState() => _AddCity();
}

class _AddCity extends State<AddCity> {
  TextEditingController cityController = TextEditingController();
  Weather wt = Weather();
  var results;

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: 110,
      child: Container(
        padding: EdgeInsets.all(10),
        child: TextButton(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Добавьте город',
                  style: TextStyle(fontSize: 18),
                ),
                FaIcon(
                  FontAwesomeIcons.plus,
                  size: 30,
                ),
              ],
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Введите название города',
                  ),
                  controller: cityController,
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        results = await wt.getTemperature(cityController.text);
                        getResult();
                        insertCity();
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Text('Добавить')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  getResult() {
    setState(() {
      try {
        name = results['name'];
        temp = results['main']['temp'];
        currently = results['weather'][0]['main'];
      } on Exception catch (_) {}
    });
  }

  insertCity() async {
    City add = City(
      name: cityController.text,
      id: cities.length + 1,
      number: cities.length + 1,
    );
    await DatabaseClass.instance.insert(add);
  }
}
