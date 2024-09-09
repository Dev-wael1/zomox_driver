import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/config/prefConstatnt.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/driver_status_change_model.dart';
import 'package:zomox_driver/model/update_lat_lang_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';
import '../HomePageScreen.dart';
import 'DeliveredSuccessfullyScreen.dart';

class PickupOrderScreen extends StatefulWidget {
  final int? id;
  final String? orderId;
  final String? shopName;
  final String? shopAddress;
  final String? deliverName;
  final String? deliverAddress;
  final String? image;
  final double? distance;
  final String? from;
  final double? liveLat;
  final double? liveLang;
  final double? sourceLat;
  final double? sourceLang;
  final double? destinationLat;
  final double? destinationLang;
  final String? codeAndPhone;
  final String? orderStatus;
  final markerSourceIcon;
  final markerDestinationIcon;
  final markerDriverIcon;

  PickupOrderScreen({
    this.id,
    this.orderId,
    this.shopName,
    this.shopAddress,
    this.deliverName,
    this.deliverAddress,
    this.image,
    this.distance,
    this.from,
    this.markerSourceIcon,
    this.markerDestinationIcon,
    this.liveLat,
    this.liveLang,
    this.markerDriverIcon,
    this.sourceLat,
    this.sourceLang,
    this.destinationLat,
    this.destinationLang,
    this.codeAndPhone,
    this.orderStatus,
  });

  @override
  _PickupOrderScreenState createState() => _PickupOrderScreenState();
}

class _PickupOrderScreenState extends State<PickupOrderScreen> {
  GoogleMapController? mapController;

  bool mapSize = false;
  bool _visible = true;
  bool loading = false;

  bool buttonVisibility = true;
  bool deliveryWidgetVisibility = true;
  bool deliveryButtonVisibility = true;

  late LocationData _locationData;
  Location location = new Location();

  String orderStatus = "";

  double currentLat = 0.0;
  double currentLong = 0.0;

  double liveLat = 0.0;
  double liveLang = 0.0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    orderStatus = widget.orderStatus! != "" ? widget.orderStatus! : "";
    print("OrderStatus $orderStatus");
    widget.orderStatus == "Reached" || widget.orderStatus == "Complete"
        ? deliveryWidgetVisibility = false
        : deliveryWidgetVisibility = true;

    _addMarker(
      LatLng(widget.sourceLat!, widget.sourceLang!),
      "source",
      widget.markerSourceIcon,
      InfoWindow(
        title: "Shop Name",
        snippet: widget.shopName,
      ),
    );

    _addMarker(
      LatLng(widget.destinationLat!, widget.destinationLang!),
      "destination",
      widget.markerDestinationIcon,
      InfoWindow(
        title: "User Name",
        snippet: widget.deliverName,
      ),
    );
    _addMarker(
      LatLng(widget.liveLat!, widget.liveLang!),
      "driver",
      widget.markerDriverIcon,
      InfoWindow(
        title: "Driver",
        snippet: "Rajkot",
      ),
    );
    _getPolyline();
    timer = Timer.periodic(
        Duration(
          seconds: int.parse(Preferences.auto_Refresh),
        ),
        (Timer t) => getLiveLocation());

