import 'dart:convert';
import 'package:final_project/services/moor_database.dart';
import 'package:final_project/services/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:moor/moor.dart' hide Column;
import 'package:provider/provider.dart';

var name;
var temp;
var currently;

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
        Provider(create: (context) => AppDatebase().taskDao),
      ],
      child: MaterialApp(
        themeMode: Provider.of<ThemeProvider>(context).themeMode,
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
    final dao = Provider.of<TaskDao>(context, listen: false);
    return StreamBuilder(
        stream: dao.watchAllTasks(),
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          print(snapshot);
          if (!snapshot.hasData) {
            return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
          final tasks = snapshot.data;
          return ListView.builder(
              itemCount: tasks!.length,
              itemBuilder: (context, index) {
                final itemTask = tasks[index];
                return _buildListItem(itemTask, dao);
              });
        });
  }

  Widget _buildListItem(Task itemTask, TaskDao dao) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => dao.deleteTask(itemTask),
          )
        ],
        child: TextButton(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(itemTask.name.toString(),
                  style:
                      GoogleFonts.comfortaa(fontSize: 28, color: Colors.black)),
            ],
          ),
        ));
  }
}

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
      maxHeight: 150,
      child: Container(
        padding: EdgeInsets.all(10),
        child: TextButton(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Add city',
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
                    labelText: 'insert city',
                  ),
                  controller: cityController,
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      getTemperature(cityController.text);
                      final dao = Provider.of<TaskDao>(context, listen: false);
                      final task =
                          TasksCompanion(name: Value(cityController.text));
                      dao.insertTask(task);
                      cityController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('submit'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future getTemperature(String city) async {
    http.Response responce = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=29e75f209ad00e2d850bcaf376406c7b&units=${Provider.of<TempProvider>(context, listen: false).temp}&lang=ru'));
    results = jsonDecode(responce.body);
    setState(() {
      temp = results['main']['temp'];
    });
  }
}
