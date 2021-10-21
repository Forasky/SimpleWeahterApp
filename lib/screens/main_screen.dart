// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/screens/cities_screen.dart';
import 'package:final_project/screens/search_screen.dart';
import 'package:final_project/screens/settings_screen.dart';
import 'package:final_project/screens/weather1_screen.dart';
import 'package:final_project/services/themes.dart';
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
  TextEditingController cityController = TextEditingController();
  int currentIndex = 0;
  String ciName = 'Minsk';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget getPage(int index) {
    if (index == 0)
      return WeatherScreen(
        cityName: ciName,
      );
    if (index == 1) return CityScreen(onCityTab: navigateToHome);
    if (index == 2) return SearchScreen(onCityTab: navigateToHome);
    return BlocProvider(create: (_)=>TempBloc(), child: SettingScreen());
  }

  void navigateToHome(String city) {
    setState(() {
      ciName = city;
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context){
        return MultiProvider(
          providers: [
            BlocProvider<ThemeCubit>(create: (BuildContext context) => ThemeCubit(),),
          ],
          child: BlocProvider(
            create: (_)=>TempBloc(),
            child: MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              themeMode:
                  context.watch<ThemeCubit>().state.theme,
              theme: MyTheme.lightTheme,
              darkTheme: MyTheme.darkTheme,
              home: Scaffold(
                body: getPage(currentIndex),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: (index) => setPage(index),
                  items: [
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.cloud),
                      label: 'weather'.tr(),
                      backgroundColor: Colors.blueAccent,
                    ),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.city),
                      label: 'city'.tr(),
                      backgroundColor: Colors.grey,
                    ),
                    BottomNavigationBarItem(
                        icon: FaIcon(FontAwesomeIcons.search),
                        label: 'search'.tr(),
                        backgroundColor: Colors.purple),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.cogs),
                      label: 'settings'.tr(),
                      backgroundColor: Colors.redAccent,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
}
