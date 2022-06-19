// ignore_for_file: file_names

import 'package:bahrain_manpower/Global/theme.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/models/Companies/Employees.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/services/workersService.dart';
import 'package:bahrain_manpower/widgets/Employees/employeesListCard.dart';
import 'package:bahrain_manpower/widgets/loader.dart';

class MyCvsScreen extends StatefulWidget {
  const MyCvsScreen({Key? key}) : super(key: key);

  @override
  MyCvsScreenState createState() => MyCvsScreenState();
}

class MyCvsScreenState extends State<MyCvsScreen> {
  bool isLoading = true;
  List<Employees> workers = [];
  getMyCv() async {
    workers = await WorkerService().getPaidWorker();
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
            ? const Loader()
            : ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: workers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EmployeesCards(
                      name: Localizations.localeOf(context).languageCode == "en"
                          ? workers[index].nameEn ?? ""
                          : workers[index].nameAr ?? "",
                      img: workers[index].image1 ?? "",
                      phone: "${workers[index].mobile}",
                      job: Localizations.localeOf(context).languageCode == "en"
                          ? workers[index].occupation?.titleEn ?? ""
                          : workers[index].occupation?.titleAr ?? "",
                      country:
                          Localizations.localeOf(context).languageCode == "en"
                              ? workers[index].residence?.titleEn ?? ""
                              : workers[index].residence?.titleAr ?? "",
                    ),
                  );
                },
              ));
  }
}
