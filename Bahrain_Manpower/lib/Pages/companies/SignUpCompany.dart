// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, file_names

import 'dart:async';
import 'dart:io';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:bahrain_manpower/Pages/searchForEmplyee.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Global/widgets/MainInputFiled.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/appData/Privacy_police_screen.dart';
import 'package:bahrain_manpower/Pages/appData/terms_condition_screren.dart';
import 'package:bahrain_manpower/models/Companies/Categories.dart';
import 'package:bahrain_manpower/models/other/authresult.dart';
import 'package:bahrain_manpower/services/Companies/CompaniesService.dart';
import 'package:bahrain_manpower/widgets/loader.dart';

class CompanySignUp extends StatefulWidget {
  const CompanySignUp({Key? key}) : super(key: key);

  @override
  CompanySignUpState createState() => CompanySignUpState();
}

class CompanySignUpState extends State<CompanySignUp> {
  bool isLoading = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ImageSource imgSrc = ImageSource.gallery;
  final picker = ImagePicker();

  XFile? img;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nameEnController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  List<Categories> categories = [];
  var val;
   Categories? selectedCat;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          iconTheme:  IconThemeData(color: mainOrangeColor),
          backgroundColor: offWhite,
        ),
        body: isLoading
            ? const Loader()
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        bool? done = await selectImageSrc();
                        if (done??false) {
                          getPhoto(imgSrc);
                        }
                        setState(() {});
                      },
                      child: Container(
                        width: 95,
                        height: 95,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: const Color(0xFFB9B9B9)),
                            color: const Color(0xFFF3F3F3)),
                        alignment: Alignment.center,
                        child: img == null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 30,
                              )
                            : Image.file(File(img!.path)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('username')}",
                    inputType: TextInputType.text,
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('password')}",
                    inputType: TextInputType.visiblePassword,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('companyName')}",
                    inputType: TextInputType.name,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('companyNameEn')}",
                    inputType: TextInputType.name,
                    controller: _nameEnController,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('mobile')}",
                    inputType: TextInputType.phone,
                    controller: _mobileController,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label: "${AppLocalizations.of(context)?.translate('email')}",
                    inputType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      showAdaptiveActionSheet(
                        context: context,
                        title: Text(
                          "${AppLocalizations.of(context)?.translate('department')}",
                          textAlign: TextAlign.start,
                        ),
                        actions: categories
                            .map<BottomSheetAction>((Categories value) {
                          return BottomSheetAction(
                              title: Text(
                                '${value.categoryName}',
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 12),
                              ),
                              onPressed: () {
                                selectedCat = value;
                                Navigator.of(context).pop();
                                setState(() {});
                              });
                        }).toList(),
                      );
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: mainOrangeColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            selectedCat == null
                                ? "${AppLocalizations.of(context)?.translate('department')}"
                                : "${selectedCat!.categoryName}",
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.start,
                          ),
                        )),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: val,
                        onChanged: (value) {
                          setState(() {
                            val = value;

                          });
                        },
                        toggleable: true,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              Localizations.localeOf(context).languageCode == "en"
                                  ? "i have read and accept "
                                  : "انا قرأت و اوافق علي "),
                          Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  pushPage(context,
                                      const PrivacyPolicyScreen());
                                },
                                child: Text(
                                  Localizations.localeOf(context).languageCode == "en"
                                      ? "privacy policy"
                                      : "سياسة خاصة",
                                  style: const TextStyle(
                                      color: Colors.blue
                                  ),
                                ),
                              ),
                              Text(
                                  Localizations.localeOf(context).languageCode == "en"
                                      ? " and "
                                      : " و "),
                              InkWell(
                                onTap: (){
                                  pushPage(context,
                                      const TermsAndConditionScreen());
                                },
                                child: Text(
                                  Localizations.localeOf(context).languageCode == "en"
                                      ? "terms and condition"
                                      : "أحكام وشروط",
                                  style: const TextStyle(
                                      color: Colors.blue
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      if(val==1){
                      signUp();}
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: val==1?mainOrangeColor:Colors.grey),
                      child: Text(
                          "${AppLocalizations.of(context)?.translate('done')}",
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ));
  }

  getCategories() async {
    categories = await CompaniesService().getCategories();
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool?> selectImageSrc() async {
    bool? done = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              title: Center(
                  child:
                      Text(AppLocalizations.of(context)?.translate('select')??"")),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.camera_alt),
                          Text(
                              AppLocalizations.of(context)?.translate('camera')??""),
                        ],
                      ),
                      onPressed: () {
                        imgSrc = ImageSource.camera;
                        Navigator.pop(context, true);
                      },
                    ),
                    MaterialButton(
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.photo),
                          Text(
                              AppLocalizations.of(context)?.translate('galary')??""),
                        ],
                      ),
                      onPressed: () {
                        imgSrc = ImageSource.gallery;
                        Navigator.pop(context, true);
                      },
                    )
                  ],
                ),
              ],
            ));
    return done;
  }

  getPhoto(ImageSource src) async {
    final pickedFile = await (picker.pickImage(source: src) );

    img = pickedFile;

    setState(() {});
  }

  signUp() async {
    isLoading = true;
    setState(() {});

    AuthResult result = await CompaniesService().companySignUp(
        username: _usernameController.text,
        password: _passwordController.text,
        mobile: _mobileController.text,
        name: _nameController.text,
        nameEn: _nameEnController.text,
        email: _emailController.text,
        img:img ==null?null:File(img!.path),
        categoryId: selectedCat == null ? "" : selectedCat!.categoryId??"");
    if (result.status == "success") {

      final snackBar = SnackBar(
          content: Text(
              "${AppLocalizations.of(context)?.translate('signinSuccessMsg')}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      pushPageReplacement(context, const SearchForEmployee());
    } else {

      final snackBar = SnackBar(

          content: Text(Localizations.localeOf(context).languageCode == "en"
              ? result.messageEn!
              : result.messageAr!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    isLoading = false;
    setState(() {});
  }
}
