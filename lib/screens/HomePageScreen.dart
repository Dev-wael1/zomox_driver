import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/config/prefConstatnt.dart';
import 'package:zomox_driver/const/preference.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/delivery_zone_model.dart';
import 'package:zomox_driver/model/login_driver_detail_model.dart';
import 'package:zomox_driver/model/set_delivery_zone_model.dart';
import 'package:zomox_driver/model/setting_model.dart';
import 'package:zomox_driver/model/update_driver_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';
import 'package:zomox_driver/screens/AboutScreen.dart';
import 'package:zomox_driver/screens/ChangeLanguageScreen.dart';
import 'package:zomox_driver/screens/Delivery/HistoryScreen.dart';
import 'package:zomox_driver/screens/Profile/ManageDocumentScreen.dart';
import 'package:zomox_driver/screens/NotificationCenterScreen.dart';
import 'package:zomox_driver/screens/PrivacyPolicyScreen.dart';
import 'package:zomox_driver/screens/Profile/ProfileEditScreen.dart';
import 'package:zomox_driver/screens/Profile/ProfileScreen.dart';
import 'package:zomox_driver/screens/SupportScreen.dart';
import 'package:zomox_driver/screens/TermsAndConditionScreen.dart';
import 'package:zomox_driver/widgets/BeforeOnline.dart';
import 'package:zomox_driver/widgets/HomePage.dart';
import 'package:zomox_driver/widgets/NetworkOff.dart';
import 'Authentication/ChangePasswordScreen.dart';
import 'Authentication/LoginScreen.dart';
import 'package:flutter/services.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool loading = false;
  bool checkInternetStatus = false;
  List<DeliveryZone> deliveryZoneList = [];
  DeliveryZone? selectedDeliveryZone;

  List<String> selectBusiness = [];
  int? deliveryZoneId;
  int? value;

  bool isSwitched = SharedPreferenceHelper.getString(Preferences.driverStatus) != 0.toString() ? true : false;
  String driverStatus = "";

  void toggleSwitch(bool value) {
    if (_connectionStatus == ConnectivityResult.wifi ||
        _connectionStatus == ConnectivityResult.ethernet ||
        _connectionStatus == ConnectivityResult.mobile) {
      if (isSwitched == false) {
        setState(() {
          isSwitched = true;
          driverStatus = "1";
          callApiUpdateDriver();
        });
      } else {
        setState(() {
          isSwitched = false;
          driverStatus = "0";
          callApiUpdateDriver();
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: getTranslated(context, home_internet_connection_toast).toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      initConnectivity();
      callApiLoginDriverDetail();
      callApiDeliveryZone();
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    });
  }

  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: getTranslated(context, home_exit_App_toast).toString(),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Palette.white),
    );
    return WillPopScope(
      onWillPop: onWillPop,
      child: _connectionStatus == ConnectivityResult.wifi ||
              _connectionStatus == ConnectivityResult.ethernet ||
              _connectionStatus == ConnectivityResult.mobile
          ? Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: Palette.white,
                elevation: 0,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SharedPreferenceHelper.getString(Preferences.driverName),
                      style: TextStyle(fontSize: 18, color: Palette.loginHead, fontWeight: FontWeight.bold),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => showCupertinoModalBottomSheet(
                          expand: false,
                          context: context,
                          backgroundColor: Palette.white,
                          builder: (context) => deliveryZone(),
                        ),
                        child: Container(
                          child: Row(
                            children: [
                              Text(
                                SharedPreferenceHelper.getString(Preferences.deliveryZoneName),
                                style: TextStyle(fontSize: 14, color: Palette.switchS),
                              ),
                              Icon(Icons.arrow_drop_down, size: 20, color: Palette.switchS),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                leading: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 1.5, 10, 0),
                          child: const Divider(
                            height: 30,
                            thickness: 3,
                            indent: 2,
                            endIndent: 6,
                            color: Palette.loginHead,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: const Divider(
                            height: 30,
                            thickness: 3,
                            indent: 2,
                            endIndent: 5,
                            color: Palette.loginHead,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (_scaffoldKey.currentState!.isDrawerOpen) {
                      _scaffoldKey.currentState!.openEndDrawer();
                    } else {
                      _scaffoldKey.currentState!.openDrawer();
                    }
                  },
                ),
                actions: <Widget>[
                  Container(
                    color: Palette.white,
                    child: Switch(
                      onChanged: toggleSwitch,
                      value: isSwitched,
                      activeColor: Palette.white,
                      activeTrackColor: Palette.loginHead,
                      inactiveThumbColor: Palette.white,
                      inactiveTrackColor: Palette.switchS,
                    ),
                  )
                ],
              ),
              body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: SharedPreferenceHelper.getString(Preferences.driverStatus) != 0.toString() ? HomePage() : BeforeOnline()),
              drawer: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Palette.white,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          child: Container(
                            color: Palette.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Palette.loginHead,
                                    child: CircleAvatar(
                                      radius: 37,
                                      child: CachedNetworkImage(
                                        imageUrl: SharedPreferenceHelper.getString(Preferences.driverImage),
                                        imageBuilder: (context, imageProvider) => CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Palette.loginHead,
                                          child: CircleAvatar(
                                            radius: 37,
                                            backgroundImage: imageProvider,
                                          ),
                                        ),
                                        placeholder: (context, url) => SpinKitFadingCircle(color: Palette.removeAcct),
                                        errorWidget: (context, url, error) => ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 50, bottom: 50),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          SharedPreferenceHelper.getString(Preferences.driverName),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(color: Palette.loginHead, fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          SharedPreferenceHelper.getString(Preferences.driverEmail),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(color: Palette.loginHead, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Palette.loginHead,
                                      size: 35.0,
                                    ),
                                    onPressed: () {
                                      SharedPreferenceHelper.getString(Preferences.owner_id) == 0.toString()
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ProfileScreen(),
                                              ),
                                            )
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ProfileEditScreen(),
                                              ),
                                            );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.history,
                              color: Palette.loginHead,
                            ),
                            title: Text(
                              getTranslated(context, home_history).toString(),
                              style: TextStyle(color: Palette.loginHead, fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.file_copy,
                              color: Palette.loginHead,
                            ),
                            title: Text(
                              getTranslated(context, home_manage_documents).toString(),
                              style: TextStyle(color: Palette.loginHead, fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ManageDocumentScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.translate,
                              color: Palette.loginHead,
                              size: 25,
                            ),
                            title: Text(
                              getTranslated(context, home_change_language).toString(),
                              style: TextStyle(color: Palette.loginHead, fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeLanguageScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.lock_outline_rounded,
                              color: Palette.loginHead,
                              size: 25,
                            ),
                            title: Text(
                              getTranslated(context, home_change_password).toString(),
                              style: TextStyle(color: Palette.loginHead, fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePasswordScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.notifications_none,
                              color: Palette.loginHead,
                            ),
                            title: Text(
                              getTranslated(context, home_notification_center).toString(),
                              style: TextStyle(color: Palette.loginHead, fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationCenterScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.support_agent,
                              color: Palette.loginHead,
                            ),
                            title: Text(
                              getTranslated(context, home_support).toString(),
                              style: TextStyle(color: Palette.loginHead, fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SupportScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.info_outline,
                              color: Palette.loginHead,
                            ),
                            title: Text(
                              getTranslated(context, home_about).toString(),
                              style: TextStyle(color: Palette.loginHead, fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.insert_drive_file_sharp,
                              color: Palette.loginHead,
                            ),
                            title: Text(
                              getTranslated(context, home_privacy_policy).toString(),
                              style: TextStyle(color: Palette.loginHead, fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrivacyPolicyScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.privacy_tip_outlined,
                              color: Palette.loginHead,
                            ),
                            title: Text(
                              getTranslated(context, home_terms_and_conditions).toString(),
                              style: TextStyle(color: Palette.loginHead, fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TermsAndConditionScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: Palette.loginHead,
                          height: 2,
                          thickness: 1,
                          indent: 15,
                          endIndent: 20,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.logout,
                              color: Palette.loginHead,
                            ),
                            title: Text(
                              getTranslated(context, home_log_out).toString(),
                              style: TextStyle(color: Palette.loginHead, fontSize: 16),
                            ),
                            onTap: () {
                              setState(() {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        getTranslated(context, home_log_out).toString(),
                                        style: TextStyle(color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                              getTranslated(context, home_log_out_title).toString(),
                                              style: TextStyle(color: Palette.switchS, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              child: Text(
                                                getTranslated(context, No).toString(),
                                                style: TextStyle(color: Palette.loginHead, fontSize: 14),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                getTranslated(context, Yes).toString(),
                                                style: TextStyle(color: Palette.loginHead, fontSize: 14),
                                              ),
                                              onPressed: () {
                                                logoutUser();
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Scaffold(
              body: NetworkOff(),
            ),
    );
  }

  Widget deliveryZone() {
    return Material(
      child: StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
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
                            getTranslated(context, home_delivery_zone).toString(),
                            style: TextStyle(color: Palette.loginHead, fontSize: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
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
                      Container(
                        height: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: deliveryZoneList.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              value: index,
                              groupValue: value,
                              onChanged: (int? reason) {
                                setState(
                                  () {
                                    value = reason!.toInt();
                                    deliveryZoneId = deliveryZoneList[index].id;
                                  },
                                );
                              },
                              title: Text(
                                deliveryZoneList[index].name!,
                                style: TextStyle(color: Palette.bonjour, fontSize: 16.0),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: MaterialButton(
                          onPressed: () {
                            callApiSetDeliveryZone();
                          },
                          color: Palette.loginHead,
                          height: 50.0,
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            getTranslated(context, home_button_set_delivery_zone).toString(),
                            style: TextStyle(color: Palette.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future logoutUser() async {
    setState(() {
      SharedPreferenceHelper.remove(Preferences.auth_token);
      SharedPreferenceHelper.remove(Preferences.auto_Refresh);
      SharedPreferenceHelper.remove(Preferences.current_language_code);
      SharedPreferenceHelper.remove(Preferences.deliveryZoneId);
      SharedPreferenceHelper.remove(Preferences.deliveryZoneName);
      SharedPreferenceHelper.remove(Preferences.device_token);
      SharedPreferenceHelper.remove(Preferences.driverEmail);
      SharedPreferenceHelper.remove(Preferences.driverImage);
      SharedPreferenceHelper.remove(Preferences.driverName);
      SharedPreferenceHelper.remove(Preferences.driverPhoneCode);
      SharedPreferenceHelper.remove(Preferences.driverPhoneNo);
      SharedPreferenceHelper.remove(Preferences.driverStatus);
      SharedPreferenceHelper.remove(Preferences.drivingLicenseImage);
      SharedPreferenceHelper.remove(Preferences.is_logged_in);
      SharedPreferenceHelper.remove(Preferences.owner_id);
      SharedPreferenceHelper.remove(Preferences.notification);
      SharedPreferenceHelper.remove(Preferences.Map_Key);
      SharedPreferenceHelper.remove(Preferences.NationalIdImage);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
        ModalRoute.withName('SplashScreen'),
      );
    });
  }

  Future<void> checkForPermission() async {

    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();

  }

  Future<BaseModel<UpdateDriverModel>> callApiUpdateDriver() async {
    UpdateDriverModel response;
    Map<String, dynamic> body = {
      "is_online": driverStatus,
      "name": SharedPreferenceHelper.getString(Preferences.driverName),
      "phone": SharedPreferenceHelper.getString(Preferences.driverPhoneNo),
      "phone_code": SharedPreferenceHelper.getString(Preferences.driverPhoneCode),
    };
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).updateDriverRequest(body);
      setState(() {
        loading = false;
        SharedPreferenceHelper.setString(Preferences.driverStatus, driverStatus);
        Fluttertoast.showToast(msg: '${response.data}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
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
        SharedPreferenceHelper.setString(Preferences.deliveryZoneId, response.data!.deliveryZoneId!.toString());
        SharedPreferenceHelper.setString(Preferences.deliveryZoneName, response.data!.deliveryzone!);
        SharedPreferenceHelper.setString(Preferences.driverImage, response.data!.fullImage!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<DeliveryZoneModel>> callApiDeliveryZone() async {
    DeliveryZoneModel response;
    setState(() {
      loading = true;
    });
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
      "delivery_zone_id": deliveryZoneId,
    };
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).setDeliveryZoneRequest(body);
      setState(() {
        loading = false;
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(
              builder: (context) => HomePageScreen(),
            ),
            (route) => false);
        HomePageScreen();
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

  Future<BaseModel<SettingModel>> callApiSetting() async {
    SettingModel response;
    try {
      response = await RestClient(RetroApi().dioData()).settingRequest();
      setState(() {
        SharedPreferenceHelper.setString(Preferences.auto_Refresh, response.data!.autoRefresh!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
