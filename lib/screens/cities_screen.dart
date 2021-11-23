// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/bloc/database_bloc.dart';
import 'package:final_project/bloc/theme_bloc.dart';
import 'package:final_project/models/database_model.dart';
import 'package:final_project/models/theme_model.dart';
import 'package:final_project/services/helping_classes.dart';
import 'package:final_project/services/moor_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

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
    if (bloc.state.listCity.isEmpty) bloc.getText();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseBloc, DatabaseBlocState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: context.watch<ThemeCubit>().state.theme,
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          home: Column(
            children: <Widget>[
              Expanded(
                child: _buildTaskList(context, bloc),
              ),
              AddCity(),
            ],
          ),
        );
      },
    );
  }

  StreamBuilder<List<Task>> _buildTaskList(
      BuildContext context, DatabaseBloc bloc) {
    return StreamBuilder(
      stream: bloc.datebase.watchAllTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.waiting) {
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
            return _BuildListItem(
              itemTask: itemTask,
              onTap: (Task task) => bloc.deleteTask(task),
              onPressed: (Task task) => widget.onCityTab(
                task.name.toString(),
              ),
            );
          },
        );
      },
    );
  }
}

class _BuildListItem extends StatelessWidget {
  final Function(Task) onTap;
  final Function(Task) onPressed;
  final itemTask;

  const _BuildListItem({
    Key? key,
    required this.itemTask,
    required this.onTap,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: LocalizationKeys.delete,
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => onTap(itemTask),
            )
          ],
          child: TextButton(
            onPressed: () => {
              onPressed(
                itemTask,
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
        ),
        Divider(
          height: 4,
          color: Colors.grey,
        ),
      ],
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
                  LocalizationKeys.add,
                  style: TextStyle(fontSize: 18),
                ),
                FaIcon(
                  FontAwesomeIcons.plus,
                  size: 30,
                ),
              ],
            ),
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AddingCityPopUp(),
          ),
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
  late String addingCity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseBloc, DatabaseBlocState>(
      bloc: bloc,
      builder: (context, state) {
        return AlertDialog(
          content: state.listCity.isNotEmpty
              ? DropdownSearch<String>(
                  showSearchBox: true,
                  mode: Mode.BOTTOM_SHEET,
                  items: [
                    ...state.listCity,
                  ],
                  dropdownSearchDecoration: InputDecoration(
                    hintText: LocalizationKeys.chooseCity,
                  ),
                  onChanged: (value) {
                    bloc.textChanged(value ?? '');
                    addingCity = value ?? '';
                  },
                )
              : CircularProgressIndicator(),
          actions: [
            Text(
              state.message,
              style: GoogleFonts.comfortaa(fontSize: 12, color: Colors.black),
            ),
            TextButton(
              onPressed: () async {
                bloc.insertTask(addingCity);
                bloc.resetChanges();
              },
              child: Text(
                LocalizationKeys.submit,
              ),
            ),
          ],
        );
      },
    );
  }
}
