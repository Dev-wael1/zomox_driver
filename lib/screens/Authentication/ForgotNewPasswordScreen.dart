import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/forgot_password_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';
import 'package:zomox_driver/screens/Authentication/LoginScreen.dart';

class ForgotNewPasswordScreen extends StatefulWidget {
  final int? id;

  ForgotNewPasswordScreen({this.id});

  @override
  _ForgotNewPasswordScreenState createState() => _ForgotNewPasswordScreenState();
}

class _ForgotNewPasswordScreenState extends State<ForgotNewPasswordScreen> {
  bool _isHidden = true;
  bool _isHidden2 = true;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
        title: Text(
          getTranslated(context, home_change_password).toString(),
          style: TextStyle(fontSize: 20, color: Palette.loginHead, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace_outlined,
              color: Palette.loginHead,
              size: 35.0,
            ),
            onPressed: () => Navigator.of(context).pop(true)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: SvgPicture.asset('assets/icons/pass.svg')),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _isHidden,
                      style: TextStyle(color: Palette.loginHead),
                      decoration: InputDecoration(
                        suffix: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(color: Palette.loginHead, width: 2.0),
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(color: Palette.loginHead, width: 2.0),
                        ),
                        labelText: getTranslated(context, changePassword_new_password).toString(),
                        labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return getTranslated(context, changePassword_new_password_validator1).toString();
                        } else if (value.length < 6) {
                          return getTranslated(context, changePassword_new_password_validator2).toString();
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextFormField(
                        controller: confirmPasswordController,
                        obscureText: _isHidden2,
                        style: TextStyle(color: Palette.loginHead),
                        decoration: InputDecoration(
                          suffix: InkWell(
                            onTap: _togglePasswordView2,
                            child: Icon(
                              _isHidden2 ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(color: Palette.loginHead, width: 2.0),
                          ),
                          border: UnderlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(color: Palette.loginHead, width: 2.0),
                          ),
                          labelText: getTranslated(context, changePassword_confirm_password).toString(),
                          labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return getTranslated(context, changePassword_confirm_password_validator1).toString();
                          } else if (passwordController.text != confirmPasswordController.text) {
                            return getTranslated(context, changePassword_confirm_password_validator2).toString();
                          }
                          return null;
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: MaterialButton(
                      onPressed: () {
                        {
                          callApiForgotPassword();
                        }
                      },
                      color: Palette.loginHead,
                      height: 50.0,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Text(
                        getTranslated(context, changePassword_button).toString(),
                        style: TextStyle(color: Palette.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(
                            getTranslated(context, forgotPassword_text1).toString(),
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        Text(
                          getTranslated(context, forgotPassword_text2).toString(),
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _togglePasswordView2() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }

  Future<BaseModel<ForgotPasswordModel>> callApiForgotPassword() async {
    ForgotPasswordModel response;
    Map<String, dynamic> body = {
      "driver_id": widget.id,
      "password": passwordController.text,
      "confirm_password": confirmPasswordController.text,
    };
    try {
      response = await RestClient(RetroApi().dioData()).forgotPasswordRequest(body);
      setState(() {
        Fluttertoast.showToast(msg: '${response.msg}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
