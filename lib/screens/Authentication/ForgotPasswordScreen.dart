import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/resend_otp_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';

import 'OtpVerificationScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int? id = 0;

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
        title: Text(
          getTranslated(context, forgot_password).toString(),
          style: TextStyle(fontSize: 20, color: Palette.loginHead, fontWeight: FontWeight.bold),
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
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: SvgPicture.asset('assets/icons/email.svg'),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                    child: TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Palette.loginHead),
                      decoration: InputDecoration(
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
                        labelText: getTranslated(context, register_label_emailAddress).toString(),
                        labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return getTranslated(context, register_emailAddress_validator_1).toString();
                        }
                        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                          return getTranslated(context, register_emailAddress_validator_2).toString();
                        }
                        return null;
                      },
                    ),
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
                        getTranslated(context, forgotPassword_verityAccount).toString(),
                        style: TextStyle(color: Palette.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Text(
                            getTranslated(context, forgotPassword_text1).toString(),
                          ),
                        ),
                        Text(
                          getTranslated(context, forgotPassword_text2).toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<BaseModel<ResendOtpModel>> callApiForgotPassword() async {
    Map<String, dynamic> body = {
      "email": emailController.text,
      "where": "forgot_password",
    };
    ResendOtpModel response;
    try {
      response = await RestClient(RetroApi().dioData()).resendOtpRequest(body);
      setState(() {
        id = response.data!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              id: id,
              where: "forgot_password",
              email: emailController.text,
            ),
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
