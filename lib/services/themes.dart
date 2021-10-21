
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(theme: ThemeMode.system, wasDark: ThemeMode.dark == true ? true : false ));

  void changeLight() => emit(ThemeState(theme: ThemeMode.light,wasDark: false));

  void changeDark() => emit(ThemeState(theme: ThemeMode.dark,wasDark: true));
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

class TempBloc extends Cubit<TempState> {
  final locate = GetIt.instance;
  TempBloc() : super(TempState(temp: 'metric',wasImperial:  false));

  void changeMetric() {emit(TempState(temp: 'metric',wasImperial: false));
  locate.get<TempState>().temp='metric';
  locate.get<TempState>().wasImperial=false;
  }

  void changeFarengeit() {emit(TempState(temp: 'imperial', wasImperial: true));
  locate.get<TempState>().temp='imperial';
  locate.get<TempState>().wasImperial=true;
  }
}

class TempState {
  String temp;
  bool wasImperial;
  TempState({required this.temp, required this.wasImperial});
}
