import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/driver_status_change_model.dart';
import 'package:zomox_driver/model/setting_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';

class CancelOrderScreen extends StatefulWidget {
  final int? id;
  final String? from;

  CancelOrderScreen({
    this.id,
    this.from,
  });

  @override
  _CancelOrderScreenState createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  List<String> selectBusiness = [];
  int? value;

  bool loading = false;

  List<dynamic> convertCancelReason = [];
  List<String> cancelReason = [];
  String? reason = "";

  @override
  void initState() {
    super.initState();
    callApiSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        getTranslated(context, cancel_cancelOrder).toString(),
                        style: TextStyle(color: Palette.loginHead, fontSize: 16.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: DottedLine(
                      direction: Axis.horizontal,
                      lineLength: double.infinity,
                      lineThickness: 1.0,
                      dashLength: 10.0,
                      dashColor: Palette.switchS,
                      dashRadius: 0.0,
                      dashGapLength: 0,
                      dashGapColor: Palette.white,
                      dashGapRadius: 0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        getTranslated(context, cancelOrder_text).toString(),
                        style: TextStyle(color: Palette.loginHead, fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ModalProgressHUD(
                    inAsyncCall: loading,
                    opacity: 0.5,
                    progressIndicator: SpinKitFadingCircle(
                      color: Palette.removeAcct,
                      size: 50.0,
                    ),
                    child: Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: cancelReason.length,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            value: index,
                            groupValue: value,
                            onChanged: (int? reason) {
                              setState(() {
                                value = reason!.toInt();
                              });
                            },
                            title: Text(
                              cancelReason[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          reason = cancelReason[value!];
                          callApiDriverOrderAccept();
                        });
                      },
                      color: Palette.loginHead,
                      height: 50.0,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        getTranslated(context, cancelOrder_button).toString(),
                        style: TextStyle(color: Palette.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        convertCancelReason = json.decode(response.data!.cancelReason!);
        cancelReason.clear();
        for (int i = 0; i < convertCancelReason.length; i++) {
          cancelReason.add(convertCancelReason[i]);
        }
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<DriverStatusChangeModel>> callApiDriverOrderAccept() async {
    DriverStatusChangeModel response;
    Map<String, dynamic> body = {
      "order_id": widget.id,
      "order_status": "Reject",
      "from": widget.from,
      "cancel_reason": reason,
    };
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).driverStatusChangeRequest(body);
      setState(() {
        loading = false;
        Fluttertoast.showToast(msg: 'Reject Order', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        Navigator.pushReplacementNamed(context, "/");
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()
        ..setException(
          ServerError.withError(error: error),
        );
    }
    return BaseModel()..data = response;
  }
}
