// ignore_for_file: prefer_is_empty, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Pages/Notification/widget/notifiction_cell.dart';
import 'package:bahrain_manpower/models/other/notification_list_model.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsListScreen extends StatefulWidget {
  const NotificationsListScreen({Key? key}) : super(key: key);

  @override
  NotificationsListScreenState createState() => NotificationsListScreenState();
}

class NotificationsListScreenState extends State<NotificationsListScreen> {
  bool isLoading = true;
  var type ;
  late List<Datum>? userNotificationList;
  getAllListOfNotification()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString("type");
    final userList= await NotificationServices().listAllNotification();
    userNotificationList = userList.data;
    isLoading=false;
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAllListOfNotification();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
        title: Text(
          Localizations.localeOf(context).languageCode == "en"
              ?"Notification list":"قيمة الاشعرات",
          style: TextStyle(color: mainOrangeColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: mainOrangeColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading?const Loader(): userNotificationList?.length==0?
      SizedBox(
        height: MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/icon/notification_holder.png"),
            ),
            const SizedBox(height: 20,),
            Text(Localizations.localeOf(context).languageCode == "en"
                ?"no Notification available":"لا يوجد اشعرات متوفره لان",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20

              ),),
          ],
        ),
      ):ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: userNotificationList?.length,
          itemBuilder: (context, int index) {
            return NotificationCell(press: () { NotificationServices.notificationSelectingAction(userNotificationList![index].type??"", context); },notification: userNotificationList![index],type: type,);
          }),
    );
  }
}