    callApiDriverOrderAccept();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = Preferences.Map_Key;

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor, InfoWindow infoWindow) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position, infoWindow: infoWindow);
    markers[markerId] = marker;
  }

  getLiveLocation() async {
    _locationData = await location.getLocation();
    liveLat = _locationData.latitude!;
    liveLang = _locationData.longitude!;
    setMarker(liveLat, liveLang);
    callApiDriverLatLang();
  }

  Future<bool> onWillPop() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePageScreen(),
      ),
    );
    return Future.value(true);
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
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace_outlined,
              color: Palette.loginHead,
              size: 35.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePageScreen(),
                ),
              );
            },
          ),
          title: Text(
            getTranslated(context, pickupOrder_title).toString(),
            style: TextStyle(color: Palette.loginHead, fontWeight: FontWeight.bold),
          ),
        ),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Column(
              children: [
                Expanded(
                  flex: _visible == true ? 12 : 1,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          zoomControlsEnabled: false,
                          onMapCreated: _onMapCreated,
                          markers: Set<Marker>.of(markers.values),
                          polylines: Set<Polyline>.of(polyLines.values),
                          initialCameraPosition: CameraPosition(
                            target: LatLng(widget.liveLat!, widget.liveLang!),
                            zoom: 15.0,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        right: 10,
                        child: Container(
                          height: 60,
                          width: 60,
                          margin: EdgeInsets.only(top: 5),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _visible = !_visible;
                                mapSize = !mapSize;
                              });
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/zoom.svg',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: _visible == true
                      ? deliveryWidgetVisibility == true
                          ? 5
                          : 8
                      : 0,
                  child: Stack(
                    children: [
                      Container(
                        child: deliveryWidgetVisibility == true
                            ? Visibility(
                                visible: _visible,
                                child: ListView(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'OID:',
                                                  style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  widget.orderId!,
                                                  style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset('assets/icons/from.svg'),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    child: Container(
                                                      width: 70,
                                                      height: 70,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: CachedNetworkImage(
                                                          imageUrl: widget.image!,
                                                          height: 70,
                                                          width: 70,
                                                          fit: BoxFit.fill,
                                                          placeholder: (context, url) => SpinKitFadingCircle(color: Palette.removeAcct),
                                                          errorWidget: (context, url, error) => ClipRRect(
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
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.6,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(context).size.width * 0.38,
                                                              child: Text(
                                                                widget.shopName!,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.location_on,
                                                                  color: Palette.loginHead,
                                                                  size: 20,
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(context).size.width * 0.15,
                                                                  child: Text(
                                                                    widget.distance!.toStringAsFixed(1) +
                                                                        " " +
                                                                        getTranslated(context, pickupOrder_km).toString(),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(color: Palette.loginHead, fontSize: 12),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          widget.shopAddress!,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(fontSize: 13, color: Palette.switchS),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  orderStatus = buttonVisibility == true ? "Driver PickedUp Item" : "On The Way";
                                                  callApiDriverOrderAccept();
                                                });
                                              },
                                              child: Container(
                                                height: 50,
                                                width: MediaQuery.of(context).size.width * 0.8,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  gradient: LinearGradient(
                                                    colors: [Palette.pickupSt, Palette.pickupEn],
                                                  ),
                                                ),
                                                child: Center(
                                                  child: buttonVisibility == true
                                                      ? Text(
                                                          getTranslated(context, pickupOrder_button).toString(),
                                                          style: TextStyle(color: Palette.white, fontWeight: FontWeight.bold, fontSize: 16),
                                                        )
                                                      : Text(
                                                          getTranslated(context, pickupOrder_onTheWay_button).toString(),
                                                          style: TextStyle(color: Palette.white, fontWeight: FontWeight.bold, fontSize: 16),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Visibility(
                                visible: _visible,
                                child: ListView(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'OID:',
                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      widget.orderId!,
                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      getTranslated(context, homePage_tapToCall).toString(),
                                                      style: TextStyle(color: Palette.green, fontSize: 18),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        launch("tel:${widget.codeAndPhone}");
                                                      },
                                                      icon: SvgPicture.asset(
                                                        'assets/icons/call.svg',
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    child: SvgPicture.asset('assets/icons/from.svg'),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                    child: DottedLine(
                                                      direction: Axis.vertical,
                                                      lineLength: 80,
                                                      lineThickness: 1.0,
                                                      dashLength: 8.0,
                                                      dashColor: Palette.removeAcct,
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
                                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                                              imageUrl: widget.image!,
                                                              height: 70,
                                                              width: 70,
                                                              fit: BoxFit.fill,
                                                              placeholder: (context, url) => SpinKitFadingCircle(color: Palette.removeAcct),
                                                              errorWidget: (context, url, error) => ClipRRect(
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
                                                            width: MediaQuery.of(context).size.width * 0.55,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  widget.shopName!,
                                                                  style: TextStyle(
                                                                      color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
                                                                ),
                                                                Text(
                                                                  widget.shopAddress!,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                    color: Palette.switchS,
                                                                    fontSize: 14,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.6,
                                                            child: Padding(
                                                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                              child: Text(
                                                                widget.deliverName!,
                                                                style: TextStyle(
                                                                    fontSize: 16, color: Palette.loginHead, fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.2,
                                                            child: Padding(
                                                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.location_on,
                                                                    color: Palette.loginHead,
                                                                    size: 20,
                                                                  ),
                                                                  Text(
                                                                    widget.distance!.toStringAsFixed(1) +
                                                                        " " +
                                                                        getTranslated(context, deliveryOrder_km).toString(),
                                                                    style: TextStyle(color: Palette.loginHead, fontSize: 12),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                      child: Text(
                                                        widget.deliverAddress!,
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
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  orderStatus = deliveryButtonVisibility == true ? "Reached" : "Complete";
                                                  callApiDriverOrderAccept();
                                                });
                                              },
                                              child: Container(
                                                height: 50,
                                                width: MediaQuery.of(context).size.width * 0.8,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  gradient: LinearGradient(
                                                    colors: [Palette.deliverSt, Palette.deliverEn],
                                                  ),
                                                ),
                                                child: Center(
                                                  child: deliveryButtonVisibility == true
                                                      ? Text(
                                                          getTranslated(context, deliveryOrder_Reached_button).toString(),
                                                          style: TextStyle(color: Palette.white, fontWeight: FontWeight.bold, fontSize: 16),
                                                        )
                                                      : Text(
                                                          getTranslated(context, deliveryOrder_button).toString(),
                                                          style: TextStyle(color: Palette.white, fontWeight: FontWeight.bold, fontSize: 16),
                                                        ),
                                                ),
                                              ),
                                            ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<BaseModel<DriverStatusChangeModel>> callApiDriverOrderAccept() async {
    DriverStatusChangeModel response;
    Map<String, dynamic> body = {
      "order_id": widget.id,
      "order_status": orderStatus,
      "from": widget.from,
    };
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).driverStatusChangeRequest(body);
      setState(() {
        loading = false;
        if (orderStatus == "Driver PickedUp Item") {
          buttonVisibility = false;
          _getPolyline();
        } else if (orderStatus == "On The Way") {
          deliveryWidgetVisibility = false;
        } else if (orderStatus == "Reached") {
          deliveryButtonVisibility = false;
        } else if (orderStatus == "Complete") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveredSuccessfullyScreen(),
            ),
          );
        }
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

  Future<BaseModel<UpdateLatLangModel>> callApiDriverLatLang() async {
    UpdateLatLangModel response;
    Map<String, dynamic> body = {
      "lat": liveLat,
      "lang": liveLang,
    };
    try {
      response = await RestClient(RetroApi().dioData()).driverUpdateLatLangRequest(body);
      setState(() {});
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()
        ..setException(
          ServerError.withError(error: error),
        );
    }
    return BaseModel()..data = response;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Colors.black, points: polylineCoordinates, width: 2);
    polyLines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    if (orderStatus == "" || orderStatus == "Accept") {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(widget.liveLat!, widget.liveLang!),
        PointLatLng(widget.sourceLat!, widget.sourceLang!),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
      _addPolyLine(polylineCoordinates);
    } else {
      polylineCoordinates.clear();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(widget.sourceLat!, widget.sourceLang!),
        PointLatLng(widget.destinationLat!, widget.destinationLang!),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
      _addPolyLine(polylineCoordinates);
    }
  }

  setMarker(double lat, double lang) async {
    final marker = markers.values.toList().firstWhere((item) => item.markerId == MarkerId('driver'));

    Marker _marker = Marker(
      markerId: marker.markerId,
      position: LatLng(lat, lang),
      icon: widget.markerDriverIcon,
    );

    setState(() {
      markers[MarkerId('driver')] = _marker;
    });
  }
}
