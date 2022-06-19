
// ignore_for_file: use_build_context_synchronously, file_names

import 'package:bahrain_manpower/Pages/Notification/notification_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/CVs/AddCVScreen.dart';
import 'package:bahrain_manpower/Pages/Empolyees/empolyeeProfile.dart';
import 'package:bahrain_manpower/Pages/Jobs/JobsScreen.dart';
import 'package:bahrain_manpower/Pages/Jobs/addNewJob.dart';
import 'package:bahrain_manpower/Pages/appData/about_app_screen.dart';
import 'package:bahrain_manpower/Pages/appData/supportChat.dart';
import 'package:bahrain_manpower/Pages/auth/logIn_screen.dart';
import 'package:bahrain_manpower/Pages/client/ClientProfile.dart';
import 'package:bahrain_manpower/Pages/companies/CompanyProfile.dart';
import 'package:bahrain_manpower/Pages/searchForCompany.dart';
import 'package:bahrain_manpower/Pages/searchForEmplyee.dart';
import 'package:bahrain_manpower/Pages/welcome_screen.dart';
import 'package:bahrain_manpower/selectSection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Pages/ChatingScreen/chats_list_screen.dart';
import '../utils/helpers.dart';

// ignore: must_be_immutable
class MainDrawer extends StatefulWidget {
  String? id;
  String? type;
  MainDrawer(this.id, this.type, {Key? key}) : super(key: key);
  @override
  MainDrawerState createState() => MainDrawerState();
}

class MainDrawerState extends State<MainDrawer> {
   String? name;
   String? token;
   String? facebookUrl;
   String? whatsappUrl;
   String? instagramUrl;
   String? youtubeUrl;
   String? twitterUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      color: Colors.grey[300],
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
          SizedBox(
            height: 100,
            child: Container(
              color: Colors.white,
              child: Image.asset(
                "assets/icon/logo.png",
                scale: 3,
              ),
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('searchEmployee')}",
                  style: const TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.purple,
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pushPage(context, const SearchForEmployee());
                }),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('companies')}",
                  style: const TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.orange,
                  ),
                  child: const Icon(
                    Icons.business,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pushPage(context, const CompanySearchScreen());
                }),
          ),
          widget.id != null
              ? Container()
              : Container(
                  color: Colors.white,
                  child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('uploadCv')}",
                        style: const TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.redAccent,
                        ),
                        child: const Icon(
                          Icons.file_upload,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddCvScreen(),
                        ));
                      }),
                ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('addJob')}",
                  style: const TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.greenAccent,
                  ),
                  child: const Icon(
                    Icons.add_business,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddNewJobScreen(),
                  ));
                }),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('newJobs')}",
                  style: const TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.brown,
                  ),
                  child: const Icon(
                    Icons.business_center_outlined,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const JobsScreen(),
                  ));
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          widget.id != null
              ? Container(
                  color: Colors.white,
                  child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('myAccount')}",
                        style: const TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blueGrey,
                        ),
                        child: const Icon(
                          Icons.account_box,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => widget.type == "company"
                              ? const CompanyProfileScreen()
                              : widget.type == "worker"
                                  ? const EmployeeProfile()
                                  : const ClientProfileScreen(),
                        ));
                      }),
                )
              : Container(),
          widget.id != null
              ? Container(
                  color: Colors.white,
                  child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('signOut')}",
                        style: const TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blueGrey,
                        ),
                        child: const Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();
                        pushPageReplacement(context, const SelectSections());
                      }),
                )
              : Container(),
          widget.id == null
              ? Container(
                  color: Colors.white,
                  child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('login')}",
                        style: const TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.greenAccent,
                        ),
                        child: const Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, const LogInScreen());
                      }),
                )
              : Container(),
          widget.id == null
              ? Container(
                  color: Colors.white,
                  child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        "${AppLocalizations.of(context)?.translate('signUp')}",
                        style: const TextStyle(
                            color: Color(0xFF0671bf),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        textScaleFactor: 1.0,
                      ),
                      leading: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.purpleAccent,
                        ),
                        child: const Icon(
                          Icons.people_sharp,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        pushPage(context, const WelcomeScreen());
                      }),
                )
              : Container(),
          widget.id != null?Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  Localizations.localeOf(context).languageCode == "en"
                      ?"chat":"الدردشات",
                  style: const TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.orange,
                  ),
                  child: const Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChatsListScreen(),
                  ));
                }),
          ):const SizedBox(),
          widget.id != null?Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  Localizations.localeOf(context).languageCode == "en"
                      ?"Notification":"التنبيهات",
                  style: const TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.orange,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NotificationsListScreen(),
                  ));
                }),
          ):const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('support')}",
                  style: const TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.orange,
                  ),
                  child: const Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SupportChatPage(),
                  ));
                }),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('whoAreWe')}",
                  style: const TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.indigo,
                  ),
                  child: const Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AboutAppScreen(),
                  ));
                }),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('share')}",
                  style: const TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.greenAccent,
                  ),
                  child: const Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Share.share(Platform.isAndroid
                  //              ? "https://play.google.com/store/apps/details?id=com.syncapps.manpower"
                  //              : "https://apps.apple.com/us/app/id1573160692",);

                }),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                title: Text(
                  "${AppLocalizations.of(context)?.translate('changeLang')}",
                  style: const TextStyle(
                      color: Color(0xFF0671bf),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                ),
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.red,
                  ),
                  child: const Icon(
                    Icons.language_sharp,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) =>
                          changeLangPopUp(context));
                }),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
              InkWell(
                onTap: () => launchURL("$facebookUrl"),
                child: Image.asset(
                  "assets/icon/facebook.png",
                  scale: 1.5,
                ),
              ),
              InkWell(
                onTap: () => launchURL("$instagramUrl"),
                child: Image.asset(
                  "assets/icon/instagram.png",
                  scale: 1.5,
                ),
              ),
              InkWell(
                onTap: () => launchURL("$twitterUrl"),
                child: Image.asset(
                  "assets/icon/twitter.png",
                  scale: 1.5,
                ),
              ),
              InkWell(
                onTap: () => launchURL("https://wa.me/$whatsappUrl"),
                child: Image.asset(
                  "assets/icon/whatsapp.png",
                  scale: 1.5,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "${AppLocalizations.of(context)?.translate('policy1')}",
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text("${AppLocalizations.of(context)?.translate('policy2')}",
                    style: const TextStyle(fontSize: 16)),
                InkWell(
                  onTap: () => launchURL("https://syncqatar.com"),
                  child: const Text(
                    "سينك",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      ),
    );
  }
}
