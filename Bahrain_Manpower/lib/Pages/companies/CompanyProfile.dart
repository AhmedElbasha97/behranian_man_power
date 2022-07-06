// ignore_for_file: file_names

import 'package:bahrain_manpower/Global/Settings.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Global/widgets/MainDrawer.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/CVs/AddCVScreen.dart';
import 'package:bahrain_manpower/Pages/companies/CompanyCVs.dart';
import 'package:bahrain_manpower/Pages/companies/CompanyEditProfile.dart';
import 'package:bahrain_manpower/Pages/companies/companyWallet.dart';
import 'package:bahrain_manpower/models/Companies/companyInfo.dart';
import 'package:bahrain_manpower/services/Companies/CompaniesService.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({Key? key}) : super(key: key);

  @override
  CompanyProfileScreenState createState() => CompanyProfileScreenState();
}

class CompanyProfileScreenState extends State<CompanyProfileScreen> {
   CompanyInfo? info;
  bool isLoading = true;
   String? type;
   String? id;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString("type");
    id = prefs.getString("id");

    info = await CompaniesService().getCompanyInfo(id);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
      ),
      drawer: MainDrawer(id, type),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView(
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                          info?.data?.image1!="${url}uploads/0"&&info?.data?.image1!=null?NetworkImage("${info?.data?.image1}"):const AssetImage('assets/icon/companyplaceholder.png') as ImageProvider,
                        ),
                        Text(
                          Localizations.localeOf(context).languageCode == "en" ? info!.data?.nameAr??"ليس متوفر اسم الشركة بالعربي" : info!.data?.nameEn??"no english name available",
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('editProfile')}",
                        style: const TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color:mainOrangeColor,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, CompanyEditProfile(info));
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('addCv')}",
                        style: const TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color:mainOrangeColor,
                        ),
                        child: const Icon(
                          Icons.file_present,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(
                            context,
                            AddCvScreen(
                              id: id,
                            ));
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('payPackage')}",
                        style: const TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color:mainOrangeColor,
                        ),
                        child: const Icon(
                          Icons.payment,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        launchURL(
                            "${url}StripePayment/form?company_id=${info!.data!.companyId}");
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('cvCompany')}",
                        style: const TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color:mainOrangeColor,
                        ),
                        child: const Icon(
                          Icons.file_copy,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(
                            context,
                            CompanyCvScreen(
                              id: id,
                            ));
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('paymentHistory')}",
                        style: const TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color:mainOrangeColor,
                        ),
                        child: const Icon(
                          Icons.money_outlined,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, const TransactionScreen());
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.grey[400],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${AppLocalizations.of(context)?.translate('subscription')}:",
                              style:
                                  TextStyle(fontSize: 14, color: mainBlueColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${info?.data?.expiration ?? AppLocalizations.of(context)?.translate('noSub')}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${AppLocalizations.of(context)?.translate('specialty')}:",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey[400]),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${Localizations.localeOf(context).languageCode == "en" ? info!.data?.categoryNameEn : info!.data?.categoryNameAr ?? ""}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[400],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${AppLocalizations.of(context)?.translate('balance')}:",
                              style:
                                  TextStyle(fontSize: 14, color: mainBlueColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              info!.data?.balance ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${AppLocalizations.of(context)?.translate('username')}:",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey[400]),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              info!.data?.username ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[400],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${AppLocalizations.of(context)?.translate('address')}:",
                              style:
                                  TextStyle(fontSize: 14, color: mainBlueColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              info!.data?.address ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${Localizations.localeOf(context).languageCode == "en" ? info!.data?.detailsEn : info!.data?.detailsAr ?? ""}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey[400]),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[400],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              info!.data?.tel ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${AppLocalizations.of(context)?.translate('email')}:",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey[400]),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              info!.data?.email ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }
}
