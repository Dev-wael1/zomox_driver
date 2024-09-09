import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/login_driver_detail_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';

class ManageDocumentScreen extends StatefulWidget {
  @override
  _ManageDocumentScreenState createState() => _ManageDocumentScreenState();
}

class _ManageDocumentScreenState extends State<ManageDocumentScreen> {
  bool loading = false;

  String driverLicenseImg = "";
  String driverNationIdImg = "";
  String driverLicenseImgName = "";
  String driverNationIdImgName = "";

  @override
  void initState() {
    super.initState();
    callApiLoginDriverDetail();
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
          getTranslated(context, manageDocument_title).toString(),
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
          child: Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: '$driverLicenseImg',
                              height: 80,
                              width: 80,
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  SpinKitFadingCircle(color: Palette.removeAcct),
                              errorWidget: (context, url, error) => ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    "assets/images/no_image.jpg",
                                    fit: BoxFit.fitHeight,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Text(
                                "$driverLicenseImgName",
                                style: TextStyle(color: Palette.loginHead, fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.insert_drive_file_outlined,
                                    color: Palette.switchS,
                                    size: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      Fluttertoast.showToast(
                                        msg: getTranslated(context, manageDocument_start_toast).toString(),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                      final Directory? appDirectory =
                                          await getExternalStorageDirectory();
                                      String str = appDirectory!.path;
                                      List<String> parts = str.split("/");
                                      String startPart = parts[0].trim() +
                                          "/" +
                                          parts[1].trim() +
                                          "/" +
                                          parts[2].trim() +
                                          "/" +
                                          parts[3].trim();
                                      final String outputDirectory = '$startPart/Download/Zomox';
                                      await Directory(outputDirectory).create(recursive: true);
                                      downloadFile('$driverLicenseImg', '$driverLicenseImgName',
                                              "$outputDirectory")
                                          .whenComplete(
                                        () => Fluttertoast.showToast(
                                          msg: getTranslated(context, manageDocument_end_toast).toString(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      getTranslated(context, manageDocument_download_document).toString(),
                                      style: TextStyle(color: Palette.switchS, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: "$driverNationIdImg",
                              height: 80,
                              width: 80,
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  SpinKitFadingCircle(color: Palette.removeAcct),
                              errorWidget: (context, url, error) => ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    "assets/images/no_image.jpg",
                                    fit: BoxFit.fitHeight,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Text(
                                "$driverNationIdImgName",
                                style: TextStyle(color: Palette.loginHead, fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.insert_drive_file_outlined,
                                    color: Palette.switchS,
                                    size: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      Fluttertoast.showToast(
                                        msg: getTranslated(context, manageDocument_start_toast).toString(),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                      final Directory? appDirectory =
                                          await getExternalStorageDirectory();
                                      String str = appDirectory!.path;
                                      List<String> parts = str.split("/");
                                      String startPart = parts[0].trim() +
                                          "/" +
                                          parts[1].trim() +
                                          "/" +
                                          parts[2].trim() +
                                          "/" +
                                          parts[3].trim();
                                      final String outputDirectory = '$startPart/Download/Zomox';
                                      await Directory(outputDirectory).create(recursive: true);
                                      downloadFile('$driverNationIdImg', '$driverNationIdImgName',
                                              "$outputDirectory")
                                          .whenComplete(
                                        () => Fluttertoast.showToast(
                                          msg: getTranslated(context, manageDocument_end_toast).toString(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      getTranslated(context, manageDocument_download_document).toString(),
                                      style: TextStyle(color: Palette.switchS, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      getTranslated(context, manageDocument_text).toString(),
                      style: TextStyle(color: Palette.switchS, fontSize: 11),
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

  Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';
    try {
      myUrl = url;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }
    return filePath;
  }

  Future<BaseModel<LoginDriverDetailModel>> callApiLoginDriverDetail() async {
    LoginDriverDetailModel response;
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).loginDriverDetailRequest();
      setState(() {
        loading = false;
        driverLicenseImg = response.data!.licenseImg!;
        driverNationIdImg = response.data!.nationId!;

        String str;
        List<String> parts;
        str = driverLicenseImg;
        parts = str.split("/");
        driverLicenseImgName = parts.last.trim();

        String str1;
        List<String> parts1;
        str1 = driverNationIdImg;
        parts1 = str1.split("/");
        driverNationIdImgName = parts1.last.trim();

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
