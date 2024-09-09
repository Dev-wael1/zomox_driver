import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/config/prefConstatnt.dart';
import 'package:zomox_driver/const/preference.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/update_driver_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';

class NotificationCenterScreen extends StatefulWidget {
  @override
  _NotificationCenterScreenState createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  var _value = false;
  bool loading = false;

  bool isSwitched = false;
  int notification = 0;

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        notification = 1;
      });
    } else {
      setState(() {
        isSwitched = false;
        notification = 0;
      });
    }
  }

  @override 
  void initState() {
    super.initState();
     notification = int.parse(SharedPreferenceHelper.getString(Preferences.notification));
    _value = int.parse(SharedPreferenceHelper.getString(Preferences.notification)) == 1 ? true : false;
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
          getTranslated(context, notificationCenter_title).toString(),
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
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 40, 5, 0),
                      child: SwitchListTile(
                        title: Text(
                          getTranslated(context, notificationCenter_mute).toString(),
                          style: TextStyle(color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        value: _value,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                            if (_value == true) {
                              setState(() {
                                notification = 1;
                                SharedPreferenceHelper.setString(Preferences.notification, 1.toString());
                              });
                            } else if (_value == false) {
                              setState(() {
                                notification = 0;
                                SharedPreferenceHelper.setString(Preferences.notification, 0.toString());
                              });
                            }
                            callApiUpdateDriverDetail();
                          });
                        },
                        activeColor: Palette.white,
                        activeTrackColor: Palette.loginHead,
                        inactiveThumbColor: Palette.white,
                        inactiveTrackColor: Palette.switchS,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(
                        getTranslated(context, notificationCenter_mute_text).toString(),
                        style: TextStyle(
                          color: Palette.switchS,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<BaseModel<UpdateDriverModel>> callApiUpdateDriverDetail() async {
    UpdateDriverModel response;
    Map<String, dynamic> body = {
      "notification": notification,
    };
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).updateDriverRequest(body);
      setState(() {
        loading = false;
        Fluttertoast.showToast(msg: 'Changes Successfully', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
