// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/services/moor_database.dart';
import 'package:final_project/services/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final bloc = GetIt.instance.get<DatabaseBloc>();

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
      stream: bloc.datebase.watchAllTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.active)
        return Align(
            alignment: Alignment.center,
            child: Text('add city').tr(),
          );
        else if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
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
            return _buildListItem(itemTask, bloc);
          },
        );
      },
    );
  }

  Widget _buildListItem(Task itemTask, DatabaseBloc stream) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'delete'.tr(),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => bloc.deleteTask(itemTask),
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
  _AddCityState createState() => _AddCityState();
}

class _AddCityState extends State<AddCity> {
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
                context: context,
                builder: (BuildContext context) => AddingCityPopUp());
          },
        ),
      ),
    );
  }
}

class AddingCityPopUp extends StatefulWidget {
  @override
  _AddingCityPopUpState createState() => _AddingCityPopUpState();
}

class _AddingCityPopUpState extends State<AddingCityPopUp> {
  TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseBloc, AppDatebase>(
      bloc: bloc,
      builder: (context, state) {
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
              bloc.state.msg.tr(),
              style: GoogleFonts.comfortaa(fontSize: 12, color: Colors.black),
            ),
            TextButton(
              onPressed: () async {
                bloc.insertTask(cityController.text);
              },
              child: Text('submit').tr(),
            ),
          ],
        );
      },
    );
  }
}
