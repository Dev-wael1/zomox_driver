import 'package:dio/dio.dart';
import 'package:zomox_driver/config/prefConstatnt.dart';
import 'package:zomox_driver/const/preference.dart';

class RetroApi {
  Dio dioData() {
    final dio = Dio();
    dio.options.headers["Accept"] = "application/json"; // config your dio headers globally

    dio.options.headers["Authorization"] =
        "Bearer " + SharedPreferenceHelper.getString(Preferences.auth_token);

    dio.options.followRedirects = false;
    dio.options.connectTimeout = 75000; //5ss
    dio.options.receiveTimeout = 3500;
    return dio;
  }
}
