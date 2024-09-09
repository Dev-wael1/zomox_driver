import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/driver_order_history_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';
import 'package:zomox_driver/widgets/HistoryNodata.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool loading = false;
  int _selectedPage = 0;
  PageController? _pageController;

  List<Complete> completeOrder = [];
  List<Cancel> cancelOrder = [];
  List<PackageOrderHistory> packageOrder = [];

  double completeDistanceInMeters = 0.0;
  List<double> completeDeliveryKM = [];

  double cancelDistanceInMeters = 0.0;
  List<double> cancelDeliveryKM = [];

  double packageDTPDistanceInMeters = 0.0;
  List<double> packageDTPDeliveryKM = [];

  double packagePTDDistanceInMeters = 0.0;
  List<double> packagePTDDeliveryKM = [];

  double liveLat = 0.0;
  double liveLang = 0.0;

  late LocationData _locationData;
  Location location = new Location();

  TextEditingController _searchResultCompleteController = TextEditingController();
  TextEditingController _searchResultCancelController = TextEditingController();
  TextEditingController _searchResultPackageController = TextEditingController();
  List<Complete> _searchResultComplete = [];
  List<Cancel> _searchResultCancel = [];
  List<PackageOrderHistory> _searchResultPackage = [];

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

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
    callApiDriverOrderHistory();
    getLiveLocation();
  }

  getLiveLocation() async {
    _locationData = await location.getLocation();
    liveLat = _locationData.latitude!;
    liveLang = _locationData.longitude!;
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
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
              size: 30.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            getTranslated(context, home_history).toString(),
            style: TextStyle(color: Palette.loginHead, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(
              new FocusNode(),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: Palette.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TabButton(
                      text: getTranslated(context, history_completeOrder).toString(),
                      pageNumber: 0,
                      selectedPage: _selectedPage,
                      onPressed: () {
                        _changePage(0);
                      },
                    ),
                    TabButton(
                      text: getTranslated(context, history_cancelOrder).toString(),
                      pageNumber: 1,
                      selectedPage: _selectedPage,
                      onPressed: () {
                        _changePage(1);
                      },
                    ),
                    TabButton(
                      text: getTranslated(context, history_packageOrder).toString(),
                      pageNumber: 2,
                      selectedPage: _selectedPage,
                      onPressed: () {
                        _changePage(2);
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
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  textCapitalization: TextCapitalization.words,
                                  style: TextStyle(
                                    color: Palette.loginHead,
                                    fontSize: 18,
                                  ),
                                  controller: _searchResultCompleteController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Palette.white,
                                    filled: true,
                                    hintText: getTranslated(context, history_searchHint).toString(),
                                    hintStyle: TextStyle(color: Palette.bonjour),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Palette.bonjour,
                                      size: 20,
                                    ),
                                  ),
                                  onChanged: onSearchTextChangedComplete,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () => _onRefresh(0),
                              color: Palette.removeAcct,
                              child: _searchResultComplete.length > 0 || _searchResultCompleteController.text.isNotEmpty
                                  ? _searchResultComplete.length != 0
                                      ? ListView.builder(
                                          itemCount: _searchResultComplete.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            completeDistanceInMeters = Geolocator.distanceBetween(
                                              double.parse(_searchResultComplete[index].shop!.lat!),
                                              double.parse(_searchResultComplete[index].shop!.lang!),
                                              double.parse(_searchResultComplete[index].address!.lat!),
                                              double.parse(_searchResultComplete[index].address!.lang!),
                                            );
                                            completeDeliveryKM.add(completeDistanceInMeters / 1000);
                                            return Container(
                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                              color: Palette.white,
                                              width: MediaQuery.of(context).size.width,
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
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getTranslated(context, history_oId).toString(),
                                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                    ),
                                                                    Text(
                                                                      " " + _searchResultComplete[index].orderId!,
                                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Text(
                                                                  "\$ " + _searchResultComplete[index].amount!.toString(),
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
                                                              alignment: AlignmentDirectional.topStart,
                                                              child: Text(
                                                                () {
                                                                  String completeTempData = "",
                                                                      completeShowData = "",
                                                                      completeCustomData = '',
                                                                      completeActualShowData = "";
                                                                  if (_searchResultComplete[index].orderItems!.isNotEmpty) {
                                                                    for (int i = 0;
                                                                        i < _searchResultComplete[index].orderItems!.length;
                                                                        i++) {
                                                                      completeTempData = "";
                                                                      completeCustomData = '';
                                                                      if (_searchResultComplete[index]
                                                                          .orderItems![i]
                                                                          .custimization!
                                                                          .isNotEmpty) {
                                                                        for (int j = 0;
                                                                            j <
                                                                                _searchResultComplete[index]
                                                                                    .orderItems![i]
                                                                                    .custimization!
                                                                                    .length;
                                                                            j++) {
                                                                          completeCustomData = _searchResultComplete[index]
                                                                              .orderItems![i]
                                                                              .custimization![j]
                                                                              .data!
                                                                              .name!;
                                                                          completeTempData =
                                                                              _searchResultComplete[index].orderItems![i].itemName!;
                                                                          completeShowData = completeTempData +
                                                                              "(" +
                                                                              completeCustomData +
                                                                              ")" +
                                                                              ' x  ' +
                                                                              _searchResultComplete[index].orderItems![i].qty!.toString() +
                                                                              ',\n';
                                                                        }
                                                                      } else {
                                                                        completeTempData =
                                                                            _searchResultComplete[index].orderItems![i].itemName!;
                                                                        completeShowData = completeTempData +
                                                                            ' x ' +
                                                                            _searchResultComplete[index].orderItems![i].qty!.toString() +
                                                                            ',\n';
                                                                      }
                                                                      completeActualShowData += completeShowData;
                                                                    }
                                                                    String result = completeActualShowData.substring(
                                                                        0, completeActualShowData.length - 2);
                                                                    completeActualShowData = result + '.';
                                                                  }

                                                                  return completeActualShowData;
                                                                }(),
                                                                style: TextStyle(fontSize: 14, color: Palette.switchS),
                                                              ),
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
                                                                              imageUrl: _searchResultComplete[index].shop!.fullImage!,
                                                                              height: 70,
                                                                              width: 70,
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
                                                                                  width: MediaQuery.of(context).size.width * 0.55,
                                                                                  child: Text(
                                                                                    _searchResultComplete[index].shop!.name!,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxLines: 2,
                                                                                    style: TextStyle(
                                                                                        color: Palette.loginHead,
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width * 0.55,
                                                                                  child: Text(
                                                                                    _searchResultComplete[index].shop!.location!,
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
                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                            child: Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                _searchResultComplete[index].user!.name!,
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
                                                                                  "${completeDeliveryKM[index].toStringAsFixed(1)}" +
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
                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                      child: Text(
                                                                        _searchResultComplete[index].address!.address!,
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
                                                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Container(
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getTranslated(context, history_payment).toString(),
                                                                      style: TextStyle(
                                                                          color: Palette.loginHead,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      " (" + getTranslated(context, history_complete).toString() + ")",
                                                                      style: TextStyle(
                                                                          color: Palette.green, fontSize: 16, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      getTranslated(context, history_completeAt).toString(),
                                                                      style: TextStyle(color: Palette.switchS, fontSize: 14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  _searchResultComplete[index].paymentType!,
                                                                  style: TextStyle(color: Palette.switchS),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    DateUtil().formattedDate(
                                                                        DateTime.parse(_searchResultComplete[index].completedDate!)),
                                                                    style: TextStyle(color: Palette.switchS, fontSize: 14),
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
                                            );
                                          },
                                        )
                                      : HistoryNoData()
                                  : completeOrder.length != 0
                                      ? ListView.builder(
                                          itemCount: completeOrder.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            completeDistanceInMeters = Geolocator.distanceBetween(
                                              double.parse(completeOrder[index].shop!.lat!),
                                              double.parse(completeOrder[index].shop!.lang!),
                                              double.parse(completeOrder[index].address!.lat!),
                                              double.parse(completeOrder[index].address!.lang!),
                                            );
                                            completeDeliveryKM.add(completeDistanceInMeters / 1000);
                                            return Container(
                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                              color: Palette.white,
                                              width: MediaQuery.of(context).size.width,
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
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getTranslated(context, history_oId).toString(),
                                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                    ),
                                                                    Text(
                                                                      " " + completeOrder[index].orderId!,
                                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Text(
                                                                  "\$ " + completeOrder[index].amount!.toString(),
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
                                                              alignment: AlignmentDirectional.topStart,
                                                              child: Text(
                                                                () {
                                                                  String completeTempData = "",
                                                                      completeShowData = "",
                                                                      completeCustomData = '',
                                                                      completeActualShowData = "";
                                                                  if (completeOrder[index].orderItems!.isNotEmpty) {
                                                                    for (int i = 0; i < completeOrder[index].orderItems!.length; i++) {
                                                                      completeTempData = "";
                                                                      completeCustomData = '';
                                                                      if (completeOrder[index].orderItems![i].custimization!.isNotEmpty) {
                                                                        for (int j = 0;
                                                                            j < completeOrder[index].orderItems![i].custimization!.length;
                                                                            j++) {
                                                                          completeCustomData = completeOrder[index]
                                                                              .orderItems![i]
                                                                              .custimization![j]
                                                                              .data!
                                                                              .name!;
                                                                          completeTempData = completeOrder[index].orderItems![i].itemName!;
                                                                          completeShowData = completeTempData +
                                                                              "(" +
                                                                              completeCustomData +
                                                                              ")" +
                                                                              ' x  ' +
                                                                              completeOrder[index].orderItems![i].qty!.toString() +
                                                                              ',\n';
                                                                        }
                                                                      } else {
                                                                        completeTempData = completeOrder[index].orderItems![i].itemName!;
                                                                        completeShowData = completeTempData +
                                                                            ' x ' +
                                                                            completeOrder[index].orderItems![i].qty!.toString() +
                                                                            ',\n';
                                                                      }
                                                                      completeActualShowData += completeShowData;
                                                                    }
                                                                    String result = completeActualShowData.substring(
                                                                        0, completeActualShowData.length - 2);
                                                                    completeActualShowData = result + '.';
                                                                  }
                                                                  return completeActualShowData;
                                                                }(),
                                                                style: TextStyle(fontSize: 14, color: Palette.switchS),
                                                              ),
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
                                                                              imageUrl: completeOrder[index].shop!.fullImage!,
                                                                              height: 70,
                                                                              width: 70,
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
                                                                                  width: MediaQuery.of(context).size.width * 0.55,
                                                                                  child: Text(
                                                                                    completeOrder[index].shop!.name!,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxLines: 2,
                                                                                    style: TextStyle(
                                                                                        color: Palette.loginHead,
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width * 0.55,
                                                                                  child: Text(
                                                                                    completeOrder[index].shop!.location!,
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
                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                            child: Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                completeOrder[index].user!.name!,
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
                                                                                  "${completeDeliveryKM[index].toStringAsFixed(1)}" +
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
                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                      child: Text(
                                                                        completeOrder[index].address!.address!,
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
                                                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Container(
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getTranslated(context, history_payment).toString(),
                                                                      style: TextStyle(
                                                                          color: Palette.loginHead,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      " (" + getTranslated(context, history_complete).toString() + ")",
                                                                      style: TextStyle(
                                                                          color: Palette.green, fontSize: 16, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      getTranslated(context, history_completeAt).toString(),
                                                                      style: TextStyle(color: Palette.switchS, fontSize: 14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  completeOrder[index].paymentType!,
                                                                  style: TextStyle(color: Palette.switchS),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    DateUtil()
                                                                        .formattedDate(DateTime.parse(completeOrder[index].completedDate!)),
                                                                    style: TextStyle(color: Palette.switchS, fontSize: 14),
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
                                            );
                                          },
                                        )
                                      : HistoryNoData(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  textCapitalization: TextCapitalization.words,
                                  style: TextStyle(
                                    color: Palette.loginHead,
                                    fontSize: 18,
                                  ),
                                  controller: _searchResultCancelController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Palette.white,
                                    filled: true,
                                    hintText: getTranslated(context, history_searchHint).toString(),
                                    hintStyle: TextStyle(color: Palette.bonjour),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Palette.bonjour,
                                      size: 20,
                                    ),
                                  ),
                                  onChanged: onSearchTextChangedCancel,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: RefreshIndicator(
                              onRefresh: () => _onRefresh(1),
                              color: Palette.removeAcct,
                              child: _searchResultCancel.length > 0 || _searchResultCancelController.text.isNotEmpty
                                  ? _searchResultCancel.length != 0
                                      ? ListView.builder(
                                          itemCount: _searchResultCancel.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            cancelDistanceInMeters = Geolocator.distanceBetween(
                                              double.parse(completeOrder[index].shop!.lat!),
                                              double.parse(completeOrder[index].shop!.lang!),
                                              double.parse(completeOrder[index].address!.lat!),
                                              double.parse(completeOrder[index].address!.lang!),
                                            );
                                            cancelDeliveryKM.add(cancelDistanceInMeters / 1000);
                                            return Container(
                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                              width: MediaQuery.of(context).size.width,
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
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getTranslated(context, history_oId).toString(),
                                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                    ),
                                                                    Text(
                                                                      " " + _searchResultCancel[index].orderId!,
                                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Text(
                                                                  "\$ " + _searchResultCancel[index].amount!.toString(),
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
                                                              alignment: AlignmentDirectional.topStart,
                                                              child: Text(
                                                                () {
                                                                  String cancelTempData = "",
                                                                      cancelShowData = "",
                                                                      cancelCustomData = '',
                                                                      cancelActualShowData = "";
                                                                  if (_searchResultCancel[index].orderItems!.isNotEmpty) {
                                                                    for (int i = 0;
                                                                        i < _searchResultCancel[index].orderItems!.length;
                                                                        i++) {
                                                                      cancelTempData = "";
                                                                      cancelCustomData = '';
                                                                      if (_searchResultCancel[index]
                                                                          .orderItems![i]
                                                                          .custimization!
                                                                          .isNotEmpty) {
                                                                        for (int j = 0;
                                                                            j <
                                                                                _searchResultCancel[index]
                                                                                    .orderItems![i]
                                                                                    .custimization!
                                                                                    .length;
                                                                            j++) {
                                                                          cancelCustomData = _searchResultCancel[index]
                                                                              .orderItems![i]
                                                                              .custimization![j]
                                                                              .data!
                                                                              .name!;
                                                                          cancelTempData =
                                                                              _searchResultCancel[index].orderItems![i].itemName!;
                                                                          cancelShowData = cancelTempData +
                                                                              "(" +
                                                                              cancelCustomData +
                                                                              ")" +
                                                                              ' x  ' +
                                                                              _searchResultCancel[index].orderItems![i].qty!.toString() +
                                                                              ',\n';
                                                                        }
                                                                      } else {
                                                                        cancelTempData =
                                                                            _searchResultCancel[index].orderItems![i].itemName!;
                                                                        cancelShowData = cancelTempData +
                                                                            ' x ' +
                                                                            _searchResultCancel[index].orderItems![i].qty!.toString() +
                                                                            ',\n';
                                                                      }
                                                                      cancelActualShowData += cancelShowData;
                                                                    }
                                                                    String result =
                                                                        cancelActualShowData.substring(0, cancelActualShowData.length - 2);
                                                                    cancelActualShowData = result + '.';
                                                                  }
                                                                  return cancelActualShowData;
                                                                }(),
                                                                style: TextStyle(fontSize: 14, color: Palette.switchS),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
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
                                                                              imageUrl: _searchResultCancel[index].shop!.fullImage!,
                                                                              height: 70,
                                                                              width: 70,
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
                                                                                  width: MediaQuery.of(context).size.width * 0.55,
                                                                                  child: Text(
                                                                                    _searchResultCancel[index].shop!.name!,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxLines: 2,
                                                                                    style: TextStyle(
                                                                                        color: Palette.loginHead,
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width * 0.55,
                                                                                  child: Text(
                                                                                    _searchResultCancel[index].shop!.location!,
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
                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                            child: Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                _searchResultCancel[index].user!.name!,
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
                                                                                  "${cancelDeliveryKM[index].toStringAsFixed(1)}" +
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
                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                      child: Text(
                                                                        _searchResultCancel[index].address!.address!,
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
                                                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                    Theme(
                                                      data: ThemeData(dividerColor: Colors.transparent),
                                                      child: ExpansionTile(
                                                        iconColor: Palette.removeAcct,
                                                        collapsedIconColor: Palette.removeAcct,
                                                        backgroundColor: Colors.white,
                                                        collapsedBackgroundColor: Colors.white,
                                                        title: Text(
                                                          getTranslated(context, history_cancelReason).toString(),
                                                          style: TextStyle(color: Palette.removeAcct, fontSize: 16),
                                                        ),
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                                            child: Container(
                                                              alignment: Alignment.topLeft,
                                                              child: Text(
                                                                _searchResultCancel[index].cancelReason!,
                                                                style: TextStyle(color: Palette.switchS, fontSize: 16),
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
                                          },
                                        )
                                      : HistoryNoData()
                                  : cancelOrder.length != 0
                                      ? ListView.builder(
                                          itemCount: cancelOrder.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            cancelDistanceInMeters = Geolocator.distanceBetween(
                                              double.parse(completeOrder[index].shop!.lat!),
                                              double.parse(completeOrder[index].shop!.lang!),
                                              double.parse(completeOrder[index].address!.lat!),
                                              double.parse(completeOrder[index].address!.lang!),
                                            );
                                            cancelDeliveryKM.add(cancelDistanceInMeters / 1000);
                                            return Container(
                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                              width: MediaQuery.of(context).size.width,
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
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getTranslated(context, history_oId).toString(),
                                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                    ),
                                                                    Text(
                                                                      " " + cancelOrder[index].orderId!,
                                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Text(
                                                                  "\$ " + cancelOrder[index].amount!.toString(),
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
                                                              alignment: AlignmentDirectional.topStart,
                                                              child: Text(
                                                                () {
                                                                  String cancelTempData = "",
                                                                      cancelShowData = "",
                                                                      cancelCustomData = '',
                                                                      cancelActualShowData = "";
                                                                  if (cancelOrder[index].orderItems!.isNotEmpty) {
                                                                    for (int i = 0; i < cancelOrder[index].orderItems!.length; i++) {
                                                                      cancelTempData = "";
                                                                      cancelCustomData = '';
                                                                      if (cancelOrder[index].orderItems![i].custimization!.isNotEmpty) {
                                                                        for (int j = 0;
                                                                            j < cancelOrder[index].orderItems![i].custimization!.length;
                                                                            j++) {
                                                                          cancelCustomData = cancelOrder[index]
                                                                              .orderItems![i]
                                                                              .custimization![j]
                                                                              .data!
                                                                              .name!;
                                                                          cancelTempData = cancelOrder[index].orderItems![i].itemName!;
                                                                          cancelShowData = cancelTempData +
                                                                              "(" +
                                                                              cancelCustomData +
                                                                              ")" +
                                                                              ' x  ' +
                                                                              cancelOrder[index].orderItems![i].qty!.toString() +
                                                                              ',\n';
                                                                        }
                                                                      } else {
                                                                        cancelTempData = cancelOrder[index].orderItems![i].itemName!;
                                                                        cancelShowData = cancelTempData +
                                                                            ' x ' +
                                                                            cancelOrder[index].orderItems![i].qty!.toString() +
                                                                            ',\n';
                                                                      }
                                                                      cancelActualShowData += cancelShowData;
                                                                    }
                                                                    String result =
                                                                        cancelActualShowData.substring(0, cancelActualShowData.length - 2);
                                                                    cancelActualShowData = result + '.';
                                                                  }

                                                                  return cancelActualShowData;
                                                                }(),
                                                                style: TextStyle(fontSize: 14, color: Palette.switchS),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                                              imageUrl: cancelOrder[index].shop!.fullImage!,
                                                                              height: 70,
                                                                              width: 70,
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
                                                                                  width: MediaQuery.of(context).size.width * 0.55,
                                                                                  child: Text(
                                                                                    cancelOrder[index].shop!.name!,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxLines: 2,
                                                                                    style: TextStyle(
                                                                                        color: Palette.loginHead,
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width * 0.55,
                                                                                  child: Text(
                                                                                    cancelOrder[index].shop!.location!,
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
                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                            child: Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: Text(
                                                                                cancelOrder[index].user!.name!,
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
                                                                                  "${cancelDeliveryKM[index].toStringAsFixed(1)}" +
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
                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                      child: Text(
                                                                        cancelOrder[index].address!.address!,
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
                                                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                    Theme(
                                                      data: ThemeData(dividerColor: Colors.transparent),
                                                      child: ExpansionTile(
                                                        iconColor: Palette.removeAcct,
                                                        collapsedIconColor: Palette.removeAcct,
                                                        backgroundColor: Colors.white,
                                                        collapsedBackgroundColor: Colors.white,
                                                        title: Text(
                                                          getTranslated(context, history_cancelReason).toString(),
                                                          style: TextStyle(color: Palette.removeAcct, fontSize: 16),
                                                        ),
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                                            child: Container(
                                                              alignment: Alignment.topLeft,
                                                              child: Text(
                                                                cancelOrder[index].cancelReason!,
                                                                style: TextStyle(color: Palette.switchS, fontSize: 16),
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
                                          },
                                        )
                                      : HistoryNoData(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  textCapitalization: TextCapitalization.words,
                                  style: TextStyle(
                                    color: Palette.loginHead,
                                    fontSize: 18,
                                  ),
                                  controller: _searchResultPackageController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Palette.white,
                                    filled: true,
                                    hintText: getTranslated(context, history_searchHint).toString(),
                                    hintStyle: TextStyle(color: Palette.bonjour),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Palette.bonjour,
                                      size: 20,
                                    ),
                                  ),
                                  onChanged: onSearchTextChangedPackage,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: RefreshIndicator(
                              onRefresh: () => _onRefresh(2),
                              color: Palette.removeAcct,
                              child: _searchResultPackage.length > 0 || _searchResultPackageController.text.isNotEmpty
                                  ? _searchResultPackage.length != 0
                                      ? ListView.builder(
                                          itemCount: _searchResultPackage.length,
                                          itemBuilder: (context, index) {
                                            packageDTPDistanceInMeters = Geolocator.distanceBetween(
                                              liveLat,
                                              liveLang,
                                              double.parse(_searchResultPackage[index].pickLat!),
                                              double.parse(_searchResultPackage[index].pickLang!),
                                            );
                                            packageDTPDeliveryKM.add(packageDTPDistanceInMeters / 1000);

                                            packagePTDDistanceInMeters = Geolocator.distanceBetween(
                                              double.parse(_searchResultPackage[index].pickLat!),
                                              double.parse(_searchResultPackage[index].pickLang!),
                                              double.parse(_searchResultPackage[index].dropLat!),
                                              double.parse(_searchResultPackage[index].dropLang!),
                                            );
                                            packagePTDDeliveryKM.add(packagePTDDistanceInMeters / 1000);

                                            return Container(
                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                              width: MediaQuery.of(context).size.width,
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
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getTranslated(context, history_oId).toString(),
                                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                    ),
                                                                    Text(
                                                                      " " + _searchResultPackage[index].packageId!,
                                                                      style: TextStyle(color: Palette.loginHead, fontSize: 16),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Text(
                                                                  "\$ " + _searchResultPackage[index].amount!.toString(),
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
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                                                child: Text(
                                                                  _searchResultPackage[index].user!.name!,
                                                                  style: TextStyle(
                                                                      fontSize: 16, color: Palette.loginHead, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                                                child: Container(
                                                                  child: Text(
                                                                    _searchResultPackage[index].orderStatus!,
                                                                    style: TextStyle(
                                                                        fontSize: 14, color: Palette.green, fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                                            child: Align(
                                                              alignment: AlignmentDirectional.topStart,
                                                              child: Text(
                                                                _searchResultPackage[index].category!.name!,
                                                                style: TextStyle(color: Palette.switchS, fontSize: 14),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                                                                    Container(
                                                                      width: MediaQuery.of(context).size.width * 0.83,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Pickup Address",
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Palette.loginHead,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.location_on,
                                                                                color: Palette.loginHead,
                                                                                size: 20,
                                                                              ),
                                                                              Text(
                                                                                "${packageDTPDeliveryKM[index].toStringAsFixed(1)}" +
                                                                                    getTranslated(context, homePage_km).toString(),
                                                                                style: TextStyle(color: Palette.loginHead, fontSize: 12),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                      child: Text(
                                                                        _searchResultPackage[index].pickupLocation!,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 2,
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          color: Palette.switchS,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context).size.width * 0.83,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                                                                            child: Text(
                                                                              "Delivery Address",
                                                                              style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: Palette.loginHead,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                                                            child: Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.location_on,
                                                                                  color: Palette.loginHead,
                                                                                  size: 20,
                                                                                ),
                                                                                Text(
                                                                                  "${packagePTDDeliveryKM[index].toStringAsFixed(1)}" +
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
                                                                      width: MediaQuery.of(context).size.width * 0.8,
                                                                      child: Text(
                                                                        _searchResultPackage[index].dropupLocation!,
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
                                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                          _searchResultPackage[index].orderStatus! == "Complete"
                                                              ? Padding(
                                                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            child: Row(
                                                                              children: [
                                                                                Text(
                                                                                  getTranslated(context, history_payment).toString(),
                                                                                  style: TextStyle(
                                                                                      color: Palette.loginHead,
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  getTranslated(context, history_complete).toString(),
                                                                                  style: TextStyle(
                                                                                      color: Palette.green,
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Container(
                                                                                child: Text(
                                                                                  getTranslated(context, history_completeAt).toString(),
                                                                                  style: TextStyle(color: Palette.switchS, fontSize: 14),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Align(
                                                                        alignment: Alignment.topLeft,
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              _searchResultPackage[index].paymentType!,
                                                                              style: TextStyle(color: Palette.switchS),
                                                                            ),
                                                                            Container(
                                                                              child: Text(
                                                                                DateUtil().formattedDate(
                                                                                  DateTime.parse(
                                                                                      _searchResultPackage[index].completedDate!),
                                                                                ),
                                                                                style: TextStyle(color: Palette.switchS, fontSize: 14),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : ExpansionTile(
                                                                  iconColor: Palette.removeAcct,
                                                                  collapsedIconColor: Palette.removeAcct,
                                                                  title: Text(
                                                                    getTranslated(context, history_cancelReason).toString(),
                                                                    style: TextStyle(
                                                                        color: Palette.removeAcct,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold),
                                                                  ),
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                      child: Text(
                                                                        _searchResultPackage[index].cancelReason!,
                                                                        style: TextStyle(color: Palette.switchS, fontSize: 14),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : HistoryNoData()
                                  : packageOrder.length != 0
                                      ? ListView.builder(
                                          itemCount: packageOrder.length,
                                          itemBuilder: (context, index) {
                                            packageDTPDistanceInMeters = Geolocator.distanceBetween(
                                              liveLat,
                                              liveLang,
                                              double.parse(packageOrder[index].pickLat!),
                                              double.parse(packageOrder[index].pickLang!),
                                            );
                                            packageDTPDeliveryKM.add(packageDTPDistanceInMeters / 1000);
                                            packagePTDDistanceInMeters = Geolocator.distanceBetween(
                                              double.parse(packageOrder[index].pickLat!),
                                              double.parse(packageOrder[index].pickLang!),
                                              double.parse(packageOrder[index].dropLat!),
                                              double.parse(packageOrder[index].dropLang!),
                                            );
                                            packagePTDDeliveryKM.add(packagePTDDistanceInMeters / 1000);

                                            return Container(
                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                              width: MediaQuery.of(context).size.width,
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
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getTranslated(context, history_oId).toString(),
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
                                                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                child: Text(
                                                                  "\$ " + packageOrder[index].amount!.toString(),
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
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                                                child: Text(
                                                                  packageOrder[index].user!.name!,
                                                                  style: TextStyle(
                                                                      fontSize: 16, color: Palette.loginHead, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                                                child: Container(
                                                                  child: Text(
                                                                    packageOrder[index].orderStatus!,
                                                                    style: TextStyle(
                                                                        fontSize: 14, color: Palette.green, fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                                            child: Align(
                                                              alignment: AlignmentDirectional.topStart,
                                                              child: Text(
                                                                packageOrder[index].category!.name!,
                                                                style: TextStyle(color: Palette.switchS, fontSize: 14),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                                                                    Container(
                                                                      width: MediaQuery.of(context).size.width * 0.83,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Pickup Address",
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Palette.loginHead,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.location_on,
                                                                                color: Palette.loginHead,
                                                                                size: 20,
                                                                              ),
                                                                              Text(
                                                                                "${packageDTPDeliveryKM[index].toStringAsFixed(1)}" +
                                                                                    getTranslated(context, homePage_km).toString(),
                                                                                style: TextStyle(color: Palette.loginHead, fontSize: 12),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context).size.width * 0.8,
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
                                                                      width: MediaQuery.of(context).size.width * 0.83,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                                                                            child: Text(
                                                                              "Delivery Address",
                                                                              style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: Palette.loginHead,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                                                            child: Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.location_on,
                                                                                  color: Palette.loginHead,
                                                                                  size: 20,
                                                                                ),
                                                                                Text(
                                                                                  "${packagePTDDeliveryKM[index].toStringAsFixed(1)}" +
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
                                                                      width: MediaQuery.of(context).size.width * 0.8,
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
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                          packageOrder[index].orderStatus! == "Complete"
                                                              ? Padding(
                                                                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            child: Row(
                                                                              children: [
                                                                                Text(
                                                                                  getTranslated(context, history_payment).toString(),
                                                                                  style: TextStyle(
                                                                                      color: Palette.loginHead,
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  getTranslated(context, history_complete).toString(),
                                                                                  style: TextStyle(
                                                                                      color: Palette.green,
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Container(
                                                                                child: Text(
                                                                                  getTranslated(context, history_completeAt).toString(),
                                                                                  style: TextStyle(color: Palette.switchS, fontSize: 14),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Align(
                                                                        alignment: Alignment.topLeft,
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              packageOrder[index].paymentType!,
                                                                              style: TextStyle(color: Palette.switchS),
                                                                            ),
                                                                            Container(
                                                                              child: Text(
                                                                                DateUtil().formattedDate(DateTime.parse(
                                                                                  packageOrder[index].completedDate!,
                                                                                )),
                                                                                style: TextStyle(color: Palette.switchS, fontSize: 14),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : ExpansionTile(
                                                                  iconColor: Palette.removeAcct,
                                                                  collapsedIconColor: Palette.removeAcct,
                                                                  title: Text(
                                                                    getTranslated(context, history_cancelReason).toString(),
                                                                    style: TextStyle(
                                                                        color: Palette.removeAcct,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold),
                                                                  ),
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                                      child: Text(
                                                                        packageOrder[index].cancelReason!,
                                                                        style: TextStyle(color: Palette.switchS, fontSize: 14),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : HistoryNoData(),
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

  Future<void> _onRefresh(int selectedPage) async {
    setState(() {
      _changePage(selectedPage);
      _pageController = PageController(initialPage: selectedPage);
      callApiDriverOrderHistory();
    });
  }

  Future<BaseModel<DriverOrderHistoryModel>> callApiDriverOrderHistory() async {
    DriverOrderHistoryModel response;
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).driverOrderHistoryRequest();
      setState(() {
        loading = false;
        completeOrder.clear();
        cancelOrder.clear();
        packageOrder.clear();
        completeOrder.addAll(response.data!.complete!);
        cancelOrder.addAll(response.data!.cancel!);
        packageOrder.addAll(response.data!.packageOrder!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  onSearchTextChangedComplete(String text) async {
    _searchResultComplete.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    completeOrder.forEach((completeOrderData) {
      if (completeOrderData.orderId!.toLowerCase().contains(text.toLowerCase())) _searchResultComplete.add(completeOrderData);
      if (completeOrderData.user!.name!.toLowerCase().contains(text.toLowerCase())) _searchResultComplete.add(completeOrderData);
    });

    setState(() {});
  }

  onSearchTextChangedCancel(String text) async {
    _searchResultCancel.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    cancelOrder.forEach((cancelOrderData) {
      if (cancelOrderData.orderId!.toLowerCase().contains(text.toLowerCase())) _searchResultCancel.add(cancelOrderData);
      if (cancelOrderData.user!.name!.toLowerCase().contains(text.toLowerCase())) _searchResultCancel.add(cancelOrderData);
    });

    setState(() {});
  }

  onSearchTextChangedPackage(String text) async {
    _searchResultPackage.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    packageOrder.forEach((packageOrderData) {
      if (packageOrderData.packageId!.toLowerCase().contains(text.toLowerCase())) _searchResultPackage.add(packageOrderData);
      if (packageOrderData.user!.name!.toLowerCase().contains(text.toLowerCase())) _searchResultPackage.add(packageOrderData);
    });

    setState(() {});
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
                textAlign: TextAlign.center,
                style: TextStyle(color: Palette.loginHead, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateUtil {
  static const DATE_FORMAT = 'dd-MM-yyyy';

  String formattedDate(DateTime dateTime) {
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}
