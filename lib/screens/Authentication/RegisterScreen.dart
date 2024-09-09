import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/delivery_zone_model.dart';
import 'package:zomox_driver/model/register_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';

import 'LoginScreen.dart';
import 'OtpVerificationScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isHidden = true;
  bool _isHidden2 = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController phoneCodeController = TextEditingController();
  TextEditingController deliveryZoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode contactFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  String _selectedCountryCode = '+91';
  int id = 0;

  List<DeliveryZone> deliveryZone = [];
  String? selectDeliveryZone;

  @override
  Widget build(BuildContext context) {
    var countryDropDown = Container(
      width: 30,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                exclude: <String>['KN', 'MF'],
                showPhoneCode: true,
                onSelect: (Country country) {
                  _selectedCountryCode = "+" + country.phoneCode;
                },
                countryListTheme: CountryListThemeData(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  inputDecoration: InputDecoration(
                    labelText: getTranslated(context, register_label_searchCode).toString(),
                    hintText: getTranslated(context, register_label_hintTextCode).toString(),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF8C98A8).withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Text(
              _selectedCountryCode,
              style: TextStyle(fontFamily: 'Proxima Nova Reg', fontSize: 16),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: 25,
            decoration: new BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
        title: Text(
          getTranslated(context, create_new_account).toString(),
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
          FocusScope.of(context).requestFocus(
            new FocusNode(),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                      child: TextFormField(
                        style: TextStyle(color: Palette.loginHead),
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))],
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
                          labelText: getTranslated(context, register_label_fullName).toString(),
                          labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                        ),
                        validator: (String? value) {
                          value!.trim();
                          if (value.isEmpty) {
                            return getTranslated(context, register_fullName_validator_1).toString();
                          } else if (value.trim().length < 1) {
                            return getTranslated(context, register_fullName_validator_2).toString();
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
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
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]')), LengthLimitingTextInputFormatter(10)],
                        style: TextStyle(color: Palette.loginHead),
                        decoration: InputDecoration(
                          prefixIcon: countryDropDown,
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
                          labelText: getTranslated(context, register_label_contact).toString(),
                          labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return getTranslated(context, register_contact_validator_1).toString();
                          }
                          if (value.length != 10) {
                            return getTranslated(context, register_contact_validator_2).toString();
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9@#.]'))],
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
                          labelText: getTranslated(context, register_label_password).toString(),
                          labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                        ),
                        validator: (String? value) {
                          value!.trim();
                          if (value.isEmpty) {
                            return getTranslated(context, register_password_validator_1).toString();
                          } else if (value.trim().length < 6) {
                            return getTranslated(context, register_password_validator_2).toString();
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z0-9@#.]'),
                          )
                        ],
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
                          labelText: getTranslated(context, register_label_confirmPassword).toString(),
                          labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                        ),
                        validator: (String? value) {
                          value!.trim();
                          if (value.isEmpty) {
                            return getTranslated(context, register_confirmPassword_validator_1).toString();
                          } else if (passwordController.text != confirmPasswordController.text) {
                            return getTranslated(context, register_confirmPassword_validator_2).toString();
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          getTranslated(context, register_text).toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: MaterialButton(
                        onPressed: () {
                          {
                            if (formKey.currentState!.validate()) {
                              callApiRegister();
                            } else {
                              print("ERROR");
                            }
                          }
                        },
                        color: Palette.loginHead,
                        height: 50.0,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          getTranslated(context, register_button).toString(),
                          style: TextStyle(color: Palette.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated(context, register_an_account).toString(),
                            style: TextStyle(color: Palette.loginHead, fontSize: 14.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              " " + getTranslated(context, register_login).toString(),
                              style: TextStyle(color: Palette.loginHead, fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

  Future<BaseModel<RegisterModel>> callApiRegister() async {
    Map<String, dynamic> body = {
      "name": nameController.text,
      "email": emailController.text,
      "phone_code": _selectedCountryCode,
      "phone": phoneController.text,
      "password": passwordController.text,
    };
    RegisterModel response;
    try {
      response = await RestClient(RetroApi().dioData()).registerRequest(body);
      setState(() {
        id = response.data!.id!;
        Fluttertoast.showToast(
          msg: '${response.msg}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        response.data!.isVerified != 1
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpVerificationScreen(
                    id: id,
                    where: "register",
                    email: response.data!.email!,
                  ),
                ),
              )
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
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
