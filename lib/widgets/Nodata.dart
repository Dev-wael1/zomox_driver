import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';

class NoData extends StatefulWidget {
  @override
  _NoDataState createState() => _NoDataState();
}

class _NoDataState extends State<NoData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/noData.svg'),
                SizedBox(
                  height: 30,
                ),
                Text(
                  getTranslated(context, noData_noData_available).toString(),
                  style: TextStyle(color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(45, 10, 45, 0),
                  child: Text(
                    getTranslated(context, noData_text).toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Palette.switchS,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
