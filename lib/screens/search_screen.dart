// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/bloc/database_bloc.dart';
import 'package:final_project/bloc/search_bloc.dart';
import 'package:final_project/bloc/theme_bloc.dart';
import 'package:final_project/models/searchBloc_model.dart';
import 'package:final_project/models/theme_model.dart';
import 'package:final_project/services/helping_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final ValueChanged<String> onCityTab;
  SearchScreen({required this.onCityTab, Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final bloc = GetIt.instance.get<SearchBloc>();
  final database = GetIt.instance.get<DatabaseBloc>();

  @override
  void initState() {
    super.initState();
    bloc.getText();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<SearchBloc, SearchBlocState>(
        bloc: bloc,
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            themeMode: context.watch<ThemeCubit>().state.theme,
            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            home: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                    child: SizedBox(
                      width: 350,
                      child: TextField(
                        onChanged: (value) => bloc.textChanged(value),
                        decoration: InputDecoration.collapsed(
                          hintText: LocalizationKeys.enterCity,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: state.foundUsers.isEmpty && state.items.isNotEmpty
                  ? Align(
                      alignment: Alignment.center,
                      child: Text(LocalizationKeys.noDataFound),
                    )
                  : (state.foundUsers.isEmpty)
                      ? Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: state.foundUsers.length,
                          itemBuilder: (context, index) {
                            return TextButton(
                              onPressed: () => {
                                widget
                                    .onCityTab(state.foundUsers[index]["name"]),
                              },
                              onLongPress: () {
                                database.insertTask(
                                    state.foundUsers[index]["name"]);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    state.foundUsers[index]["name"],
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 16,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    state.foundUsers[index]["country"],
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
          );
        },
      ),
    );
  }
}
