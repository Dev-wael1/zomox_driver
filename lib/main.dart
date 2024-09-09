import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zomox_driver/screens/HomePageScreen.dart';
import 'package:flutter/services.dart';
import 'package:zomox_driver/screens/Authentication/LoginScreen.dart';
import 'config/prefConstatnt.dart';
import 'const/preference.dart';
import 'localization/language_localization.dart';
import 'localization/localization_constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceHelper.init();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MyApp());
  });
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getLocale().then((local) => {
          setState(() {
            this._locale = local;
          })
        });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MaterialApp(
        title: 'Zomox',
        locale: _locale,
        supportedLocales: [
          Locale(ENGLISH, 'US'),
          Locale(SPANISH, 'ES'),
          Locale(ARABIC, 'AE'),
        ],
        localizationsDelegates: [
          LanguageLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocal, supportedLocales) {
          for (var local in supportedLocales) {
            if (local.languageCode == deviceLocal!.languageCode &&
                local.countryCode == deviceLocal.countryCode) {
              return deviceLocal;
            }
          }
          return supportedLocales.first;
        },

        debugShowCheckedModeBanner: false,
        home: SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true
            ? HomePageScreen()
            : LoginScreen(),
      );
    }
  }
}


