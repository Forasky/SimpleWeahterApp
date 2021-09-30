import 'dart:convert';

import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/services/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

List<dynamic> _items = [];
List<dynamic> _foundUsers = [];
List<dynamic> _namedItems = [];

class SearchScreen extends StatefulWidget {
  final ValueChanged<String> onCityTab;
  SearchScreen({required this.onCityTab, Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  void getText() async {
    if (_items.isEmpty == true) {
      final text = await rootBundle.loadString('assets/cities/city_list.json');
      _items = jsonDecode(text) as List<dynamic>;
      _foundUsers = _items;
    } else {
      _foundUsers = _items;
    }
  }

  @override
  void initState() {
    getText();
    super.initState();
  }

  void textChanged(String text) {
    List<dynamic> results = [];
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
          body: _foundUsers.isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : _foundUsers.length > 0
                  ? ListView.builder(
                      itemCount: _foundUsers.length,
                      itemBuilder: (context, index) {
                        return TextButton(
                            onPressed: () =>
                                {widget.onCityTab(_foundUsers[index]["name"])},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(_foundUsers[index]["name"],
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 16,
                                        decoration: TextDecoration.none,
                                        color: Colors.black)),
                                Text(_foundUsers[index]["country"],
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 16,
                                        decoration: TextDecoration.none,
                                        color: Colors.black)),
                              ],
                            ));
                      },
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Text('No data found'),
                    ),
        ),
      ),
    );
  }
}
