import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zomox_driver/config/Palette.dart';
import 'package:zomox_driver/config/app_string.dart';
import 'package:zomox_driver/config/prefConstatnt.dart';
import 'package:zomox_driver/const/preference.dart';
import 'package:zomox_driver/localization/localization_constant.dart';
import 'package:zomox_driver/main.dart';

class ChangeLanguageScreen extends StatefulWidget {
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  int? value;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Palette.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          getTranslated(context, changeLanguage_title).toString(),
          style: TextStyle(color: Palette.black, fontSize: 18),
        ),
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
          margin: EdgeInsets.only(left: 10, right: 10),
          child: ListView.builder(
            itemCount: Language.languageList().length,
            padding: EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              this.value = 0;
              this.value =
                  Language.languageList()[index].languageCode == SharedPreferenceHelper.getString(Preferences.current_language_code)
                      ? index
                      : null;
              if (SharedPreferenceHelper.getString(Preferences.current_language_code) == 'N/A') {
                this.value = 0;
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RadioListTile(
                      value: index,
                      controlAffinity: ListTileControlAffinity.trailing,
                      groupValue: this.value,
                      activeColor: Palette.removeAcct,
                      onChanged: (dynamic value) async {
                        this.value = value;
                        Locale local = await setLocale(Language.languageList()[index].languageCode);
                        setState(() {
                          MyApp.setLocale(context, local);
                          SharedPreferenceHelper.setString(Preferences.current_language_code, Language.languageList()[index].languageCode);
                          Navigator.of(context).pop();
                        });
                      },
                      title: Text(Language.languageList()[index].name),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            'We will add more language to be soon!',
            style: TextStyle(color: Palette.switchS, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList() {
    return <Language>[Language(1, 'English', '🇺🇸', 'en'), Language(2, 'Spanish', 'ES', 'es'), Language(3, 'Arabic', 'AE', 'ar')];
  }
}
