import 'dart:convert';
import 'package:final_project/services/app_localizations.dart';
import 'package:final_project/services/moor_database.dart';
import 'package:final_project/services/themes.dart';
import 'package:final_project/tables/city.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

var name;
var temp;
var currently;
List<City> cities;

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TempProvider()),
        Provider(create: (context) => AppDatebase()),
      ],
      child: MaterialApp(
        themeMode: Provider.of<ThemeProvider>(context, listen: false).themeMode,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        home: Column(
          children: <Widget>[
            Expanded(child: _buildTaskList(context)),
            AddCity(),
          ],
        ),
      ),
    );
  }

  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    final database = Provider.of<AppDatebase>(context, listen: false);
    return StreamBuilder(
        stream: database.watchAllTasks(),
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          final tasks = snapshot.data ?? List();

          return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final itemTask = tasks[index];
                return _buildListItem(itemTask, database);
              });
        });
  }

  Widget _buildListItem(Task itemTask, AppDatebase database) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => database.deleteTask(itemTask),
          )
        ],
        child: TextButton(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text(itemTask.name.toString()), Text('33 0')],
          ),
        ));
  }
}

// class CityWidget extends StatefulWidget {
//   @override
//   _CityWidgetState createState() => _CityWidgetState();
// }

// class _CityWidgetState extends State<CityWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return LimitedBox(
//       maxWidth: MediaQuery.of(context).size.width,
//       maxHeight: 110,
//       child: Scaffold(
//         body: Container(
//           height: 110,
//           margin: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             image: DecorationImage(
//               image: AssetImage('assets/images/rain.gif'),
//               fit: BoxFit.fill,
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 20),
//                 child: Text(
//                   '${cities[0].name}',
//                   style: TextStyle(
//                     fontSize: 30,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(right: 20),
//                 child: Text(
//                   '33 С0',
//                   style: TextStyle(
//                     fontSize: 40,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class AddCity extends StatefulWidget {
  @override
  _AddCity createState() => _AddCity();
}

class _AddCity extends State<AddCity> {
  TextEditingController cityController = TextEditingController();
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
                  ''
                  //AppLocalizations.of(context).translate('add city'),
                  ,
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
                    labelText: 'insert//'
                    /*AppLocalizations.of(context).translate('insert city')*/,
                  ),
                  controller: cityController,
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        final database =
                            Provider.of<AppDatebase>(context, listen: false);
                        final task = Task(name: cityController.text);
                        database.insertTask(task);
                        cityController.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                          AppLocalizations.of(context).translate('submit'))),
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

  Future getTemperature() async {
    http.Response responce = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=${cityController.text}&appid=29e75f209ad00e2d850bcaf376406c7b&units=metric&lang=ru'));
    results = jsonDecode(responce.body);
    return print(
        'http://api.openweathermap.org/data/2.5/weather?q=${cityController.text}&appid=29e75f209ad00e2d850bcaf376406c7b&units=metric&lang=ru');
  }
}
