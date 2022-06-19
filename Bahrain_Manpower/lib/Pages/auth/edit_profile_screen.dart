// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/widgets/MainInputFiled.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/client/ClientProfile.dart';
import 'package:bahrain_manpower/models/client/userClient.dart';
import 'package:bahrain_manpower/models/other/authresult.dart';
import 'package:bahrain_manpower/services/AuthService.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/loader.dart';

class ClientEditProfile extends StatefulWidget {
  final UserClientModel? data;
   const ClientEditProfile({ Key? key, this.data }): super(key: key);
  @override
  ClientEditProfileState createState() => ClientEditProfileState();
}

class ClientEditProfileState extends State<ClientEditProfile> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

   File? img;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  fillData() {
    _nameController = TextEditingController(text: widget.data!.nameAr);
    _emailController = TextEditingController(text: widget.data!.email);
    _passwordController = TextEditingController();
    _usernameController = TextEditingController(text: widget.data!.username);
    _mobileController = TextEditingController(text: widget.data!.mobile);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    fillData();
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
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      editProfile();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor),
                      child: Text(
                          "${AppLocalizations.of(context)?.translate('save')}",
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ));
  }

  editProfile() async {
    isLoading = true;
    setState(() {});
    AuthResult? result = await AuthService().editAccount(
      name: _nameController.text == "" ? " " : _nameController.text,
      username:
          _usernameController.text == "" ? " " : _usernameController.text,
      password:
          _passwordController.text == "" ? " " : _passwordController.text,
      mobile: _mobileController.text == "" ? " " : _mobileController.text,
      email: _emailController.text == "" ? " " : _emailController.text,
    );
    if (result?.status == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ClientProfileScreen(),
      ));
    } else {
      final snackBar = SnackBar(
          content: Text(Localizations.localeOf(context).languageCode == "en"
              ? result?.messageEn??""
              : result?.messageAr??""));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    isLoading = false;
    setState(() {});
  }
}
