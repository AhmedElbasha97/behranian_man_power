// ignore_for_file: use_build_context_synchronously, file_names

import 'package:bahrain_manpower/Global/Settings.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/client/myCVs.dart';
import 'package:bahrain_manpower/models/AppInfo/Filters.dart' as filter;
import 'package:bahrain_manpower/models/AppInfo/paymentData.dart';
import 'package:bahrain_manpower/models/Companies/Employees.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/appDataService.dart';
import 'package:bahrain_manpower/services/workersService.dart';
import 'package:bahrain_manpower/widgets/Employees/employeesListCard.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeesScreen extends StatefulWidget {
  final String? id;

  const EmployeesScreen({Key? key, this.id, }) : super(key: key);

  @override
  EmployeesScreenState createState() => EmployeesScreenState();
}

class EmployeesScreenState extends State<EmployeesScreen> {
  bool isLoading = true;
  bool loadingMoreData = false;
  bool loadingFilters= true;
  bool isExpand = false;
   late filter.FiltersData data;
  List<Employees> workers = [];
  int page = 1;
  bool isEnd = false;
   filter.Occupation? selectedJob;
   filter.Religion? selectedReligion;
   filter.Status? selectedStatus;
   filter.Residence? selectedCity;
   filter.Nationality? selectedNationality;
    PaymentData payment = PaymentData();

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   var type = prefs.getString("type");
   var id = prefs.getString("id");

