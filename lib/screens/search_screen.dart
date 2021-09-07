import 'package:final_project/services/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final List<Map<String, dynamic>> _items = [
  {"id": "0", "name": "Artyom", "country": "BY"},
  {"id": "1", "name": "Andrei", "country": "RU"},
  {"id": "2", "name": "Max", "country": "UA"},
  {"id": "3", "name": "Sashka", "country": "GE"},
  {"id": "4", "name": "Oleg", "country": "FR"},
  {"id": "5", "name": "Somebody", "country": "GB"},
  {"id": "6", "name": "Somebody 2", "country": "PL"},
];
List<Map<String, dynamic>> _foundUsers = [];

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  void getText() async {
    final text = await rootBundle.loadString('assets/cities/cities.list.json');
    return print(text);
  }

  @override
  void initState() {
    _foundUsers = _items;
    getText();
    super.initState();
  }

  void textChanged(String text) {
    List<Map<String, dynamic>> results = [];
    if (text.isEmpty) {
      results = _items;
    } else {
      results = _items
          .where(
              (user) => user["name"].toLowerCase().contains(text.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MaterialApp(
        themeMode: Provider.of<ThemeProvider>(context).themeMode,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                child: SizedBox(
                    width: 350,
                    child: TextField(
                      onChanged: (value) => textChanged(value),
                      decoration:
                          InputDecoration.collapsed(hintText: "Enter City"),
                    )),
              ),
            ],
          ),
          body: _foundUsers.length > 0
              ? ListView.builder(
                  itemCount: _foundUsers.length,
                  itemBuilder: (context, index) {
                    return TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(_foundUsers[index]["name"],
                                style: GoogleFonts.comfortaa(
                                    fontSize: 16,
                                    decoration: TextDecoration.none,
                                    color: Colors.black)),
                            // Text(_foundUsers[index]["country"],
                            //     style: GoogleFonts.comfortaa(
                            //         fontSize: 16,
                            //         decoration: TextDecoration.none,
                            //         color: Colors.black)),
                          ],
                        ));
                  },
                )
              : Text('No data found'),
        ),
      ),
    );
  }
}
