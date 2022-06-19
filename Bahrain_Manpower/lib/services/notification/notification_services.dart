// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/Settings.dart';
import 'package:bahrain_manpower/Pages/ChatingScreen/chats_list_screen.dart';
import 'package:bahrain_manpower/models/other/notification.dart';
import 'package:bahrain_manpower/models/other/notification_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class NotificationServices{
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
 final notification = "notifications";
 static var context;



  static checkNotificationAppInBackground(context) async{
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        var data;
        message.data.forEach((key, value) {
          if (key == "data"){

            data=notificationFromJson(value).route;
          }
        });
        notificationSelectingAction(data, context);
      }
    });
  }
  static checkNotificationAppInForeground(contextOfScreen) async{
    context = contextOfScreen;
    FirebaseMessaging.onMessage.listen((message) {

      NotificationServices.display(message);
    });
  }
  static launchURL(String url) async {
    if (await launchUrl(Uri.parse(url))) {

    } else {
      throw 'Could not launch $url';
    }
  }
  static void initialize(){
    final InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings(
        "@mipmap/ic_launcher"
    ),iOS: IOSInitializationSettings());
    _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? route) async{
      if(route != null){
        notificationSelectingAction(route, context);
      }
  });
  }
   Future<NotificationList> listAllNotification() async {
    Response response;
    NotificationList result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("id") ?? "";
    var body =FormData.fromMap({
      "company_id": userId,
    });
    response = await Dio().post('$baseUrl$notification', data: body);
    var data = response.data;
    result = NotificationList.fromJson(data) ;
    return result;
  }
  static void display(RemoteMessage message)async{
    var data;
    message.data.forEach((key, value) {
      if (key == "data"){
        data=notificationFromJson(value).route;
      }
    });
    final id = DateTime.now().microsecondsSinceEpoch ~/100000000000000.toInt();
    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          "high_importance_channel",
        "high_importance_channel high high",
        importance: Importance.max,
        priority: Priority.max,

      ),

    );

    await _notificationsPlugin.show(id, message.notification?.title??"", message.notification?.body??"", notificationDetails,payload: data,);
  }
   static void notificationSelectingAction(String? route,context){


    switch(route){
      case "chat":
        {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  ChatsListScreen()),
          );
        }
        break;
      case "update":{
        launchURL(Platform.isAndroid
            ? "https://play.google.com/store/apps/details?id=com.syncapps.manpower"
            : "https://apps.apple.com/us/app/id1573160692",);
      }
      break;

    }

   }
}