

import 'package:bahrain_manpower/I10n/AppLanguage.dart';
import 'package:bahrain_manpower/selectSection.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'Global/theme.dart';

class SelectLang extends StatefulWidget {
  const SelectLang({Key? key}) : super(key: key);

  @override
  SelectLangState createState() => SelectLangState();
}

class SelectLangState extends State<SelectLang> {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 100)),
          Image.asset(
            "assets/icon/logo.png",
            scale: 2,
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 40)),
          InkWell(
            onTap: () {
              appLanguage.changeLanguage(const Locale("ar"));
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SelectSections(),
              ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: mainOrangeColor),
              child: const Text("عربي",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20)),
          InkWell(
              onTap: () {
                appLanguage.changeLanguage(const Locale("en"));
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SelectSections(),
                ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: mainOrangeColor),
                child: const Text("English",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ))
        ],
      ),
    );
  }
}
