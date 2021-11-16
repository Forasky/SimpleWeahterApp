import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(
          ThemeState(
            theme: ThemeMode.system,
            wasDark: ThemeMode.system == ThemeMode.dark ? true : false,
          ),
        );

  void changeLight() => emit(
        ThemeState(
          theme: ThemeMode.light,
          wasDark: false,
        ),
      );

  void changeDark() => emit(
        ThemeState(
          theme: ThemeMode.dark,
          wasDark: true,
        ),
      );
}

class MyTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
  );
}

class ThemeState {
  ThemeMode theme;
  bool wasDark;

  ThemeState({required this.theme, required this.wasDark});
}

class ChangeTempBloc extends Cubit<TempState> {
  final locate = GetIt.instance;
  ChangeTempBloc()
      : super(
          TempState(
            temp: 'metric',
            wasImperial: false,
          ),
        );

  void changeMetric() => emit(
        TempState(
          temp: 'metric',
          wasImperial: false,
        ),
      );

  void changeFarengeit() => emit(
        TempState(
          temp: 'imperial',
          wasImperial: true,
        ),
      );
}

class TempState {
  String temp;
  bool wasImperial;
  TempState({
    required this.temp,
    required this.wasImperial,
  });
}

class SearchBloc extends Cubit<CityList> {
  CityList cl = CityList();
  SearchBloc(CityList initialState) : super(initialState);

  Future getText() async {
    if (cl.items.isEmpty) {
      final text = await rootBundle.loadString('assets/cities/city_list.json');
      cl.items = jsonDecode(text) as List<dynamic>;
    }
    emit(
      CityList(foundUsers: cl.items),
    );
  }

  void textChanged(String text) {
    List<dynamic> results = [];
    if (text.isEmpty) {
      results = cl.items;
    } else {
      results = cl.items
          .where(
              (city) => city["name"].toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
    emit(
      CityList(foundUsers: results),
    );
  }
}

class CityList {
  List<dynamic> items = [];
  List<dynamic> foundUsers = [];

  CityList({
    this.foundUsers = const [],
  }) : super();
}
