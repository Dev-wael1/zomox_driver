import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/config/prefConstatnt.dart';
import 'package:zomox_driver/const/preference.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/delivery_zone_model.dart';
import 'package:zomox_driver/model/set_delivery_zone_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';

import '../HomePageScreen.dart';

class DeliveryZoneScreen extends StatefulWidget {
  const DeliveryZoneScreen({Key? key}) : super(key: key);

  @override
  _DeliveryZoneScreenState createState() => _DeliveryZoneScreenState();
}

class _DeliveryZoneScreenState extends State<DeliveryZoneScreen> {
  bool loading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<DeliveryZone> deliveryZoneList = [];
  DeliveryZone? selectedDeliveryZone;

  @override
  void initState() {
    super.initState();
    callApiDeliveryZone();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      opacity: 0.5,
      progressIndicator: SpinKitFadingCircle(
        color: Palette.removeAcct,
        size: 50.0,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.white,
          title: Text(
            getTranslated(context, deliveryZone_deliveryZones).toString(),
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 50, 40, 0),
                      child: DropdownButtonFormField<DeliveryZone>(
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
                          labelText:  getTranslated(context, deliveryZone_hint).toString(),
                          labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                        ),
                        value: selectedDeliveryZone,
                        isExpanded: true,
                        iconSize: 30,
                        onSaved: (dynamic value) {
                          setState(() {
                            selectedDeliveryZone = value;
                          });
                        },
                        onChanged: (DeliveryZone? newValue) {
                          setState(
                            () {
                              selectedDeliveryZone = newValue;
                            },
                          );
                        },
                        validator: (dynamic value) => value == null ? getTranslated(context, deliveryZone_validation).toString() : null,
                        items: deliveryZoneList.map((location) {
                          return DropdownMenuItem<DeliveryZone>(
                            child: new Text(
                              location.name!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF003165),
                              ),
                            ),
                            value: location,
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: MaterialButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            callApiSetDeliveryZone();
                          }
                        },
                        color: Palette.loginHead,
                        height: 50.0,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        child: Text(
                          'Next',
                          style: TextStyle(color: Palette.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<BaseModel<DeliveryZoneModel>> callApiDeliveryZone() async {
    DeliveryZoneModel response;
    try {
      response = await RestClient(RetroApi().dioData()).deliveryZoneRequest();
      setState(() {
        loading = false;
        deliveryZoneList.addAll(response.data!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }


  Future<BaseModel<SetDeliveryZoneModel>> callApiSetDeliveryZone() async {
    SetDeliveryZoneModel response;
    Map<String, dynamic> body = {
      "delivery_zone_id": selectedDeliveryZone!.id,
    };
    try {
      response = await RestClient(RetroApi().dioData()).setDeliveryZoneRequest(body);
      setState(() {
        loading = false;
        SharedPreferenceHelper.setBoolean(Preferences.is_logged_in, true);
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(
              builder: (context) => HomePageScreen(),
            ),
            (route) => false);
        Fluttertoast.showToast(
          msg: '${response.data}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
