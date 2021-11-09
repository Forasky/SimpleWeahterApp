// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/services/moor_database.dart';
import 'package:final_project/services/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moor/moor.dart' hide Column;
import 'package:provider/provider.dart';

var name;
var temp;
var currently;
final stream = GetIt.instance.get<TaskDao>();

class CityScreen extends StatefulWidget {
  final ValueChanged<String> onCityTab;
  CityScreen({required this.onCityTab, Key? key}) : super(key: key);

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
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: context.watch<ThemeCubit>().state.theme,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      home: Column(
        children: <Widget>[
          Expanded(
            child: _buildTaskList(context),
          ),
          AddCity(),
        ],
      ),
    );
  }

  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    return StreamBuilder(
      stream: stream.watchAllTasks(),
      builder: (context, snapshot) {
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
            return _buildListItem(itemTask, stream);
          },
        );
      },
    );
  }

  Widget _buildListItem(Task itemTask, TaskDao stream) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'delete'.tr(),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => stream.deleteTask(itemTask),
        )
      ],
      child: TextButton(
        onPressed: () => {
          widget.onCityTab(
            itemTask.name.toString(),
          ),
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              itemTask.name.toString(),
              style: GoogleFonts.comfortaa(
                fontSize: 28,
              ),
            ),
          ],
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
                  'add'.tr(),
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
                context: context, builder: (BuildContext context) => PopUp());
          },
        ),
      ),
    );
  }
}

class PopUp extends StatefulWidget {
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  TextEditingController cityController = TextEditingController();
  String message = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        obscureText: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'enter city'.tr(),
        ),
        controller: cityController,
      ),
      actions: [
        Text(
          message.tr(),
          style: GoogleFonts.comfortaa(fontSize: 12, color: Colors.black),
        ),
        TextButton(
          onPressed: () async {
            final task = TasksCompanion(name: Value(cityController.text));
            if (await stream.checkName(cityController.text))
              stream.insertTask(task);
            else
              cityController.clear();
            message = stream.msg;
            setState(() {});
          },
          child: Text('submit').tr(),
        ),
      ],
    );
  }
}
