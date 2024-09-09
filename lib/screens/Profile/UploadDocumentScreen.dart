import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/config/prefConstatnt.dart';
import 'package:zomox_driver/const/preference.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/setting_model.dart';
import 'package:zomox_driver/model/upload_document_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';

import 'DeliveryZoneScreen.dart';

class UploadDocumentScreen extends StatefulWidget {
  @override
  _UploadDocumentScreenState createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {

  bool loading = false;
  int? value;
  String idType = "";
  List<String> idTypeList = [];
  String selectedIdType = "";

  String? drivingLicenseImg = "";
  String? nationalIdImg = "";
  File? drivingLicenseFile;
  File? nationalIdFile;
  final picker = ImagePicker();

  var licenseFileName = "";
  var nationalIdFileName = "";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final drivingLicenseNameController = TextEditingController();
  final nationalIdNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    callApiSetting();
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
            getTranslated(context, uploadDocuments_title).toString(),
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
                          controller: drivingLicenseNameController,
                          readOnly: true,
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
                            labelText: getTranslated(context, uploadDocuments_label_drivingLicense).toString(),
                            labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                            suffixIcon: IconButton(
                              onPressed: () {
                                chooseDrivingLicenseImg();
                              },
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: Palette.loginHead,
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return getTranslated(context, uploadDocuments_drivingLicense_validator).toString();
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: TextFormField(
                          controller: nationalIdNameController,
                          readOnly: true,
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
                            labelText: getTranslated(context, uploadDocuments_label_NationalId).toString(),
                            labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                            suffixIcon: IconButton(
                              onPressed: () {
                                chooseNationalIdImg();
                              },
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: Palette.loginHead,
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return getTranslated(context, uploadDocuments_NationalId_validator).toString();
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            getTranslated(context, uploadDocuments_label_selectType).toString(),
                            style: TextStyle(color: Palette.loginHead, fontSize: 12),
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: idTypeList.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              value: index,
                              groupValue: value,
                              onChanged: (int? reason) {
                                setState(() {
                                  value = reason!.toInt();
                                  selectedIdType = idTypeList[index];
                                });
                              },
                              title: Text(
                                idTypeList[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.16,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text(
                          getTranslated(context, uploadDocuments_text).toString(),
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: MaterialButton(
                            onPressed: () {
                              if (formKey.currentState!.validate() && selectedIdType != "") {
                                callApiDocumentUpload();
                              } else if (selectedIdType == "") {
                                Fluttertoast.showToast(
                                    msg: getTranslated(context, uploadDocuments_NationalId_toast).toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM);
                              } else {
                                print("ERROR");
                              }

                            },
                            color: Palette.loginHead,
                            height: 50.0,
                            minWidth: double.infinity,
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            child: Text(
                              getTranslated(context, uploadDocuments_button).toString(),
                              style: TextStyle(color: Palette.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void chooseDrivingLicenseImg() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text(
                    getTranslated(context, uploadDocuments_from_gallery).toString(),
                  ),
                  onTap: () {
                    drivingLicenseFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    getTranslated(context, uploadDocuments_from_camera).toString(),
                  ),
                  onTap: () {
                    drivingLicenseFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future drivingLicenseFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.drivingLicenseImage, pickedFile.path);
        drivingLicenseFile =
            File(SharedPreferenceHelper.getString(Preferences.drivingLicenseImage));
        List<int> imageBytes = drivingLicenseFile!.readAsBytesSync();
        drivingLicenseImg = base64Encode(imageBytes);
        String str;
        List<String> parts;
        str = pickedFile.path;
        parts = str.split("/");
        licenseFileName = parts.last.trim();
        drivingLicenseNameController.text = licenseFileName.toString();
      } else {
        print('No image selected.');
      }
    });
  }

  Future drivingLicenseFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.drivingLicenseImage, pickedFile.path);
        drivingLicenseFile =
            File(SharedPreferenceHelper.getString(Preferences.drivingLicenseImage));
        List<int> imageBytes = drivingLicenseFile!.readAsBytesSync();
        drivingLicenseImg = base64Encode(imageBytes);
        String str;
        List<String> parts;
        str = pickedFile.path;
        parts = str.split("/");
        licenseFileName = parts.last.trim();
        drivingLicenseNameController.text = licenseFileName.toString();
      } else {
        print('No image selected.');
      }
    });
  }

  void chooseNationalIdImg() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text(
                    getTranslated(context, uploadDocuments_from_gallery).toString(),
                  ),
                  onTap: () {
                    nationalIdFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    getTranslated(context, uploadDocuments_from_camera).toString(),
                  ),
                  onTap: () {
                    nationalIdFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future nationalIdFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.NationalIdImage, pickedFile.path);
        nationalIdFile = File(SharedPreferenceHelper.getString(Preferences.NationalIdImage));
        List<int> imageBytes = nationalIdFile!.readAsBytesSync();
        nationalIdImg = base64Encode(imageBytes);
        String str;
        List<String> parts;
        str = pickedFile.path;
        parts = str.split("/");
        nationalIdFileName = parts.last.trim();
        nationalIdNameController.text = nationalIdFileName.toString();
      } else {
        print('No image selected.');
      }
    });
  }

  Future nationalIdFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.NationalIdImage, pickedFile.path);
        nationalIdFile = File(SharedPreferenceHelper.getString(Preferences.NationalIdImage));
        List<int> imageBytes = nationalIdFile!.readAsBytesSync();
        nationalIdImg = base64Encode(imageBytes);
        String str;
        List<String> parts;
        str = pickedFile.path;
        parts = str.split("/");
        nationalIdFileName = parts.last.trim();
        nationalIdNameController.text = nationalIdFileName.toString();
      } else {
        print('No image selected.');
      }
    });
  }


  Future<BaseModel<SettingModel>> callApiSetting() async {
    SettingModel response;
    try {
      response = await RestClient(RetroApi().dioData()).settingRequest();
      setState(() {
        idType = response.data!.documents!;
        String str;
        List<String> parts;
        str = idType;
        parts = str.split(",");
        idTypeList.clear();
        for (int i = 0; i < parts.length; i++) {
          idTypeList.add(parts[i]);
        }
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }


  Future<BaseModel<UploadDocumentModel>> callApiDocumentUpload() async {
    UploadDocumentModel response;
    Map<String, dynamic> body = {
      "driving_license": drivingLicenseImg,
      "document_img": nationalIdImg,
      "document_type": selectedIdType,
    };
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).uploadDocumentRequest(body);
      if (response.success == true) {
        setState(() {
          loading = false;
          Fluttertoast.showToast(
              msg: "${response.data}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
        });
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (context) => DeliveryZoneScreen(),
          ),
        );
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
