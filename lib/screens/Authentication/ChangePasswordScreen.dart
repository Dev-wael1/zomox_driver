import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/change_password_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isHidden = true;
  bool _isHidden2 = true;
  bool _isHidden3 = true;

  bool loading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
          getTranslated(context, changePassword_title).toString(),
          style: TextStyle(color: Palette.loginHead, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
            new FocusNode(),
          );
        },
        child: ModalProgressHUD(
          inAsyncCall: loading,
          opacity: 0.5,
          progressIndicator: SpinKitFadingCircle(
            color: Palette.removeAcct,
            size: 50.0,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 35, 20, 0),
                    child: Text(
                      getTranslated(context, changePassword_sub_title).toString(),
                      style: TextStyle(color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextFormField(
                      controller: oldPasswordController,
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
                        labelText: getTranslated(context, changePassword_old_password).toString(),
                        labelStyle: TextStyle(color: Palette.loginHead),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return getTranslated(context, changePassword_old_password_validator).toString();
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextFormField(
                      controller: newPasswordController,
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
                        labelText: getTranslated(context, changePassword_new_password).toString(),
                        labelStyle: TextStyle(color: Palette.loginHead),
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
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _isHidden3,
                      style: TextStyle(color: Palette.loginHead),
                      decoration: InputDecoration(
                        suffix: InkWell(
                          onTap: _togglePasswordView3,
                          child: Icon(
                            _isHidden3 ? Icons.visibility : Icons.visibility_off,
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
                        labelStyle: TextStyle(color: Palette.loginHead),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return getTranslated(context, changePassword_confirm_password_validator1).toString();
                        } else if (newPasswordController.text != confirmPasswordController.text) {
                          return getTranslated(context, changePassword_confirm_password_validator2).toString();
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                    child: MaterialButton(
                      onPressed: () {
                        {
                          if (formKey.currentState!.validate()) {
                            callApiChangePassword();
                          }
                        }
                      },
                      color: Palette.loginHead,
                      height: 50.0,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Text(
                        getTranslated(context, changePassword_button).toString(),
                        style: TextStyle(color: Palette.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

  void _togglePasswordView3() {
    setState(() {
      _isHidden3 = !_isHidden3;
    });
  }

  Future<BaseModel<ChangePasswordModel>> callApiChangePassword() async {
    ChangePasswordModel response;
    Map<String, dynamic> body = {
      "old_password": oldPasswordController.text,
      "password": newPasswordController.text,
      "password_confirmation": confirmPasswordController.text,
    };
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).changePasswordRequest(body);
      setState(() {
        loading = false;
        Fluttertoast.showToast(msg: "${response.data}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
