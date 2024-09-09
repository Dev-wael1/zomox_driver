import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
// import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/config/prefConstatnt.dart';
import 'package:zomox_driver/const/preference.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/driver_current_order_model.dart';
import 'package:zomox_driver/model/driver_earning_model.dart';
import 'package:zomox_driver/model/driver_order_model.dart';
import 'package:zomox_driver/model/driver_status_change_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';
import 'package:zomox_driver/screens/CancelOrderScreen.dart';
import 'package:zomox_driver/screens/Delivery/PickupOrderScreen.dart';
import 'package:zomox_driver/screens/Profile/ProfileScreen.dart';
import 'package:zomox_driver/widgets/Nodata.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;

  List<DriverOrder> driverOrderList = [];
  List<OrderItems> orderItemList = [];
  List<Custimization> customizationList = [];
  List<PackageOrder> packageOrder = [];

  List<String> itemName = [];
  List<String> itemQty = [];
  List<String> customizationItemName = [];

  double distanceInMeters = 0.0;
  List<double> deliveryKM = [];


  double pDistanceInMeters = 0.0;
  List<double> pDeliveryKM = [];


  double dDistanceInMeters = 0.0;
  List<double> dDeliveryKM = [];

  double liveLat = 0.0;
  double liveLang = 0.0;

  int driverTodayEarning = 0;
  String orderFrom = "";
  String orderStatus = "";
  int id = 0;
  String orderId = "";
  String shopName = "";
  String shopAddress = "";
  String deliverName = "";
  String deliverAddress = "";
  String image = "";
  double distance = 0.0;
  String from = "";
  double shopLat = 0.0;
  double shopLang = 0.0;
  double userLat = 0.0;
  double userLang = 0.0;
  String? mobileNo = "";
  String? codeAndNo = "";

  int? currentId = 0;
  int? currentAmount = 0;
  String? currentOrderId = "";
  String? currentShopName = "";
  String? currentShopAddress = "";
  String? currentDeliverName = "";
  String? currentDeliverAddress = "";
  String? currentImage = "";
  String? currentFrom = "";
  double? currentShopLat = 0.0;
  double? currentShopLang = 0.0;
  double? currentUserLat = 0.0;
  double? currentUserLang = 0.0;
  String? currentPaymentType = "";
  String? currentPaymentStatus = "";
  String? currentOrderStatus = "";
  String? currentCodeAndPhone = "";
  double? currentDistance = 0.0;
  double? currentDistanceMeter = 0.0;

  late Future<BaseModel<DriverOrderModel>> futureCallApiDriverOrder;

  int _selectedPage = 0;
  PageController? _pageController;

  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController!.animateToPage(
        pageNum,
        duration: Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  Timer? timer;

  late LocationData _locationData;
  Location location = new Location();

  BitmapDescriptor? _markerIconSource;
  BitmapDescriptor? _markerIconDestination;
  BitmapDescriptor? _markerIconDriver;

  @override
  void initState() {
    super.initState();
    getLiveLocation();
    callApiDriverCurrentOrderModel();
    futureCallApiDriverOrder = callApiDriverOrder();
    callApiDriverEarning();

    _pageController = PageController();
    _createMarkerImageFromAssetSource(context);
    _createMarkerImageFromAssetDestination(context);
    _createMarkerImageFromAssetDriver(context);
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  getLiveLocation() async {
    _locationData = await location.getLocation();
    liveLat = _locationData.latitude!;
    liveLang = _locationData.longitude!;
  }

  Future<void> _createMarkerImageFromAssetSource(BuildContext context) async {
    if (_markerIconSource == null) {
      BitmapDescriptor bitmapDescriptorSource = await _bitmapDescriptorFromSvgAsset(context, 'assets/icons/source.svg');
      setState(() {
        _markerIconSource = bitmapDescriptorSource;
      });
    }
  }

  Future<void> _createMarkerImageFromAssetDestination(BuildContext context) async {
    if (_markerIconDestination == null) {
      BitmapDescriptor bitmapDescriptorDestination = await _bitmapDescriptorFromSvgAsset(context, 'assets/icons/destination.svg');
      setState(() {
        _markerIconDestination = bitmapDescriptorDestination;
      });
    }
  }

  Future<void> _createMarkerImageFromAssetDriver(BuildContext context) async {
    if (_markerIconDriver == null) {
      BitmapDescriptor bitmapDescriptorDriver = await _bitmapDescriptorFromSvgAsset(context, 'assets/icons/ic_map_pin.svg');
      setState(() {
        _markerIconDriver = bitmapDescriptorDriver;
      });
    }
  }

  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(BuildContext context, String assetName) async {
    String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');

    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width = 32 * devicePixelRatio;
    double height = 32 * devicePixelRatio;

    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));


    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await (image.toByteData(format: ui.ImageByteFormat.png));
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
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
      child: FutureBuilder<BaseModel<DriverOrderModel>>(
        future: futureCallApiDriverOrder,
        builder: (BuildContext context, AsyncSnapshot<BaseModel<DriverOrderModel>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SpinKitFadingCircle(
              color: Palette.removeAcct,
              size: 50.0,
            );
          } else {
            if (snapshot.hasData != true) {
              return NoData();
            }
            else {
              return Scaffold(
                body: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          color: Palette.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TabButton(
                                text: getTranslated(context, homePage_order_tabButton).toString(),
                                pageNumber: 0,
                                selectedPage: _selectedPage,
                                onPressed: () {
                                  _changePage(0);
                                },
                              ),
                              TabButton(
                                text: getTranslated(context, homePage_pickUp_tabButton).toString(),
                                pageNumber: 1,
                                selectedPage: _selectedPage,
                                onPressed: () {
                                  _changePage(1);
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: PageView(
                            onPageChanged: (int page) {
                              setState(() {
                                _selectedPage = page;
                              });
                            },
                            controller: _pageController,
                            children: [
                              if (driverOrderList.length != 0)
                                RefreshIndicator(
                                  onRefresh: () => _onRefresh(0),
                                  color: Palette.removeAcct,
                                  child: Container(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: ListView.builder(
                                      itemCount: driverOrderList.length,
                                      itemBuilder: (context, index) {
                                        distanceInMeters = Geolocator.distanceBetween(
                                          double.parse(driverOrderList[index].shop!.lat!),
                                          double.parse(driverOrderList[index].shop!.lang!),
                                          double.parse(driverOrderList[index].address!.lat!),
                                          double.parse(driverOrderList[index].address!.lang!),
                                        );
                                        deliveryKM.add(distanceInMeters / 1000);
                                        return Container(
                                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          color: Palette.white,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                                                child: Text(
                                                                  getTranslated(context, homePage_oid).toString(),
                                                                  style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                child: Text(
                                                                  driverOrderList[index].orderId!,
                                                                  style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                                                            child: Text(
                                                              "\$ " + driverOrderList[index].amount!.toString(),
                                                              style: TextStyle(
                                                                color: Palette.loginHead,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                        child: Align(
                                                          alignment: Alignment.topLeft,
                                                          child:
                                                          Text(
                                                                () {
                                                              String tempData = "",
                                                                  showData = "",
                                                                  customData = '',
                                                                  actualShowData = "Empty ";
                                                              if (driverOrderList[index].orderItems!.isNotEmpty) {
                                                                for (int i = 0; i < driverOrderList[index].orderItems!.length; i++) {
                                                                  tempData = "";
                                                                  customData = '';
                                                                  if (driverOrderList[index].orderItems![i].custimization!.isNotEmpty) {
                                                                    for (int j = 0;
                                                                    j < driverOrderList[index].orderItems![i].custimization!.length;
                                                                    j++) {
                                                                      customData =
                                                                      driverOrderList[index].orderItems![i].custimization![j].data!.name!;
                                                                      tempData = driverOrderList[index].orderItems![i].itemName!;
                                                                      showData = tempData +
                                                                          "(" +
                                                                          customData +
                                                                          ")" +
                                                                          ' x  ' +
                                                                          driverOrderList[index].orderItems![i].qty!.toString() +
                                                                          ',\n';
                                                                    }
                                                                  }
                                                                  else {
                                                                    tempData = driverOrderList[index].orderItems![i].itemName!;
                                                                    showData = tempData +
                                                                        ' x ' +
                                                                        driverOrderList[index].orderItems![i].qty!.toString() +
                                                                        ',\n';
                                                                  }
                                                                  actualShowData += showData;
                                                                }
                                                                String result = actualShowData.substring(0, actualShowData.length - 2);
                                                                actualShowData = result + '.';
                                                              }
                                                              return actualShowData;
                                                            }(),
                                                            style: TextStyle(fontSize: 14, color: Palette.switchS),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                        child: DottedLine(
                                                          direction: Axis.horizontal,
                                                          lineLength: double.infinity,
                                                          lineThickness: 1.0,
                                                          dashLength: 10.0,
                                                          dashColor: Palette.switchS.withAlpha(80),
                                                          dashRadius: 0.0,
                                                          dashGapLength: 4.0,
                                                          dashGapColor: Palette.white,
                                                          dashGapRadius: 0.0,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                                child: SvgPicture.asset('assets/icons/from.svg'),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                                child: DottedLine(
                                                                  direction: Axis.vertical,
                                                                  lineLength: 80,
                                                                  lineThickness: 1.0,
                                                                  dashLength: 8.0,
                                                                  dashColor: Palette.switchS,
                                                                  dashRadius: 0.0,
                                                                  dashGapLength: 4.0,
                                                                  dashGapColor: Palette.white,
                                                                  dashGapRadius: 0.0,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                child: SvgPicture.asset('assets/icons/to.svg'),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 70,
                                                                      height: 70,
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(20),
                                                                        child: CachedNetworkImage(
                                                                          imageUrl: driverOrderList[index].shop!.fullImage!,
                                                                          height: 70,
                                                                          width: 70,
                                                                          fit: BoxFit.fill,
                                                                          placeholder: (context, url) =>
                                                                              SpinKitFadingCircle(color: Palette.removeAcct),
                                                                          errorWidget: (context, url, error) =>
                                                                              ClipRRect(
                                                                                borderRadius: BorderRadius.circular(20),
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                  child: Image.asset(
                                                                                    "assets/images/no_image.jpg",
                                                                                    fit: BoxFit.fitHeight,
                                                                                    width: 70,
                                                                                    height: 70,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                      child: Container(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: MediaQuery
                                                                                  .of(context)
                                                                                  .size
                                                                                  .width * 0.6,
                                                                              child: Text(
                                                                                driverOrderList[index].shop!.name!,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 2,
                                                                                style: TextStyle(
                                                                                    color: Palette.loginHead,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: MediaQuery
                                                                                  .of(context)
                                                                                  .size
                                                                                  .width * 0.6,
                                                                              child: Text(
                                                                                driverOrderList[index].shop!.location!,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 2,
                                                                                style: TextStyle(
                                                                                  color: Palette.switchS,
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Container(
                                                                  width: MediaQuery
                                                                      .of(context)
                                                                      .size
                                                                      .width * 0.8,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                        child: Container(
                                                                          width: MediaQuery
                                                                              .of(context)
                                                                              .size
                                                                              .width * 0.5,
                                                                          child: Text(
                                                                            driverOrderList[index].user!.name!,
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Palette.loginHead,
                                                                                fontWeight: FontWeight.bold),
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 2,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.location_on,
                                                                              color: Palette.loginHead,
                                                                              size: 20,
                                                                            ),
                                                                            Text(
                                                                              "${deliveryKM[index].toStringAsFixed(1)}" +
                                                                                  getTranslated(context, homePage_km).toString(),
                                                                              style: TextStyle(color: Palette.loginHead, fontSize: 12),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery
                                                                      .of(context)
                                                                      .size
                                                                      .width * 0.8,
                                                                  child: Text(
                                                                    driverOrderList[index].address!.address!,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      color: Palette.switchS,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                                  child: DottedLine(
                                                    direction: Axis.horizontal,
                                                    lineLength: double.infinity,
                                                    lineThickness: 1.0,
                                                    dashLength: 10.0,
                                                    dashColor: Palette.switchS.withAlpha(80),
                                                    dashRadius: 0.0,
                                                    dashGapLength: 4.0,
                                                    dashGapColor: Palette.white,
                                                    dashGapRadius: 0.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  getTranslated(context, homePage_Payment).toString(),
                                                                  style: TextStyle(
                                                                      color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
                                                                ),
                                                                int.parse(driverOrderList[index].paymentStatus!) != 0
                                                                    ? Text(
                                                                  " (" +
                                                                      getTranslated(context, homePage_complete_status).toString() +
                                                                      ")",
                                                                  style: TextStyle(
                                                                      color: Palette.green,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.bold),
                                                                )
                                                                    : Text(
                                                                  " (" +
                                                                      getTranslated(context, homePage_pending_status).toString() +
                                                                      ")",
                                                                  style: TextStyle(
                                                                      color: Palette.red, fontSize: 16, fontWeight: FontWeight.bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                MaterialButton(
                                                                  height: 30,
                                                                  onPressed: () {
                                                                    if (currentId == 0) {
                                                                      showCupertinoModalBottomSheet(
                                                                        expand: false,
                                                                        context: context,
                                                                        backgroundColor: Palette.white,
                                                                        builder: (context) =>
                                                                            CancelOrderScreen(
                                                                              id: driverOrderList[index].id!,
                                                                              from: "order",
                                                                            ),
                                                                      );
                                                                    } else {
                                                                      Fluttertoast.showToast(
                                                                          msg: getTranslated(context, currentOrder_toast).toString(),
                                                                          toastLength: Toast.LENGTH_SHORT,
                                                                          gravity: ToastGravity.BOTTOM);
                                                                    }
                                                                  },
                                                                  color: Palette.removeAcct,
                                                                  textColor: Palette.white,
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    size: 23,
                                                                  ),
                                                                  shape: CircleBorder(),
                                                                ),
                                                                MaterialButton(
                                                                  height: 30,
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      if (currentId == 0) {
                                                                        id = driverOrderList[index].id!;
                                                                        orderFrom = "order";
                                                                        orderStatus = "Accept";

                                                                        orderId = driverOrderList[index].orderId!;
                                                                        shopName = driverOrderList[index].shop!.name!;
                                                                        shopAddress = driverOrderList[index].shop!.location!;
                                                                        deliverName = driverOrderList[index].user!.name!;
                                                                        deliverAddress = driverOrderList[index].address!.address!;
                                                                        image = driverOrderList[index].shop!.fullImage!;
                                                                        distance = deliveryKM[index];
                                                                        shopLat = double.parse(driverOrderList[index].shop!.lat!);
                                                                        shopLang = double.parse(driverOrderList[index].shop!.lang!);
                                                                        userLat = double.parse(driverOrderList[index].address!.lat!);
                                                                        userLang = double.parse(driverOrderList[index].address!.lang!);
                                                                        codeAndNo = driverOrderList[index].user!.phoneCode! +
                                                                            driverOrderList[index].user!.phone!;
                                                                        callApiDriverOrderAccept();
                                                                      } else {
                                                                        Fluttertoast.showToast(
                                                                            msg: getTranslated(context, currentOrder_toast).toString(),
                                                                            toastLength: Toast.LENGTH_SHORT,
                                                                            gravity: ToastGravity.BOTTOM);
                                                                      }
                                                                    });
                                                                  },
                                                                  color: Palette.green,
                                                                  textColor: Palette.white,
                                                                  child: Icon(
                                                                    Icons.check,
                                                                    size: 20,
                                                                  ),
                                                                  shape: CircleBorder(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        driverOrderList[index].paymentType!,
                                                        style: TextStyle(color: Palette.switchS),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              else
                                RefreshIndicator(
                                  onRefresh: () => _onRefresh(0),
                                  color: Palette.removeAcct,
                                  child: NoData(),
                                ),
                              packageOrder.length != 0
                                  ? RefreshIndicator(
                                onRefresh: () => _onRefresh(1),
                                color: Palette.removeAcct,
                                child: Container(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: ListView.builder(
                                    itemCount: packageOrder.length,
                                    itemBuilder: (context, index) {
                                      pDistanceInMeters = Geolocator.distanceBetween(
                                        double.parse(packageOrder[index].pickLat!),
                                        double.parse(packageOrder[index].pickLang!),
                                        liveLat,
                                        liveLang,
                                      );
                                      pDeliveryKM.add(pDistanceInMeters / 1000);
                                      dDistanceInMeters = Geolocator.distanceBetween(
                                        double.parse(packageOrder[index].pickLat!),
                                        double.parse(packageOrder[index].pickLang!),
                                        double.parse(packageOrder[index].dropLat!),
                                        double.parse(packageOrder[index].dropLang!),
                                      );
                                      dDeliveryKM.add(dDistanceInMeters / 1000);

                                      for (int i = 0; i < packageOrder.length; i++) {
                                        mobileNo = packageOrder[i].user!.phone!;
                                      }

                                      return Container(
                                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        color: Palette.white,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                getTranslated(context, homePage_oid).toString(),
                                                                style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                              ),
                                                              Text(
                                                                " " + packageOrder[index].packageId!,
                                                                style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                                                          child: Text(
                                                            "\$ " + packageOrder[index].amount.toString(),
                                                            style: TextStyle(
                                                              color: Palette.loginHead,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                            child: Text(
                                                              packageOrder[index].user!.name!,
                                                              style: TextStyle(
                                                                  color: Palette.loginHead,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                getTranslated(context, homePage_tapToCall).toString(),
                                                                style: TextStyle(color: Palette.green, fontSize: 18),
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  launch("tel:$mobileNo");
                                                                },
                                                                icon: SvgPicture.asset(
                                                                  'assets/icons/call.svg',
                                                                  height: 30,
                                                                  width: 30,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                      child: Container(
                                                        alignment: AlignmentDirectional.bottomStart,
                                                        child: Text(packageOrder[index].category!.name!),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                                      child: DottedLine(
                                                        direction: Axis.horizontal,
                                                        lineLength: double.infinity,
                                                        lineThickness: 1.0,
                                                        dashLength: 10.0,
                                                        dashColor: Palette.switchS.withAlpha(80),
                                                        dashRadius: 0.0,
                                                        dashGapLength: 4.0,
                                                        dashGapColor: Palette.white,
                                                        dashGapRadius: 0.0,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                              child: SvgPicture.asset('assets/icons/from.svg'),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                              child: DottedLine(
                                                                direction: Axis.vertical,
                                                                lineLength: 70,
                                                                lineThickness: 1.0,
                                                                dashLength: 8.0,
                                                                dashColor: Palette.switchS,
                                                                dashRadius: 0.0,
                                                                dashGapLength: 4.0,
                                                                dashGapColor: Palette.white,
                                                                dashGapRadius: 0.0,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                              child: SvgPicture.asset('assets/icons/to.svg'),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width * 0.8,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                    child: Container(
                                                                      width: MediaQuery
                                                                          .of(context)
                                                                          .size
                                                                          .width * 0.5,
                                                                      child: Text(
                                                                        "Pickup Address",
                                                                        style: TextStyle(
                                                                            fontSize: 16,
                                                                            color: Palette.loginHead,
                                                                            fontWeight: FontWeight.bold),
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.location_on,
                                                                          color: Palette.loginHead,
                                                                          size: 20,
                                                                        ),
                                                                        Text(
                                                                          "${pDeliveryKM[index].toStringAsFixed(1)}" +
                                                                              getTranslated(context, homePage_km).toString(),
                                                                          style: TextStyle(color: Palette.loginHead, fontSize: 12),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width * 0.8,
                                                              child: Text(
                                                                packageOrder[index].pickupLocation!,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Palette.switchS,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width * 0.8,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                    child: Container(
                                                                      width: MediaQuery
                                                                          .of(context)
                                                                          .size
                                                                          .width * 0.5,
                                                                      child: Text(
                                                                        "Delivery Address",
                                                                        style: TextStyle(
                                                                            fontSize: 16,
                                                                            color: Palette.loginHead,
                                                                            fontWeight: FontWeight.bold),
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.location_on,
                                                                          color: Palette.loginHead,
                                                                          size: 20,
                                                                        ),
                                                                        Text(
                                                                          "${dDeliveryKM[index].toStringAsFixed(1)}" +
                                                                              getTranslated(context, homePage_km).toString(),
                                                                          style: TextStyle(color: Palette.loginHead, fontSize: 12),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width * 0.8,
                                                              child: Text(
                                                                packageOrder[index].dropupLocation!,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Palette.switchS,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                                child: DottedLine(
                                                  direction: Axis.horizontal,
                                                  lineLength: double.infinity,
                                                  lineThickness: 1.0,
                                                  dashLength: 10.0,
                                                  dashColor: Palette.switchS.withAlpha(80),
                                                  dashRadius: 0.0,
                                                  dashGapLength: 4.0,
                                                  dashGapColor: Palette.white,
                                                  dashGapRadius: 0.0,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                getTranslated(context, homePage_Payment).toString(),
                                                                style: TextStyle(
                                                                    color: Palette.loginHead,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                              int.parse(packageOrder[index].paymentStatus!) != 0
                                                                  ? Text(
                                                                " (" +
                                                                    getTranslated(context, homePage_complete_status)
                                                                        .toString() +
                                                                    ")",
                                                                style: TextStyle(
                                                                    color: Palette.green,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold),
                                                              )
                                                                  : Text(
                                                                " (" +
                                                                    getTranslated(context, homePage_pending_status).toString() +
                                                                    ")",
                                                                style: TextStyle(
                                                                    color: Palette.red,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              MaterialButton(
                                                                height: 30,
                                                                onPressed: () {
                                                                  if (currentId == 0) {
                                                                    showCupertinoModalBottomSheet(
                                                                      expand: false,
                                                                      context: context,
                                                                      backgroundColor: Palette.white,
                                                                      builder: (context) =>
                                                                          CancelOrderScreen(
                                                                            id: packageOrder[index].id!,
                                                                            from: "package",
                                                                          ),
                                                                    );
                                                                  } else {
                                                                    Fluttertoast.showToast(
                                                                        msg: getTranslated(context, currentOrder_toast).toString(),
                                                                        toastLength: Toast.LENGTH_SHORT,
                                                                        gravity: ToastGravity.BOTTOM);
                                                                  }
                                                                },
                                                                color: Palette.removeAcct,
                                                                textColor: Palette.white,
                                                                child: Icon(
                                                                  Icons.close,
                                                                  size: 20,
                                                                ),
                                                                shape: CircleBorder(),
                                                              ),
                                                              MaterialButton(
                                                                height: 30,
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (currentId == 0) {
                                                                      id = packageOrder[index].id!;
                                                                      orderFrom = "package";
                                                                      orderStatus = "Accept";

                                                                      orderId = packageOrder[index].packageId!;
                                                                      shopName = "Pickup Address";
                                                                      shopAddress = packageOrder[index].pickupLocation!;
                                                                      deliverName =
                                                                      packageOrder[index].user!.name!;
                                                                      deliverAddress = packageOrder[index].dropupLocation!;
                                                                      image = packageOrder[index].category!.fullImage!;
                                                                      distance = dDeliveryKM[index];
                                                                      shopLat = double.parse(packageOrder[index].pickLat!);
                                                                      shopLang = double.parse(packageOrder[index].pickLang!);
                                                                      userLat = double.parse(packageOrder[index].dropLat!);
                                                                      userLang = double.parse(packageOrder[index].dropLang!);
                                                                      codeAndNo = packageOrder[index].user!.phoneCode! +
                                                                          packageOrder[index].user!.phone!;
                                                                      callApiDriverOrderAccept();
                                                                    } else {
                                                                      Fluttertoast.showToast(
                                                                          msg: getTranslated(context, currentOrder_toast).toString(),
                                                                          toastLength: Toast.LENGTH_SHORT,
                                                                          gravity: ToastGravity.BOTTOM);
                                                                    }
                                                                  });
                                                                },
                                                                color: Palette.green,
                                                                textColor: Palette.white,
                                                                child: Icon(
                                                                  Icons.check,
                                                                  size: 20,
                                                                ),
                                                                shape: CircleBorder(),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      packageOrder[index].paymentType!,
                                                      style: TextStyle(color: Palette.switchS),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                                  : RefreshIndicator(
                                onRefresh: () => _onRefresh(1),
                                color: Palette.removeAcct,
                                child: NoData(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  height: currentId != null && currentId != 0 || SharedPreferenceHelper.getString(Preferences.owner_id) == 0.toString()
                      ? currentId != null && currentId != 0 && SharedPreferenceHelper.getString(Preferences.owner_id) == 0.toString()
                      ? 180
                      : 90
                      : 0,
                  child: Column(
                    children: [
                      Visibility(
                        visible: currentId != null && currentId != 0,
                        child: Container(
                          height: 90,
                          color: Color(0xFF203049).withOpacity(0.5),
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.65,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      getTranslated(context, homePage_oid).toString(),
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    Text("$currentOrderId"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    getTranslated(context, Name).toString() + ": ",
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.45,
                                                    child: Text(
                                                      "$currentDeliverName",
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    getTranslated(context, homePage_Payment).toString(),
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.4,
                                                    child: Row(
                                                      children: [
                                                        Text("\$" + "$currentAmount"),
                                                        Text(
                                                          " (" "$currentPaymentType" ")",
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 25,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            id = currentId!;
                                            orderFrom = currentFrom!;
                                            orderStatus = currentOrderStatus!;
                                            orderId = currentOrderId!;
                                            shopName = currentShopName!;
                                            shopAddress = currentShopAddress!;
                                            deliverName = currentDeliverName!;
                                            deliverAddress = currentDeliverAddress!;
                                            image = currentImage!;
                                            distance = currentDistance!;
                                            shopLat = currentShopLat!;
                                            shopLang = currentShopLang!;
                                            userLat = currentUserLat!;
                                            userLang = currentUserLang!;
                                            codeAndNo = currentCodeAndPhone;
                                            callApiDriverOrderAccept();
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: SharedPreferenceHelper.getString(Preferences.owner_id) == 0.toString(),
                        child: Container(
                          decoration: BoxDecoration(color: Palette.loginHead),
                          height: 90,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Text(
                                  getTranslated(context, homePage_today_earning).toString(),
                                  style: TextStyle(color: Palette.switchS, fontSize: 15),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "\$ " + "$driverTodayEarning",
                                        style: TextStyle(
                                          color: Palette.removeAcct,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileScreen(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                      child: Row(
                                        children: [
                                          Text(
                                            getTranslated(context, homePage_go_insight).toString(),
                                            style: TextStyle(color: Palette.white),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Palette.white,
                                            size: 30.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _onRefresh(int selectedPage) async {
    setState(() {
      _changePage(selectedPage);
      _pageController = PageController(initialPage: selectedPage);
      callApiDriverOrder();
    });
  }

  Future<BaseModel<DriverOrderModel>> callApiDriverOrder() async {
    DriverOrderModel response;
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).driverOrderRequest();
      setState(() {
        loading = false;
        driverOrderList.clear();
        packageOrder.clear();
        driverOrderList.addAll(response.data!);
        packageOrder.addAll(response.packageOrder!);
      });
    } catch (error, stacktrace) {
      setState(() {
        loading = false;
      });
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()
        ..setException(
          ServerError.withError(error: error),
        );
    }
    return BaseModel()
      ..data = response;
  }

  Future<BaseModel<DriverCurrentOrderModel>> callApiDriverCurrentOrderModel() async {
    DriverCurrentOrderModel response;
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).driverCurrentOrderRequest();
      setState(
            () {
          loading = false;
          if (response.data!.order!.id != null) {
            currentId = response.data!.order!.id;
            currentOrderId = response.data!.order!.orderId;
            currentAmount = response.data!.order!.amount;
            currentDeliverName = response.data!.order!.user!.name;
            currentPaymentType = response.data!.order!.paymentType;
            currentPaymentStatus = response.data!.order!.paymentStatus;
            currentShopName = response.data!.order!.shop!.name;
            currentShopAddress = response.data!.order!.shop!.location;
            currentDeliverAddress = response.data!.order!.address!.address;
            currentImage = response.data!.order!.user!.fullImage;
            currentFrom = "order";
            currentShopLat = double.parse(response.data!.order!.shop!.lat!);
            currentShopLang = double.parse(response.data!.order!.shop!.lang!);
            currentUserLat = double.parse(response.data!.order!.address!.lat!);
            currentUserLang = double.parse(response.data!.order!.address!.lang!);
            currentOrderStatus = response.data!.order!.orderStatus;
            currentCodeAndPhone = response.data!.order!.user!.phoneCode! + response.data!.order!.user!.phone!;
            currentDistanceMeter = Geolocator.distanceBetween(
              currentShopLat!,
              currentShopLang!,
              currentUserLat!,
              currentUserLang!,
            );
            currentDistance = (currentDistanceMeter! / 1000);
          } else if (response.data!.packageOrder!.id != null) {
            currentId = response.data!.packageOrder!.id;
            currentOrderId = response.data!.packageOrder!.packageId;
            currentAmount = response.data!.packageOrder!.amount;
            currentDeliverName = response.data!.packageOrder!.user!.name;
            currentPaymentType = response.data!.packageOrder!.paymentType;
            currentPaymentStatus = response.data!.packageOrder!.paymentStatus;
            currentShopName = "Pickup Address";
            currentShopAddress = response.data!.packageOrder!.pickupLocation;
            currentDeliverAddress = response.data!.packageOrder!.dropupLocation;
            currentImage = response.data!.packageOrder!.user!.fullImage;
            currentFrom = "package";
            currentShopLat = double.parse(response.data!.packageOrder!.pickLat!);
            currentShopLang = double.parse(response.data!.packageOrder!.pickLang!);
            currentUserLat = double.parse(response.data!.packageOrder!.dropLat!);
            currentUserLang = double.parse(response.data!.packageOrder!.dropLang!);
            currentOrderStatus = response.data!.packageOrder!.orderStatus;
            currentCodeAndPhone = response.data!.order!.user!.phoneCode! + response.data!.order!.user!.phone!;
            currentDistanceMeter = Geolocator.distanceBetween(
              currentShopLat!,
              currentShopLang!,
              currentUserLat!,
              currentUserLang!,
            );
            currentDistance = (currentDistanceMeter! / 1000);
          }
          print("Current $currentId $currentOrderId $currentPaymentType $currentDeliverName $currentAmount");
        },
      );
    } catch (error, stacktrace) {
      setState(() {
        loading = false;
      });
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()
        ..setException(
          ServerError.withError(error: error),
        );
    }
    return BaseModel()
      ..data = response;
  }

  Future<BaseModel<DriverEarningModel>> callApiDriverEarning() async {
    DriverEarningModel response;
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).driverEarningRequest();
      setState(() {
        loading = false;
        driverTodayEarning = response.data!.todayEarning!;
      });
    } catch (error, stacktrace) {
      setState(() {
        loading = false;
      });
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()
        ..setException(
          ServerError.withError(error: error),
        );
    }
    return BaseModel()
      ..data = response;
  }

  Future<BaseModel<DriverStatusChangeModel>> callApiDriverOrderAccept() async {
    DriverStatusChangeModel response;
    Map<String, dynamic> body = {
      "order_id": id,
      "order_status": orderStatus,
      "from": orderFrom,
    };
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).driverStatusChangeRequest(body);
      setState(() {
        loading = false;
        print("Detail $id , $orderId, $shopName, $shopAddress, $deliverName, $deliverAddress, $distance, $orderFrom ");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PickupOrderScreen(
                  id: id,
                  orderId: orderId,
                  shopName: shopName,
                  shopAddress: shopAddress,
                  deliverName: deliverName,
                  deliverAddress: deliverAddress,
                  image: image,
                  distance: distance,
                  from: orderFrom,
                  markerSourceIcon: _markerIconSource,
                  markerDestinationIcon: _markerIconDestination,
                  markerDriverIcon: _markerIconDriver,
                  liveLat: liveLat,
                  liveLang: liveLang,
                  sourceLat: shopLat,
                  sourceLang: shopLang,
                  destinationLat: userLat,
                  destinationLang: userLang,
                  codeAndPhone: codeAndNo,
                  orderStatus: orderStatus,
                ),
          ),
        );
      });
    } catch (error, stacktrace) {
      setState(() {
        loading = false;
      });
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()
        ..setException(
          ServerError.withError(error: error),
        );
    }
    return BaseModel()
      ..data = response;
  }
}

class TabButton extends StatelessWidget {
  final String? text;
  final int? selectedPage;
  final int? pageNumber;
  final Function? onPressed;

  TabButton({this.text, this.selectedPage, this.pageNumber, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed as void Function()?,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.fastLinearToSlowEaseIn,
            decoration: BoxDecoration(
              border: selectedPage == pageNumber
                  ? Border(
                bottom: BorderSide(width: 3, color: Palette.switchS),
              )
                  : Border(),
            ),
            padding: EdgeInsets.symmetric(
              vertical: selectedPage == pageNumber ? 12.0 : 0,
              horizontal: selectedPage == pageNumber ? 20.0 : 0,
            ),
            margin: EdgeInsets.symmetric(
              vertical: selectedPage == pageNumber ? 0 : 12.0,
              horizontal: selectedPage == pageNumber ? 0 : 20.0,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                text ?? "Tab Button",
                style: TextStyle(color: Palette.loginHead, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
