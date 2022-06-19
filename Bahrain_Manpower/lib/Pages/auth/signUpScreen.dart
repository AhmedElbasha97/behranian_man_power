// ignore_for_file: use_build_context_synchronously, file_names, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:bahrain_manpower/Pages/searchForEmplyee.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Global/widgets/MainInputFiled.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/appData/Privacy_police_screen.dart';
import 'package:bahrain_manpower/Pages/appData/terms_condition_screren.dart';
import 'package:bahrain_manpower/models/other/authresult.dart';
import 'package:bahrain_manpower/services/AuthService.dart';
import 'package:bahrain_manpower/widgets/loader.dart';

class ClientSignUp extends StatefulWidget {
  const ClientSignUp({Key? key}) : super(key: key);

  @override
  ClientSignUpState createState() => ClientSignUpState();
}

class ClientSignUpState extends State<ClientSignUp> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

   File? img;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  var val ;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          iconTheme:  IconThemeData(color: mainOrangeColor),
          backgroundColor: offWhite,
        ),
        body: isLoading
            ?const Loader()
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 50),
                  MainInputFiled(
                    label: "${AppLocalizations.of(context)?.translate('name')}",
                    inputType: TextInputType.text,
                    controller: _nameController,
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
                  const SizedBox(height: 25),
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
                  const SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      if(val==1) {
                        signUp();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color:val==1? mainOrangeColor:Colors.grey),
                      child: Text(
                          "${AppLocalizations.of(context)?.translate('signUp')}",
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ));
  }

  signUp() async {
    isLoading = true;
    setState(() {});
    AuthResult? result = await AuthService().createAccount(
      name: _nameController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      mobile: _mobileController.text,
      email: _emailController.text,
    );
    if (result?.status == "success") {
      final snackBar = SnackBar(
          content: Text(
              "${AppLocalizations.of(context)?.translate('signinSuccessMsg')}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      pushPageReplacement(context, const SearchForEmployee());
    } else {
      final snackBar = SnackBar(
          content: Text(Localizations.localeOf(context).languageCode == "en"
              ? result?.messageEn??""
              : result?.messageAr??""));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    isLoading = false;
    setState(() {});
  }
}
