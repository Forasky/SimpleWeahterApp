import 'package:final_project/screens/cities_screen.dart';
import 'package:final_project/screens/search_screen.dart';
import 'package:final_project/screens/settings_screen.dart';
import 'package:final_project/screens/weather1_screen.dart';
import 'package:final_project/services/themes.dart';
import 'package:flutter/material.dart';
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
    if (index == 1) return CityScreen();
    if (index == 2) return SearchScreen(onCityTab: navigateToHome);
    return SettingScreen();
  }

  void navigateToHome(String city) {
    setState(() {
      ciName = city;
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ],
          child: MaterialApp(
            themeMode:
                Provider.of<ThemeProvider>(context, listen: false).themeMode,
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
                    label: 'weather',
                    backgroundColor: Colors.blueAccent,
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.city),
                    label: 'city',
                    backgroundColor: Colors.grey,
                  ),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.search),
                      label: 'search',
                      backgroundColor: Colors.purple),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.cogs),
                    label: 'settings',
                    backgroundColor: Colors.redAccent,
                  )
                ],
              ),
            ),
          ),
        );
      });
}
