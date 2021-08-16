import 'package:final_project/screens/signup.dart';
import 'package:final_project/services/app_localizations.dart';
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
      themeMode: Provider.of<ThemeProvider>(context, listen: false).themeMode,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      home: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
                child: ClipOval(
                    child: Image.asset('assets/images/avatar.png',
                        width: 128, height: 128)),
              ),
              Text(
                '${FirebaseAuth.instance.currentUser.email}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
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
                      AppLocalizations.of(context).translate('logout'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Expanded(
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context).translate('swchTh')),
                      ChangeButton(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Expanded(
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context).translate('swchTemp')),
                      ChngTepmButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
