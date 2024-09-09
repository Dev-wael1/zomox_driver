import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';

class BeforeOnline extends StatefulWidget {
  @override
  _BeforeOnlineState createState() => _BeforeOnlineState();
}

class _BeforeOnlineState extends State<BeforeOnline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/before.svg'),
            SizedBox(
              height: 50,
            ),
            Text(
              getTranslated(context, beforeOnline_offline).toString(),
              style: TextStyle(color: Palette.loginHead, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(45, 20, 45, 0),
              child: Text(
                getTranslated(context, beforeOnline_text).toString(),
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
    );
  }
}
