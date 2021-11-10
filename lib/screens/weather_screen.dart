import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_project/services/bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

final cr = GetIt.instance.get<AllColors>();

class WeatherScreen extends StatefulWidget {
  final String cityName;
  WeatherScreen({required this.cityName, Key? key}) : super(key: key);
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final weather = WeatherClass(hasData: false);
  final tempbloc = GetIt.instance.get<TempBloc>();

  @override
  void initState() {
    super.initState();
    tempbloc.getTemperatureNow(
      widget.cityName,
      Intl.shortLocale(Intl.systemLocale),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TempBloc, WeatherClass>(
      builder: (context, state) {
        return MaterialApp(
          themeMode: context.watch<ThemeCubit>().state.theme,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: tempbloc.state.hasData == true
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0, 1.0],
                        colors: [
                          Colors.indigo,
                          Colors.blueAccent,
                        ],
                      ),
                    ),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          toolbarHeight: 30,
                          expandedHeight: 230,
                          centerTitle: true,
                          title: Text(
                            widget.cityName,
                            style: GoogleFonts.comfortaa(
                                fontSize: 24, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.white,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _showWeather(
                                    tempbloc.state.temp, tempbloc.state.icon),
                                Text(
                                  tempbloc.state.currently.toString(),
                                  style: GoogleFonts.comfortaa(fontSize: 30),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    'feelsLike'.tr() +
                                        tempbloc.state.feelsLike
                                            .toStringAsFixed(1) +
                                        '°',
                                    style: GoogleFonts.comfortaa(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 39,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            DateFormat.Hm().format(tempbloc
                                                        .state.dateList[index]) ==
                                                    '00:00'
                                                ? Text(
                                                    '${DateFormat.Hm().format(tempbloc.state.dateList[index])}\n' +
                                                        DateFormat('EEEE')
                                                            .format(tempbloc.state
                                                                    .dateList[
                                                                index])
                                                            .toString()
                                                            .tr(),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Text(
                                                    '${DateFormat.Hm().format(tempbloc.state.dateList[index])}\n'),
                                            Image.network(
                                                'http://openweathermap.org/img/wn/${tempbloc.state.iconList[index]}.png'),
                                            Text(tempbloc.state.tempList[index]
                                                    .toStringAsFixed(1) +
                                                '°'),
                                          ],
                                        );
                                      }),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        width: 3,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    color: cr.nowTheme,
                                  ),
                                  height: 120,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _weatherContainer(
                                        tempbloc.state.humidity,
                                        'humidity'.tr(),
                                        Icon(
                                          FontAwesomeIcons.tint,
                                        ),
                                      ),
                                      _weatherContainer(
                                        tempbloc.state.windSpeed,
                                        'speedw'.tr(),
                                        Icon(
                                          FontAwesomeIcons.wind,
                                        ),
                                      ),
                                      _weatherContainer(
                                        tempbloc.state.pressure,
                                        'pressure'.tr(),
                                        Icon(
                                          FontAwesomeIcons.sortAmountDownAlt,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 550,
                                  color: cr.nowTheme,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          DateFormat('EEEE').format(
                                            tempbloc.state.dailydateList[index],
                                          ),
                                          style: GoogleFonts.comfortaa(
                                            fontSize: 20,
                                          ),
                                        ).tr(),
                                        subtitle: Text(
                                          DateFormat.d()
                                                  .format(tempbloc
                                                      .state.dailydateList[index])
                                                  .toString() +
                                              ' ' +
                                              DateFormat.LLLL()
                                                  .format(tempbloc
                                                      .state.dailydateList[index])
                                                  .toString()
                                                  .tr(),
                                          style: GoogleFonts.comfortaa(
                                            fontSize: 12,
                                          ),
                                        ),
                                        dense: true,
                                        trailing: SizedBox(
                                          width: 180,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.network(
                                                  'http://openweathermap.org/img/wn/${tempbloc.state.dailyiconList[index]}.png'),
                                              Text(
                                                tempbloc.state.dailytempList[index]
                                                        .toStringAsFixed(1) +
                                                    '°',
                                                style: GoogleFonts.comfortaa(
                                                  fontSize: 22,
                                                ),
                                              ),
                                              Text(
                                                tempbloc.state
                                                        .dailynightList[index]
                                                        .toStringAsFixed(1) +
                                                    '°',
                                                style: GoogleFonts.comfortaa(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: 8,
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width,
                                  color: cr.nowTheme,
                                  child: Text(
                                    'last updated'.tr(
                                      args: [
                                        DateFormat.jm()
                                            .format(tempbloc.state.lastupdate),
                                      ],
                                    ),
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 15,
                                        decoration: TextDecoration.none,
                                        color: cr.nowText),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            );
                          }, childCount: 1),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('wait', style: GoogleFonts.comfortaa(fontSize: 24))
                            .tr(),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

Widget _weatherContainer(var value, var someText, var icon) {
  return Container(
    alignment: Alignment.center,
    height: 100,
    width: 120,
    decoration: BoxDecoration(
      color: Colors.transparent,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        icon,
        Text(
          someText.toString(),
          style: GoogleFonts.comfortaa(
            fontSize: 15,
            color: cr.nowText,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          value.toString(),
          style: GoogleFonts.comfortaa(
            fontSize: 18,
            color: cr.nowText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _showWeather(var temp, var icon) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        temp.toStringAsFixed(1).toString() + '°',
        style: GoogleFonts.comfortaa(fontSize: 35),
        textAlign: TextAlign.center,
      ),
      Image(
        image: NetworkImage('http://openweathermap.org/img/wn/$icon@2x.png'),
      ),
    ],
  );
}
