import 'package:easy_localization/easy_localization.dart';

class Images {
  final Map<String, dynamic> images = {
    'clear': 'assets/images/clear.jpg',
    'rain': 'assets/images/rainy.jpg',
    'cloudy': 'assets/images/cloudy.jpg',
  };
}

class LocalizationKeys {
  static String login = 'login'.tr();

  static String incorrectUser = 'incorrect user'.tr();

  static String incorrectPassword = 'incorrect password'.tr();

  static String accountExist = 'account exist'.tr();

  static String userNoFound = 'no found'.tr();

  static String noDataFound = 'no data found'.tr();

  static String cityAdded = 'city was added'.tr();

  static String delete = 'delete'.tr();

  static String add = 'add'.tr();

  static String chooseCity = 'choose city'.tr();

  static String submit = 'submit'.tr();

  static String enterEmail = 'enter Email'.tr();

  static String plsEnterEmail = 'please enter Email'.tr();

  static String enterPassword = 'enter password'.tr();

  static String plsEnterPassword = 'please enter password'.tr();

  static String error = 'error'.tr();

  static String signUp = 'signup'.tr();

  static String enterName = 'enter name'.tr();

  static String enterAge = 'enter age'.tr();

  static String weather = 'weather'.tr();

  static String city = 'city'.tr();

  static String search = 'search'.tr();

  static String map = 'map'.tr();

  static String settings = 'settings'.tr();

  static String enterCity = 'enter city'.tr();

  static String chooseLanguage = 'choose language'.tr();

  static String logout = 'logout'.tr();

  static String switchTheme = 'swchTh'.tr();

  static String switchTemp = 'swchTemp'.tr();

  static String singupWithEmail = 'singup with email'.tr();

  static String singupWithGoogle = 'singup with google'.tr();

  static String loginWithEmail = 'login with email'.tr();

  static String feelLike = 'feelsLike'.tr();

  static String humidity = 'humidity'.tr();

  static String speedWind = 'speedw'.tr();

  static String pressure = 'pressure'.tr();

  static String lastUpdated(DateTime dt) => 'last updated'.tr(
        args: [
          DateFormat.jm().format(dt),
        ],
      );

  static String wait = 'wait'.tr();

  static String yourLocation = 'ur location'.tr();

  static String weatherMap = 'weather map'.tr();

  static String getWeather = 'get weather'.tr();

  static String locationFromMap = 'location map'.tr();
}