    workers = await WorkerService().getWorker(
        userId:type=="company"?id:"",
        id: widget.id??"",
        page: page,
        occupationId: selectedJob?.occupationId ?? "",
        residenceId: selectedCity?.residenceId ?? "",
        religionId: selectedReligion?.religionId ?? "",
        nationalityId: selectedNationality?.nationalityId ?? "",
        statusId: selectedStatus?.statusId ?? "");
    isLoading = false;
    setState(() {});
    getDataOfFilters();
  }
  getDataOfFilters() async {
    payment = await AppDataService().getPaymentData();
    data = await AppDataService().getFilters();
    loadingFilters=false;
    setState(() {});
  }

  getWorkers() async {
    if (!isEnd) {
      setState(() {
        loadingMoreData = true;
      });
      List<Employees> list = await WorkerService().getWorker(
          id: widget.id??"",
          page: page,
          occupationId: selectedJob?.occupationId ?? "",
          residenceId: selectedCity?.residenceId ?? "",
          religionId: selectedReligion?.religionId ?? "",
          nationalityId: selectedNationality?.nationalityId ?? "",
          statusId: selectedStatus?.statusId ?? "");
      workers.addAll(list);
      isEnd = list.isEmpty;
      loadingMoreData=false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
        centerTitle: true,
        title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icon/logoAppBar.png",
                scale: 8, fit: BoxFit.scaleDown)),
      ),
      body: isLoading
          ? const Loader()
          : LazyLoadScrollView(
              scrollOffset: 300,
              onEndOfPage: () {
                if (!isEnd) {
                  page++;
                  getWorkers();
                }
              },
              child: ListView(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          loadingFilters?Container() :ExpansionTile(
                              collapsedBackgroundColor: mainOrangeColor,
                              initiallyExpanded: isExpand,
                              onExpansionChanged: (value) {
                                setState(() {
                                  isExpand = value;
                                });
                              },
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color:
                                        isExpand ? mainBlueColor : Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        ?.translate('searchEmployee')??"",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: isExpand
                                            ? mainBlueColor
                                            : Colors.white),
                                  ),
                                ],
                              ),
                              children: [
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3.5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(
                                      color:  Colors.grey,
                                    ),
                                  ),
                                  child: DropdownButton<filter.Occupation>(
                                    isExpanded: true,
                                    isDense: true,
                                    hint: Text(
                                        selectedJob == null
                                            ? AppLocalizations.of(context)
                                                ?.translate('job')??""
                                            : selectedJob!.occupationName??"",
                                        style: const TextStyle(
                                          fontSize: 13,
                                            color: Colors.grey
                                        )),
                                    underline: const SizedBox(),
                                    items: data.occupation!
                                        .map<
                                            DropdownMenuItem<
                                                filter.Occupation>>((value) =>
                                            DropdownMenuItem<
                                                filter.Occupation>(
                                              value: value,
                                              child: Text(
                                                  Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? value.occupationNameEn??""
                                                      : value.occupationName??"",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                      color: Colors.grey
                                                  )),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      isLoading = true;
                                      setState(() {});
                                      selectedJob = value;
                                      getData();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3.5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(
                                        color: Colors.grey,
                                    ),
                                  ),
                                  child: DropdownButton<filter.Religion>(
                                    isDense: true,
                                    isExpanded: true,
                                    hint: Text(
                                        selectedReligion == null
                                            ? AppLocalizations.of(context)
                                                ?.translate('religion')??""
                                            : selectedReligion!.religionName??"",
                                        style: const TextStyle(
                                          fontSize: 13,
                                            color: Colors.grey
                                        )),
                                    underline: const SizedBox(),
                                    items: data.religion!
                                        .map<DropdownMenuItem<filter.Religion>>(
                                            (value) => DropdownMenuItem<
                                                    filter.Religion>(
                                                  value: value,
                                                  child: Text(
                                                      Localizations.localeOf(
                                                                      context)
                                                                  .languageCode ==
                                                              "en"
                                                          ? value.religionNameEn??""
                                                          : value.religionName??"",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                      )),
                                                ))
                                        .toList(),
                                    onChanged: (value) {
                                      isLoading = true;
                                      setState(() {});
                                      selectedReligion = value;
                                      getData();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3.5),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(5)),
                                      border: Border.all(
                                          color: Colors.grey,
                                      ),
                                    ),
                                    child: DropdownButton<filter.Status>(
                                      isDense: true,
                                      isExpanded: true,
                                      hint: Text(
                                          selectedStatus == null
                                              ? AppLocalizations.of(context)
                                                  ?.translate('socialStatus')??""
                                              : selectedStatus!.statusName??"",
                                          style: const TextStyle(
                                            fontSize: 13,
                                              color: Colors.grey
                                          )),
                                      underline: const SizedBox(),
                                      items: data.status!
                                          .map<DropdownMenuItem<filter.Status>>(
                                              (value) => DropdownMenuItem<
                                                      filter.Status>(
                                                    value: value,
                                                    child: Text(
                                                        Localizations.localeOf(
                                                                        context)
                                                                    .languageCode ==
                                                                "en"
                                                            ? value.statusNameEn??""
                                                            : value.statusName??"",
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        )),
                                                  ))
                                          .toList(),
                                      onChanged: (value) {
                                        isLoading = true;
                                        setState(() {});
                                        selectedStatus = value;
                                        getData();
                                      },
                                    )),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3.5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(
                                        color: Colors.grey,
                                    ),
                                  ),
                                  child: DropdownButton<filter.Residence>(
                                    isDense: true,
                                    isExpanded: true,
                                    hint: Text(
                                        selectedCity == null
                                            ? AppLocalizations.of(context)
                                                ?.translate('city')??""
                                            : selectedCity!.residenceName??"",
                                        style: const TextStyle(
                                          fontSize: 13,
                                        )),
                                    underline: const SizedBox(),
                                    items: data.residence!
                                        .map<
                                            DropdownMenuItem<
                                                filter.Residence>>((value) =>
                                            DropdownMenuItem<
                                                filter.Residence>(
                                              value: value,
                                              child: Text(
                                                  Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? value.residenceNameEn??""
                                                      : value.residenceName??"",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                      color: Colors.grey,
                                                  )),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      selectedCity = value;
                                      isLoading = true;
                                      setState(() {});
                                      getData();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3.5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(
                                        color: Colors.grey,
                                    ),
                                  ),
                                  child: DropdownButton<filter.Nationality>(
                                    isDense: true,
                                    isExpanded: true,
                                    hint: Text(
                                        selectedNationality == null
                                            ? AppLocalizations.of(context)
                                                ?.translate('nationality')??""
                                            : selectedNationality!
                                                .nationalityName??"",
                                        style: const TextStyle(
                                          fontSize: 13,
                                            color: Colors.grey,
                                        )),
                                    underline: const SizedBox(),
                                    items: data.nationality!
                                        .map<
                                            DropdownMenuItem<
                                                filter.Nationality>>((value) =>
                                            DropdownMenuItem<
                                                filter.Nationality>(
                                              value: value,
                                              child: Text(
                                                  Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? value.nationalityNameEn??""
                                                      : value.nationalityName??"",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                      color: Colors.grey
                                                  )),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      selectedNationality = value;
                                      isLoading = true;
                                      setState(() {});
                                      getData();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                      itemCount: loadingMoreData?workers.length+1:workers.length,
                      itemBuilder: (BuildContext context, int index) {

                        return  loadingMoreData&&index==workers.length?Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.22,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [
                                Text(Localizations.localeOf(context).languageCode == "en" ?"Loading":"جاري التحميل"),
                                const SizedBox(width: 10,),
                                const CircularProgressIndicator()

                              ],
                            ),
                          ),
                        ):Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: EmployeesCards(
                            isFavorite: workers[index].favourite??false,
                              amount: payment.viewConatcts??"",
                              data: workers[index],
                              name: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? workers[index].nameEn ?? ""
                                  : workers[index].nameAr ?? "",
                              img: workers[index].image1 ?? "",
                              phone: "${workers[index].mobile}",
                              job: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? workers[index].occupation?.titleEn ?? ""
                                  : workers[index].occupation?.titleAr ?? "",
                              country: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? workers[index].residence?.titleEn ?? ""
                                  : workers[index].residence?.titleAr ?? "",
                              onagree: () {
                                isLoading = true;
                                setState(() {});
                                requestCv("${workers[index].workerId}");
                              }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
