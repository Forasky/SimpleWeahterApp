import 'package:final_project/screens/cities_screen.dart';
import 'package:final_project/screens/settings_screen.dart';
import 'package:final_project/screens/weather_screen.dart';
import 'package:final_project/services/app_localizations.dart';
import 'package:final_project/services/themes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminPage();
  }
}

class AdminPage extends StatefulWidget {
  @override
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<AdminPage> with SingleTickerProviderStateMixin {
  TextEditingController cityController = TextEditingController();
  int currentIndex = 0; //индекс выбранной нижней вкладки

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final tabs = [
    Center(
      child: WeatherScreen(),
    ),
    Center(
      child: CityScreen(),
    ),
    Center(
      child: SettingScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider =
            Provider.of<ThemeProvider>(context, listen: false);
        return MaterialApp(
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ru', 'RU'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          themeMode: themeProvider.themeMode,
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          home: Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: tabs,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
              items: [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.cloud),
                  label: 'weather',
                  backgroundColor: Colors.blueAccent,
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.city),
                  label: 'city',
                  backgroundColor: Colors.grey,
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.cogs),
                  label: 'settings',
                  backgroundColor: Colors.redAccent,
                ),
              ],
            ),
          ),
        );
      });
}
