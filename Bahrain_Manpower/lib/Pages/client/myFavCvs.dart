// ignore_for_file: file_names, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:bahrain_manpower/Global/Settings.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Pages/client/myCVs.dart';
import 'package:bahrain_manpower/models/AppInfo/paymentData.dart';
import 'package:bahrain_manpower/models/client/favoriteEmployee.dart';
import 'package:bahrain_manpower/services/ClientService.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/appDataService.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/services/workersService.dart';
import 'package:bahrain_manpower/widgets/Employees/employeesListCard.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFavCvsScreen extends StatefulWidget {
  const MyFavCvsScreen({Key? key}) : super(key: key);

  @override
  MyFavCvsScreenState createState() => MyFavCvsScreenState();
}

class MyFavCvsScreenState extends State<MyFavCvsScreen> {
  bool isLoading = true;
  List<FavoriteEmployee> workers = [];
   PaymentData? payment;
  getMyCv() async {
    workers = await ClientService().favoraiteList();
    payment = await AppDataService().getPaymentData();
    isLoading = false;
    setState(() {});
  }

  requestCv(id) async {
    bool result = await WorkerService().viewCv(id: id);
    isLoading = false;
    setState(() {});
    if (result) {
      pushPage(context, const MyCvsScreen());
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("id") ?? "";
      launchURL(
          "${baseUrl}pay?client_id=$userId&worker_id=$id");
    }
  }

  deleteCv(id) async {
    bool _ = await ClientService().deleteFromFavorite(id);
    workers.clear();
    workers = await ClientService().favoraiteList();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getMyCv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme:  IconThemeData(color: mainOrangeColor),
          backgroundColor: offWhite,
        ),
        body: isLoading
            ?
        const Loader()
            : ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: workers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EmployeesCards(
                      isCompany: true,
                      data: workers[index].worker,
                      name: Localizations.localeOf(context).languageCode == "en"
                          ? workers[index].worker!.nameEn ?? ""
                          : workers[index].worker!.nameAr ?? "",
                      img: workers[index].worker!.image1 ?? "",
                      phone: "${workers[index].worker!.mobile}",
                      whatsApp: "${workers[index].worker!.whatsapp}",
                      job: Localizations.localeOf(context).languageCode == "en"
                          ? workers[index].worker!.occupation?.titleEn ?? ""
                          : workers[index].worker!.occupation?.titleAr ?? "",
                      country: Localizations.localeOf(context).languageCode ==
                              "en"
                          ? workers[index].worker!.residence?.titleEn ?? ""
                          : workers[index].worker!.residence?.titleAr ?? "",
                      onagree: () {
                        isLoading = true;
                        setState(() {});
                        requestCv("${workers[index].workerId}");
                      },
                      onDelete: () {
                        isLoading = true;
                        setState(() {});
                        deleteCv("${workers[index].favoriteId}");
                      },
                    ),
                  );
                },
              ));
  }
}
