import 'package:easy_localization/easy_localization.dart';
import 'package:final_project/bloc/theme_bloc.dart';
import 'package:final_project/bloc/weather_bloc.dart';
import 'package:final_project/models/weather_model.dart';
import 'package:final_project/services/helping_classes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  final String cityName;
  WeatherScreen({required this.cityName, Key? key}) : super(key: key);
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final tempbloc = GetIt.instance.get<TempBloc>();
  final Images images = Images();

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
    return BlocBuilder<TempBloc, Temperature>(
      bloc: tempbloc,
      builder: (context, state) {
        return MaterialApp(
          themeMode: context.watch<ThemeCubit>().state.theme,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: state.hasData == true
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(images.images['clear']),
                        fit: BoxFit.fill,
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
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _ShowWeather(
                                  temp: state.current.temp,
                                  icon: state.current.weather.first.icon,
                                ),
                                Text(
                                  state.current.weather.first.description
                                      .toString(),
                                  style: GoogleFonts.comfortaa(fontSize: 30),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    LocalizationKeys.feelLike +
                                        state.current.feelsLike
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
                                            DateFormat.Hm().format(state
                                                        .hourly[index].dt) ==
                                                    '00:00'
                                                ? Text(
                                                    '${DateFormat.Hm().format(state.hourly[index].dt)}\n' +
                                                        DateFormat('EEEE')
                                                            .format(
                                                              state
                                                                  .hourly[index]
                                                                  .dt,
                                                            )
                                                            .toString()
                                                            .tr(),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Text(
                                                    '${DateFormat.Hm().format(
                                                    state.hourly[index].dt,
                                                  )}\n'),
                                            Image.network(
                                                'http://openweathermap.org/img/wn/${state.hourly[index].weather.first.icon}.png'),
                                            Text(state.hourly[index].temp
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
                                    color: Colors.white,
                                  ),
                                  height: 120,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _WeatherContainer(
                                        value: state.current.humidity,
                                        someText: LocalizationKeys.humidity,
                                        icon: Icon(
                                          FontAwesomeIcons.tint,
                                        ),
                                      ),
                                      _WeatherContainer(
                                        value: state.current.windSpeed,
                                        someText: LocalizationKeys.speedWind,
                                        icon: Icon(
                                          FontAwesomeIcons.wind,
                                        ),
                                      ),
                                      _WeatherContainer(
                                        value: state.current.pressure,
                                        someText: LocalizationKeys.pressure,
                                        icon: Icon(
                                          FontAwesomeIcons.sortAmountDownAlt,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 550,
                                  color: Colors.white,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          DateFormat('EEEE').format(
                                            state.daily[index].dt,
                                          ),
                                          style: GoogleFonts.comfortaa(
                                            fontSize: 20,
                                          ),
                                        ).tr(),
                                        subtitle: Text(
                                          DateFormat.d()
                                                  .format(
                                                    state.daily[index].dt,
                                                  )
                                                  .toString() +
                                              ' ' +
                                              DateFormat.LLLL()
                                                  .format(
                                                    state.daily[index].dt,
                                                  )
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
                                                  'http://openweathermap.org/img/wn/${state.daily[index].weather.first.icon}.png'),
                                              Text(
                                                state.daily[index].temp.day
                                                        .toStringAsFixed(1) +
                                                    '°',
                                                style: GoogleFonts.comfortaa(
                                                  fontSize: 22,
                                                ),
                                              ),
                                              Text(
                                                state.daily[index].temp.night
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
                                  color: Colors.white,
                                  child: Text(
                                    LocalizationKeys.lastUpdated(
                                        state.current.dt),
                                    style: GoogleFonts.comfortaa(
                                        fontSize: 15,
                                        decoration: TextDecoration.none,
                                        color: Colors.black),
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
                        Text(LocalizationKeys.wait,
                                style: GoogleFonts.comfortaa(fontSize: 24))
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

class _WeatherContainer extends StatelessWidget {
  final value;
  final someText;
  final icon;

  const _WeatherContainer({
    Key? key,
    required this.value,
    required this.someText,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            value.toString(),
            style: GoogleFonts.comfortaa(
              fontSize: 18,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ShowWeather extends StatelessWidget {
  final temp;
  final icon;
  const _ShowWeather({
    Key? key,
    required this.temp,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
