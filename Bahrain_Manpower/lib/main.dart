
// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bahrain_manpower/Pages/ChatingScreen/chats_list_screen.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'I10n/AppLanguage.dart';
import 'I10n/app_localizations.dart';
import 'models/other/notification.dart';

Future<void>backGroundHandler(message)async {
  var data;
  message.data.forEach((key, value) {
    if (key == "data"){
      data=notificationFromJson(value).route;
    }
  });
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("route", "$data");
}

launchURL(String url) async {
  if (await launchUrl(Uri.parse(url))) {

  } else {
    throw 'Could not launch $url';
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(appLanguage: appLanguage));
}

class MyApp extends StatefulWidget {
  final AppLanguage? appLanguage;
  const MyApp({Key? key,this.appLanguage}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    NotificationServices.checkNotificationAppInBackground(context);
    NotificationServices.initialize();
    NotificationServices.checkNotificationAppInForeground(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        var data;
        message.data.forEach((key, value) {
          if (key == "data"){
            data=notificationFromJson(value).route;
          }
        });
        switch(data){
          case "chat":
            {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>  const ChatsListScreen()),
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
    });
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => widget.appLanguage,
        child: Consumer<AppLanguage>(
          builder: (context, model, child) {
            return MaterialApp(

              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate
              ],
              supportedLocales: const [
                Locale("en", "US"),
                Locale("ar", ""),
              ],
              locale: model.appLocal,
              title: 'مان بور',
              theme: ThemeData(

                primaryColor: offWhite,
                textTheme: Theme.of(context).textTheme.apply(
                      fontFamily: 'DroidKufi',
                    ),
              ),
              home: const SplashScreen(),
            );
          },
        ));
  }
}
