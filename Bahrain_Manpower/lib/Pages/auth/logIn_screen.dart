// ignore_for_file: file_names, use_build_context_synchronously

import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/home_screen.dart';
import 'package:bahrain_manpower/models/other/authresult.dart';
import 'package:bahrain_manpower/services/AuthService.dart';
import 'package:flutter/material.dart';


class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  LogInScreenState createState() => LogInScreenState();
}

class LogInScreenState extends State<LogInScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool phoneError = false;
  bool passwordError = false;
  bool isServerLoading = false;
  String selectedType = "company";

  validation(BuildContext context) async {
    if (usernameController.text.isEmpty) {
      phoneError = true;
    } else {
      phoneError = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError = true;
    } else {
      passwordError = false;
    }

    setState(() {});

    if (!phoneError && !passwordError) {
      isServerLoading = true;
      setState(() {});
      AuthResult? result = await AuthService().login(
          username: usernameController.text,
          password: passwordController.text,
          type: selectedType);
      if (result?.status == "success") {
        if (selectedType == "company") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
        }
        if (selectedType == "client") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
        }
      } else {
        final snackBar = SnackBar(
            content: Text(Localizations.localeOf(context).languageCode == "en"
                ? result?.messageEn??""
                : result?.messageAr??""));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      isServerLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme:  IconThemeData(color: mainOrangeColor),
          backgroundColor: offWhite,
          title: Text(
            "${AppLocalizations.of(context)?.translate('login')}",
            style: const TextStyle(color: Color(0xFF0671bf)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF0671bf),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 30)),
                  Image.asset(
                    "assets/icon/logo.png",
                    scale: 3.5,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 30)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0671bf))),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0671bf))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: mainOrangeColor)),
                              hintText:
                                  "${AppLocalizations.of(context)?.translate('username')}"),
                        ),
                      ),
                      phoneError
                          ? const Text(
                              "please enter your phone",
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0671bf))),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0671bf))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: mainOrangeColor)),
                              hintText:
                                  "${AppLocalizations.of(context)?.translate('password')}"),
                        ),
                      ),
                      passwordError
                          ? const Text(
                              "please enter your password",
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        width: MediaQuery.of(context).size.width * 0.8,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            color: mainBlueColor,
                          ),
                        ),
                        child: DropdownButton(
                            isDense: true,
                            isExpanded: true,
                            value: selectedType,
                            hint: Text(
                                AppLocalizations.of(context)
                                    ?.translate('signinAs')??"",
                                style: const TextStyle(
                                  fontSize: 14,
                                )),
                            underline: const SizedBox(),
                            items: [
                              DropdownMenuItem(
                                value: "company",
                                child: Text(
                                    AppLocalizations.of(context)
                                        ?.translate('company')??"",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    )),
                              ),
                              DropdownMenuItem(
                                value: "client",
                                child: Text(
                                    AppLocalizations.of(context)
                                        ?.translate('client')??"",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    )),
                              ),
                              DropdownMenuItem(
                                value: "worker",
                                child: Text(
                                    AppLocalizations.of(context)
                                        ?.translate('worker')??"",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    )),
                              )
                            ],
                            onChanged: (dynamic value) {
                              selectedType = value.toString();
                              setState(() {});
                            }),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 25)),
                      isServerLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : InkWell(
                              onTap: () => validation(context),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                    color: mainOrangeColor),
                                child: Text(
                                    "${AppLocalizations.of(context)?.translate('login')}",
                                    style: const TextStyle(color: Colors.white)),
                              ),
                            )
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}
