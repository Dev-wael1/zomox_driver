import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/config/prefConstatnt.dart';
import 'package:zomox_driver/const/preference.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/model/driver_earning_model.dart';
import 'package:zomox_driver/retrofit/Retrofit_Api.dart';
import 'package:zomox_driver/retrofit/base_model.dart';
import 'package:zomox_driver/retrofit/network_api.dart';
import 'package:zomox_driver/retrofit/server_error.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../HomePageScreen.dart';
import 'ProfileEditScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = false;

  int driverTodayEarning = 0;
  int driverWeeklyEarning = 0;
  int driverMonthlyEarning = 0;
  int driverYearlyEarning = 0;
  int driverTotalEarning = 0;

  List<Graph> chartData = [];

  @override
  void initState() {
    super.initState();
    callApiDriverEarning();
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
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                  builder: (context) => HomePageScreen(),
                ),
              );
            },
          ),
          title: Text(
            getTranslated(context, Profile_title).toString(),
            style: TextStyle(color: Palette.loginHead, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => ProfileEditScreen(),
                      ),
                    );
                  },
                  child: Text(
                    getTranslated(context, Profile_editProfile).toString(),
                    style: TextStyle(color: Palette.blue, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: Row(
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
                                  placeholder: (context, url) =>
                                      SpinKitFadingCircle(color: Palette.removeAcct),
                                  errorWidget: (context, url, error) => ClipRRect(
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    SharedPreferenceHelper.getString(Preferences.driverName),
                                    style: TextStyle(
                                        color: Palette.loginHead,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    SharedPreferenceHelper.getString(Preferences.driverEmail),
                                    style: TextStyle(color: Palette.loginHead, fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated(context, Profile_earnings).toString(),
                                  style: TextStyle(
                                      color: Palette.loginHead,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "\$ "  "$driverTotalEarning",
                                  style: TextStyle(
                                    color: Palette.switchS,
                                    fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Column(
                        children: [
                          SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                majorGridLines: const MajorGridLines(
                                  width: 0,
                                ),
                              ),
                              legend: Legend(isVisible: false),
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                              ),
                              series: <CartesianSeries<Graph, String>>[
                                ColumnSeries<Graph, String>(
                                    dataSource: chartData,
                                    xValueMapper: (Graph data, _) => data.month,
                                    yValueMapper: (Graph data, _) => data.monthEarning,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                    ),
                                    isVisibleInLegend: false,
                                    gradient: LinearGradient(
                                        colors: [Palette.chart2, Palette.chart1,],
                                        stops: [0.0, 1.0],
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        tileMode: TileMode.repeated),
                                ),
                              ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  '\$' + driverTodayEarning.toString(),
                                  style: TextStyle(fontSize: 35, color: Palette.loginHead),
                                ),
                                Text(
                                  getTranslated(context, Profile_today_earning).toString(),
                                  style: TextStyle(fontSize: 15, color: Palette.switchS),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  '\$' + driverWeeklyEarning.toString(),
                                  style: TextStyle(fontSize: 35, color: Palette.loginHead),
                                ),
                                Text(
                                  getTranslated(context, Profile_weekly_earning).toString(),
                                  style: TextStyle(fontSize: 15, color: Palette.switchS),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  '\$' + driverMonthlyEarning.toString(),
                                  style: TextStyle(fontSize: 35, color: Palette.loginHead),
                                ),
                                Text(
                                  getTranslated(context, Profile_monthly_earning).toString(),
                                  style: TextStyle(fontSize: 15, color: Palette.switchS),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  '\$' + driverYearlyEarning.toString(),
                                  style: TextStyle(fontSize: 35, color: Palette.loginHead),
                                ),
                                Text(
                                  getTranslated(context, Profile_yearly_earning).toString(),
                                  style: TextStyle(fontSize: 15, color: Palette.switchS),
                                )
                              ],
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
        ),
      ),
    );
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
        driverWeeklyEarning = response.data!.weekEarning!;
        driverMonthlyEarning = response.data!.currentMonth!;
        driverYearlyEarning = response.data!.yearliyEarning!;
        driverTotalEarning = response.data!.totalAmount!;

        if(response.data!.graph != null){
          chartData.addAll(response.data!.graph!);
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
}

class ChartData {
  ChartData(
    this.x,
    this.y,
  );

  final String x;
  final double? y;
}
