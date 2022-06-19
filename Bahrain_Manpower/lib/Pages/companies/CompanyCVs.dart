// ignore_for_file: file_names

import 'package:bahrain_manpower/Global/theme.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:bahrain_manpower/models/Companies/Employees.dart';
import 'package:bahrain_manpower/services/Companies/CompaniesService.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/Employees/employeesListCard.dart';
import 'package:bahrain_manpower/widgets/loader.dart';

class CompanyCvScreen extends StatefulWidget {
  final String? id;
 const CompanyCvScreen({Key? key, this.id=""}): super(key: key);
  @override
  CompanyCvScreenState createState() => CompanyCvScreenState();
}

class CompanyCvScreenState extends State<CompanyCvScreen> {
  bool isLoading = true;
  bool isEnd = false;
  int page = 1;
  List<Employees> workers = [];
  getData() async {
    if (isEnd) {
      List<Employees> list =
          await CompaniesService().getCompanyCvs(id: widget.id, page: page);
      workers.addAll(list);
      isEnd = list.isEmpty;
      setState(() {});
    }
  }

  getCv() async {
    List<Employees> list =
        await CompaniesService().getCompanyCvs(id: widget.id, page: page);
    workers.addAll(list);
    isEnd = list.isEmpty;
    isLoading = false;
    setState(() {});
  }

  deleteCv(String? cvId) async {
    isLoading = true;
    setState(() {});
    await CompaniesService().deleteCv(id: widget.id, workerid: cvId);
    workers.clear();
    page = 1;
    getCv();
  }

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getCv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
      ),
      body: LazyLoadScrollView(
        onEndOfPage: () {
          if (isEnd) {
            page++;
            getData();
          }
        },
        child: isLoading
            ? const Loader()
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: workers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: EmployeesCards(
                        data: workers[index],
                        name:
                            Localizations.localeOf(context).languageCode == "en"
                                ? workers[index].nameEn ?? ""
                                : workers[index].nameAr ?? "",
                        img: workers[index].image1 ?? "",
                        phone: workers[index].mobile ?? "",
                        job:
                            Localizations.localeOf(context).languageCode == "en"
                                ? "${workers[index].occupation?.titleEn}"
                                : "${workers[index].occupation?.titleAr}",
                        country:
                            Localizations.localeOf(context).languageCode == "en"
                                ? workers[index].residence?.titleEn ?? ""
                                : workers[index].residence?.titleAr ?? "",
                        isCompany: true,
                        onDelete: () {
                          deleteCv(workers[index].workerId);
                        },
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
