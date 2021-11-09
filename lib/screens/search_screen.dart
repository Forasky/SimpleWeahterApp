// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/services/moor_database.dart';
import 'package:final_project/services/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final ValueChanged<String> onCityTab;
  SearchScreen({required this.onCityTab, Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final bloc = GetIt.instance.get<SearchBloc>();

  @override
  void initState() {
    _getText();
    super.initState();
  }

  void _getText() async {
    await bloc.getText();
    setState(() {});
  }

  void _changeList(String text) async {
    bloc.textChanged(text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (BuildContext context) => ThemeCubit(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        themeMode: context.watch<ThemeCubit>().state.theme,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                child: SizedBox(
                  width: 350,
                  child: TextField(
                    onChanged: (value) => _changeList(value),
                    decoration:
                        InputDecoration.collapsed(hintText: 'enter city'.tr()),
                  ),
                ),
              ),
            ],
          ),
          body: bloc.cl.foundUsers.isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : bloc.cl.foundUsers.contains(0)
                  ? Align(
                      alignment: Alignment.center,
                      child: Text('no data found').tr(),
                    )
                  : ListView.builder(
                      itemCount: bloc.cl.foundUsers.length,
                      itemBuilder: (context, index) {
                        return TextButton(
                          onPressed: () => {
                            widget.onCityTab(bloc.cl.foundUsers[index]["name"]),
                          },
                          onLongPress: () {
                            final dao =
                                Provider.of<TaskDao>(context, listen: false);
                            final task = TasksCompanion(
                              name: Value(bloc.cl.foundUsers[index]["name"]),
                            );
                            dao.insertTask(task);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                bloc.cl.foundUsers[index]["name"],
                                style: GoogleFonts.comfortaa(
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                bloc.cl.foundUsers[index]["country"],
                                style: GoogleFonts.comfortaa(
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
