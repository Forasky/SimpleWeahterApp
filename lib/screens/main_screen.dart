// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/bloc/change_temp_bloc.dart';
import 'package:final_project/bloc/theme_bloc.dart';
import 'package:final_project/models/theme_model.dart';
import 'package:final_project/screens/cities_screen.dart';
import 'package:final_project/screens/search_screen.dart';
import 'package:final_project/screens/settings_screen.dart';
import 'package:final_project/screens/weather_screen.dart';
import 'package:final_project/services/helping_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminPage();
  }
}

class AdminPage extends StatefulWidget {
  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  final cityController = TextEditingController();
  int currentIndex = 0;
  String ciName = 'Minsk';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  void _setPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget _getPage(int index) {
    if (index == 0)
      return WeatherScreen(
        cityName: ciName,
      );
    if (index == 1) return CityScreen(onCityTab: _navigateToHome);
    if (index == 2) return SearchScreen(onCityTab: _navigateToHome);
    return BlocProvider(
        create: (_) => ChangeTempBloc(), child: SettingScreen());
  }

  void _navigateToHome(String city) {
    setState(() {
      ciName = city;
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (BuildContext context) => ThemeCubit(),
        ),
        BlocProvider<ChangeTempBloc>(
          create: (BuildContext context) => ChangeTempBloc(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: context.watch<ThemeCubit>().state.theme,
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          home: Scaffold(
            body: _getPage(currentIndex),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => _setPage(index),
              items: [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.cloud),
                  label: LocalizationKeys.weather,
                  backgroundColor: Colors.blueAccent,
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.city),
                  label: LocalizationKeys.city,
                  backgroundColor: Colors.grey,
                ),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.search),
                    label: LocalizationKeys.search,
                    backgroundColor: Colors.purple),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.cogs),
                  label: LocalizationKeys.settings,
                  backgroundColor: Colors.redAccent,
                )
              ],
            ),
          ),
        ),
    );
  }
}
