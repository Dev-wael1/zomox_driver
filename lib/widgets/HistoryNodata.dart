import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';

class HistoryNoData extends StatefulWidget {
  @override
  _HistoryNoDataState createState() => _HistoryNoDataState();
}

class _HistoryNoDataState extends State<HistoryNoData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                SvgPicture.asset('assets/icons/noData.svg'),
                SizedBox(
                  height: 50,
                ),
                Text(
                  getTranslated(context, noData_noData_available).toString(),
                  style: TextStyle(color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
