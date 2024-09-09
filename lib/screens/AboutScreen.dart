import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/setting_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool loading = false;
  String about = "";

  @override
  void initState() {
    super.initState();
    callApiSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace_outlined,
            color: Palette.loginHead,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          getTranslated(context, about_title).toString(),
          style: TextStyle(color: Palette.loginHead, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        opacity: 0.5,
        progressIndicator: SpinKitFadingCircle(
          color: Palette.removeAcct,
          size: 50.0,
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(
              new FocusNode(),
            );
          },
          child:  Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Html(
                data: "$about",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<BaseModel<SettingModel>> callApiSetting() async {
    SettingModel response;
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).settingRequest();
      setState(() {
        loading = false;
        about = response.data!.deliveryPersonAbout!;
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
