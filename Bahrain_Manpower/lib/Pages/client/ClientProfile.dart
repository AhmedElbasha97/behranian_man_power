// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Global/widgets/MainDrawer.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/ChatingScreen/chats_list_screen.dart';
import 'package:bahrain_manpower/Pages/appData/packagesScreen.dart';
import 'package:bahrain_manpower/Pages/auth/edit_profile_screen.dart';
import 'package:bahrain_manpower/Pages/client/ClientWallet.dart';
import 'package:bahrain_manpower/Pages/client/myFavCvs.dart';
import 'package:bahrain_manpower/models/client/userClient.dart';
import 'package:bahrain_manpower/services/AuthService.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({Key? key}) : super(key: key);

  @override
  ClientProfileScreenState createState() => ClientProfileScreenState();
}

class ClientProfileScreenState extends State<ClientProfileScreen> {
   UserClientModel? data;
  bool isLoading = true;
   String? id;
   String? type;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id");
    type = prefs.getString("type");
    data = (await AuthService().getClientAccount(id: id));
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getData();
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
                scale: 4.5, fit: BoxFit.scaleDown)),
      ),
      drawer: isLoading ? Container() : MainDrawer(id, type),
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
                          backgroundColor: mainOrangeColor,
                          backgroundImage: const AssetImage("assets/icon/employerPlaceHolder.png",),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.grey[300],
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
                                  TextStyle(fontSize: 14, color: mainBlueColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${data!.username}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
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
                              "${AppLocalizations.of(context)?.translate('name')}:",
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
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? "${data!.nameEn}"
                                  : "${data!.nameEn}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: mainOrangeColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[300],
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
                              data!.balance ?? "",
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
                              "${AppLocalizations.of(context)?.translate('mobile')}:",
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
                              data!.mobile ?? "",
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
                    color: Colors.grey[300],
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
                                  TextStyle(fontSize: 14, color: mainBlueColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data!.email ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('packages')}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.payment,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, const PackagesScreen());
                      }),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('cvs')}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor,
                        ),
                        child: const Icon(
                          Icons.people,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        // pushPage(context, PackagesScreen());
                      }),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('editProfile')}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, ClientEditProfile(data: data));
                      }),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('messages')}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor,
                        ),
                        child: const Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, const ChatsListScreen());
                      }),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('paymentHistory')}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor,
                        ),
                        child: const Icon(
                          Icons.money_outlined,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, const TransactionScreen());
                      }),
                  ListTile(
                      tileColor: mainBlueColor,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('favCv')}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor,
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.heart,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        pushPage(context, const MyFavCvsScreen());
                      })
                ],
              ),
            ),
    );
  }
}
