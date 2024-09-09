import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/config/prefConstatnt.dart';
import 'package:zomox_driver/const/preference.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/login_driver_detail_model.dart';
import 'package:zomox_driver/model/update_driver_model.dart';
import 'package:zomox_driver/model/update_image_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';
import 'package:zomox_driver/screens/Profile/ProfileScreen.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  String _selectedCountryCode = "";
  String? driverImage = "";
  bool loading = false;

  File? selectDriverImage;
  final picker = ImagePicker();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    callApiLoginDriverDetail();
  }


  @override
  Widget build(BuildContext context) {
    var countryDropDown = Container(
      width: 30,
      child: Row(
        children: [
          Text(
            _selectedCountryCode,
            style: TextStyle(fontFamily: 'Proxima Nova Reg', fontSize: 16),
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
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace_outlined,
            color: Palette.loginHead,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ProfileScreen(),),);
          },
        ),
        title: Text(
          getTranslated(context, profileEdit_title).toString(),
          style: TextStyle(
              color: Palette.loginHead,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: Text(
                            getTranslated(context, profileEdit_sub_title).toString(),
                            style: TextStyle(
                                color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                new BoxShadow(
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: <Widget>[
                                selectDriverImage != null
                                    ? CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Palette.loginHead,
                                  child: CircleAvatar(
                                    radius: 47,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                        selectDriverImage!,
                                        fit: BoxFit.fitHeight,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                )
                                    : CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Palette.loginHead,
                                  child: CircleAvatar(
                                    radius: 47,
                                    child: CachedNetworkImage(
                                      imageUrl: driverImage!,
                                      fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) => CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Palette.loginHead,
                                        child: CircleAvatar(
                                          radius: 47,
                                          backgroundImage: imageProvider,
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                      SpinKitFadingCircle(color: Palette.removeAcct),
                                      errorWidget: (context, url, error) => ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.asset(
                                          "assets/images/no_image.jpg",
                                          fit: BoxFit.fitHeight,
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 65,
                                  left: 65,
                                  child: GestureDetector(
                                    onTap: () {
                                      chooseProfileImage();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Palette.loginHead,
                                      radius: 16,
                                      child: CircleAvatar(
                                        backgroundColor: Palette.cheBox,
                                        radius: 13,
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 20,
                                          color: Palette.loginHead,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                          child: TextFormField(
                            controller: nameController,
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
                              labelText: getTranslated(context, profileEdit_full_name).toString(),
                              labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                            ),
                            validator: (String? value) {
                              value!.trim();
                              if (value.isEmpty) {
                                return getTranslated(context, profileEdit_fullName_validator1).toString();
                              } else if (value.trim().length < 1) {
                                return getTranslated(context, profileEdit_fullName_validator2).toString();
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextFormField(
                            controller: phoneNoController,
                            keyboardType: TextInputType.phone,
                            readOnly: true,
                            onTap: (){
                              Fluttertoast.showToast(
                                  msg: "Phone no. Not Change", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                              LengthLimitingTextInputFormatter(10)
                            ],
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
                              labelText: getTranslated(context, profileEdit_contact).toString(),
                              labelStyle: TextStyle(color: Palette.loginHead, fontSize: 14),
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return getTranslated(context, profileEdit_contact_validator1).toString();
                              }
                              if (value.length != 10) {
                                return getTranslated(context, profileEdit_contact_validator2).toString();
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
                                  callApiUpdateDriverDetail();
                                }
                              }
                            },
                            color: Palette.loginHead,
                            height: 50.0,
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            child: Text(
                              getTranslated(context, profileEdit_button).toString(),
                              style: TextStyle(
                                  color: Palette.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void chooseProfileImage() {
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
                      getTranslated(context, profileEdit_from_gallery).toString(),
                    ),
                    onTap: () {
                      imageFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    getTranslated(context, profileEdit_from_camera).toString(),
                  ),
                  onTap: () {
                    imageFromCamera();
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

  void imageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.driverImage, pickedFile.path);
        selectDriverImage = File(SharedPreferenceHelper.getString(Preferences.driverImage));
        List<int> imageBytes = selectDriverImage!.readAsBytesSync();
        driverImage = base64Encode(imageBytes);
        callApiUpdateImage();
      } else {
        print('No image selected.');
      }
    });
  }

  void imageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.driverImage, pickedFile.path);
        selectDriverImage = File(SharedPreferenceHelper.getString(Preferences.driverImage));
        List<int> imageBytes = selectDriverImage!.readAsBytesSync();
        driverImage = base64Encode(imageBytes);
        callApiUpdateImage();
      } else {
        print('No image selected.');
      }
    });
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
        nameController.text = response.data!.name!;
        phoneNoController.text = response.data!.phone!;
        _selectedCountryCode = response.data!.phoneCode!;
        driverImage = response.data!.fullImage!;
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<UpdateImageModel>> callApiUpdateImage() async {
    UpdateImageModel response;
    Map<String, dynamic> body = {
      "image": driverImage,
    };
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).updateImageRequest(body);
      setState(() {
        loading = false;
        Fluttertoast.showToast(
            msg: "${response.data}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }


  Future<BaseModel<UpdateDriverModel>> callApiUpdateDriverDetail() async {
    UpdateDriverModel response;
    Map<String, dynamic> body = {
      "is_online": SharedPreferenceHelper.getString(Preferences.driverStatus),
      "name": nameController.text,
      "phone": phoneNoController.text,
      "phone_code": _selectedCountryCode,
    };
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).updateDriverRequest(body);
      setState(() {
        loading = false;
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
        Fluttertoast.showToast(
            msg: "${response.data}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
