import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool get idDarkMode => themeMode == ThemeMode.dark;
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
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

class TempProvider extends ChangeNotifier {
  String temp = 'metric';
  bool get isFarengeit => temp == 'imperial';
  void changeTemp(bool isOn) {
    temp = isOn ? 'imperial' : 'metric';
    notifyListeners();
  }
}
