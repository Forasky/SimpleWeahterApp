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
  final VoidCallback? indexSelected;
  const AdminPage({Key? key, this.indexSelected}) : super(key: key);
  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  TextEditingController cityController = TextEditingController();
  int currentIndex = 0;

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
      child: SearchScreen(),
    ),
    Center(
      child: SettingScreen(),
    )
  ];

  setPage(int index) {
    setState(() {
      currentIndex = index;
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
              body: IndexedStack(
                index: currentIndex,
                children: tabs,
              ),
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
