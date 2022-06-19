// ignore_for_file: file_names

import 'package:bahrain_manpower/Global/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:bahrain_manpower/models/other/privacy_policy_model.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/appDataService.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool isLoading =true;
  late PrivacyPolicyModel  data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData() async {
    data =await AppDataService().getPrivacyPolicy();
    isLoading = false;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
        title: Text(
          Localizations.localeOf(context).languageCode == "en"
              ? "privacy policy"
              : "سياسة خاصة",
          style: const TextStyle(color: Color(0xFF0671bf)),
        ),
        centerTitle: true,
      ),
      body:  isLoading
          ? const Loader()
          :Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? data.titleEn ?? ""
                          : data.titleAr ?? ""),
                  Padding(
                    padding: const EdgeInsets.only(right: 40, left: 20),
                    child: Html(data:Localizations.localeOf(context).languageCode == "en"
                        ? data.detailsEn ?? ""
                        : data.detailsAr ?? "") ,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
