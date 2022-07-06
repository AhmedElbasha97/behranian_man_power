// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';

import 'package:bahrain_manpower/Pages/searchForEmplyee.dart';
import 'package:bahrain_manpower/models/other/notification.dart';
import 'package:bahrain_manpower/selectLang.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/ChatingScreen/chating_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

   String? token;
  checkToken() async {

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      var data;
      message.data.forEach((key, value) {
        if (key == "data"){
          data=notificationFromJson(value).route;
        }
      });
      if (data == "update") {
        launchURL(Platform.isAndroid
            ? "https://play.google.com/store/apps/details?id=com.syncapps.manpower"
            : "https://apps.apple.com/us/app/id1573160692",);
      } else if (data == "chat") {
        final companyIdFromMessage = message.data["companyID"];
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                ChattingScreen(reciverId: companyIdFromMessage,)));
      }}
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");


    Future.delayed(
        const Duration(seconds: 2),
        () => {
          if (id == null)
                {pushPageReplacement(context, const SelectLang())}
              else
                {pushPageReplacement(context, const SearchForEmployee())}
            });

  }

  @override
  void initState() {
    super.initState();
    checkToken();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/icon/logo.png'),
      ),
    );
  }
}
