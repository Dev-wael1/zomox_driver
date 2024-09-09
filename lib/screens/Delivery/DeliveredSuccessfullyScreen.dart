import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import '../HomePageScreen.dart';

class DeliveredSuccessfullyScreen extends StatefulWidget {
  @override
  _DeliveredSuccessfullyScreenState createState() => _DeliveredSuccessfullyScreenState();
}

class _DeliveredSuccessfullyScreenState extends State<DeliveredSuccessfullyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/delivered.svg'),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                getTranslated(context, deliverySuccess_text).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, color: Palette.switchS),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePageScreen(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated(context, deliverySuccess_button).toString(),
                    style: TextStyle(color: Palette.loginHead, fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_right,
                      color: Palette.loginHead,
                      size: 30.0,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
