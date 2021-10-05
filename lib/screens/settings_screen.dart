import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/screens/signup.dart';
import 'package:final_project/services/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Switch.adaptive(
        value: themeProvider.idDarkMode,
        onChanged: (value) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
        });
  }
}

class ChngTepmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tempProvider = Provider.of<TempProvider>(context);
    return Switch.adaptive(
        value: tempProvider.isFarengeit,
        onChanged: (value) {
          final provider1 = Provider.of<TempProvider>(context, listen: false);
          provider1.changeTemp(value);
        });
  }
}

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      home: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0,
                        1.0
                      ],
                      colors: [
                        Colors.green,
                        Colors.blueGrey,
                      ]),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
                      child: ClipOval(
                          child: Image.asset('assets/images/avatar.png',
                              width: 128, height: 128)),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.displayName != null
                          ? '${FirebaseAuth.instance.currentUser!.displayName}'
                          : '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${FirebaseAuth.instance.currentUser!.email}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            MaterialPageRoute(builder: (context) => SignUp());
                          },
                          child: Text(
                            'logout',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ).tr()),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 4,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Expanded(
                  child: Row(
                    children: [
                      Text('swchTh').tr(),
                      ChangeButton(),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 4,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Expanded(
                  child: Row(
                    children: [
                      Text('swchTemp').tr(),
                      ChngTepmButton(),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 4,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
