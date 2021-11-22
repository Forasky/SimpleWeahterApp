// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:final_project/bloc/autorization_bloc.dart';
import 'package:final_project/bloc/change_temp_bloc.dart';
import 'package:final_project/bloc/theme_bloc.dart';
import 'package:final_project/models/change_temp_model.dart';
import 'package:final_project/models/theme_model.dart';
import 'package:final_project/screens/select_language.dart';
import 'package:final_project/screens/signup.dart';
import 'package:final_project/services/helping_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class _ChangeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Switch.adaptive(
          value: state.wasDark,
          onChanged: (value) {
            value == true
                ? context.read<ThemeCubit>().changeDark()
                : context.read<ThemeCubit>().changeLight();
          },
        );
      },
    );
  }
}

class ChngTepmButton extends StatefulWidget {
  @override
  State<ChngTepmButton> createState() => _ChngTepmButtonState();
}

class _ChngTepmButtonState extends State<ChngTepmButton> {
  final getit = GetIt.instance.get<ChangeTempBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeTempBloc, TempState>(
      builder: (context, state) {
        return Switch.adaptive(
          value: getit.state.wasImperial,
          onChanged: (value) {
            value == true ? getit.changeFarengeit() : getit.changeMetric();
            setState(() {});
            print(getit.state.temp);
          },
        );
      },
    );
  }
}

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final bloc = GetIt.instance.get<AuthenticationBloc>();
  static String png = 'assets/images/avatar.png';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: context.watch<ThemeCubit>().state.theme,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      home: BlocProvider(
        create: (_) => ChangeTempBloc(),
        child: Scaffold(
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
                      stops: [0, 1.0],
                      colors: [
                        Colors.green,
                        Colors.blueGrey,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
                        child: ClipOval(
                          child: Image.asset(
                            png,
                            width: 128,
                            height: 128,
                          ),
                        ),
                      ),
                      Text(
                        bloc.state.userName.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        bloc.state.eMail.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextButton(
                          onPressed: () {
                            bloc.logOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ),
                            );
                          },
                          child: Text(
                            LocalizationKeys.logout,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          LocalizationKeys.switchTheme,
                          style: GoogleFonts.comfortaa(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        _ChangeButton(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          LocalizationKeys.switchTemp,
                          style: GoogleFonts.comfortaa(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        ChngTepmButton(),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 4,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          LocalizationKeys.chooseLanguage,
                          style: GoogleFonts.comfortaa(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.language,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => LanguageView(),
                            fullscreenDialog: true),
                      );
                    },
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
      ),
    );
  }
}
