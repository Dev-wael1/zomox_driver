import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/check_otp_model.dart';
import 'package:zomox_driver/model/resend_otp_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';
import 'package:zomox_driver/screens/Authentication/LoginScreen.dart';

import 'ForgotNewPasswordScreen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final int? id;
  final String? where;
  final String? email;

  OtpVerificationScreen({Key? key, this.id, this.where, this.email});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  int? otp = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
        title: Text(
          getTranslated(context, oTPVerification_title).toString(),
          style: TextStyle(
              fontSize: 20,
              color: Palette.loginHead,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace_outlined,
            color: Palette.loginHead,
            size: 35.0,
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ),
      body: GestureDetector(
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
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: SvgPicture.asset('assets/icons/otp.svg'),
                      ),
                    ),
                  ),
                  Center(
                    child: OTPTextField(
                      length: 4,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: 55,
                      fieldStyle: FieldStyle.box,
                      outlineBorderRadius: 15,
                      obscureText: true,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      onChanged: (pin) {
                        print("Changed: " + pin);
                      },
                      onCompleted: (pin) {
                        print("Completed: " + pin);
                        otp = int.parse(pin);
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Resend Code?"),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: MaterialButton(
                      onPressed: () {
                        callApiCheckOtp();
                      },
                      color: Palette.loginHead,
                      height: 50.0,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        getTranslated(context, oTPVerification_button)
                            .toString(),
                        style: TextStyle(color: Palette.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated(
                                        context, oTPVerification_receive_otp)
                                    .toString(),
                                style: TextStyle(
                                    color: Palette.loginHead, fontSize: 14),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    callApiResendOtp();
                                  });
                                },
                                child: Text(
                                  getTranslated(
                                          context, oTPVerification_resend_again)
                                      .toString(),
                                  style: TextStyle(
                                      color: Palette.loginHead,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: Column(
                            children: [
                              Text(
                                getTranslated(context, oTPVerification_text1)
                                    .toString(),
                                style: TextStyle(
                                    color: Palette.loginHead, fontSize: 12),
                              ),
                              Text(
                                getTranslated(context, oTPVerification_text2)
                                    .toString(),
                                style: TextStyle(
                                    color: Palette.loginHead, fontSize: 12),
                              ),
                            ],
                          ),
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

  Future<BaseModel<CheckOtpModel>> callApiCheckOtp() async {
    CheckOtpModel response;
    Map<String, dynamic> body = {
      "driver_id": widget.id,
      "otp": otp,
      "where": widget.where,
    };
    try {
      response = await RestClient(RetroApi().dioData()).checkOtpRequest(body);
      setState(() {
        if (widget.where == "register") {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else if (widget.where == "forgot_password") {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
              builder: (context) => ForgotNewPasswordScreen(
                id: widget.id,
              ),
            ),
          );
        }
        Fluttertoast.showToast(
            msg: '${response.msg}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<ResendOtpModel>> callApiResendOtp() async {
    Map<String, dynamic> body = {
      "email": widget.email,
      "where": "forgot_password",
    };
    ResendOtpModel response;
    try {
      response = await RestClient(RetroApi().dioData()).resendOtpRequest(body);
      setState(() {
        Fluttertoast.showToast(
            msg: 'SuccessFully Otp Send.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
