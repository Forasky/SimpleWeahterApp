import 'package:flutter/material.dart';

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
  ThemeState({
    required this.theme,
    required this.wasDark,
  });

  final ThemeMode theme;
  final bool wasDark;
}
