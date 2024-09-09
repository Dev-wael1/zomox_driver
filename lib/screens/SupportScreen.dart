import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/driver_support_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  bool loading = false;

  List<Data> driverSupport = [];

  @override
  void initState() {
    super.initState();
    callApiDriverSupport();
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
          getTranslated(context, support_title).toString(),
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
            child: ListView.builder(
              itemCount: driverSupport.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Center(
                          child: Text(
                            '${index + 1}.',
                            style: TextStyle(color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          driverSupport[index].question!,
                          style: TextStyle(color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: Text(
                        driverSupport[index].answer!,
                        style: TextStyle(color: Palette.loginHead, fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<BaseModel<DriverSupportModel>> callApiDriverSupport() async {
    DriverSupportModel response;

    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).driverSupportRequest();
      setState(() {
        loading = false;
        driverSupport.addAll(response.data!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
