// ignore_for_file: file_names

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/models/AppInfo/packages.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/appDataService.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  PackagesScreenState createState() => PackagesScreenState();
}

class PackagesScreenState extends State<PackagesScreen> {
  bool isLoading = true;
  List<PackagesModel> list = [];
   String? id;

  getPackages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id");
    list = await AppDataService().getPackages();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
      ),
      body: isLoading
          ? const Loader()
          : ListView.builder(
              itemCount: list.length,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      launchURL(
                          "http://manpower-kw.com/api/pay?client_id=$id&package_id=${list[index].packageId}");
                    },
                    tileColor: mainOrangeColor,
                    title:  ExpandableNotifier(

                    child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                    children: <Widget>[
                    ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                    headerAlignment:
                    ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                    ),
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.money, color: Colors.white),
                        Text(
                          Localizations.localeOf(context).languageCode == "en"
                              ? "${list[index].titleEn}"
                              : "${list[index].titleAr}",maxLines: null,
                          softWrap: true,
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          "${list[index].value}",
                          softWrap: true,
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        )
                      ],
                    ),
                expanded:Text( Localizations.localeOf(context).languageCode == "en" ?list[index].featuresEn??"":list[index].featuresAr??"",style: const TextStyle(fontSize: 15, color: Colors.white),),
                collapsed: Align(
                  alignment: Alignment.centerRight,
                  child: Text(Localizations.localeOf(context).languageCode == "en"
                      ?"for More Information":"للمزيد من المعلومات",style: const TextStyle(fontSize: 15, color: Colors.white),),
                ),
                builder: (_, collapsed, expanded) {
                return Padding(
                padding: const EdgeInsets.only(
                left: 10, right: 10, bottom: 10),
                child: Expandable(
                collapsed: collapsed,
                expanded: expanded,
                theme: const ExpandableThemeData(
                crossFadePoint: 0),
                ),
                );
                },
                ),
                ),
                ],
                ),
                  ),
                ),),);
              },
            ),
    );
  }
}
