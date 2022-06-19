// ignore_for_file: unnecessary_const

import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Global/widgets/MainButton.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/CVs/AddCVScreen.dart';
import 'package:bahrain_manpower/Pages/auth/logIn_screen.dart';
import 'package:bahrain_manpower/Pages/auth/signUpScreen.dart';
import 'package:bahrain_manpower/Pages/companies/SignUpCompany.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Image.asset(
                "assets/icon/logo.png",
                scale: 8, fit: BoxFit.scaleDown
              ),
              Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
              Container(
                width: MediaQuery.of(context).size.width,
              ),
              MainButton(
                label:
                    "${AppLocalizations.of(context)?.translate('addUserAccount')}",
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ClientSignUp()));
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              MainButton(
                label:
                    "${AppLocalizations.of(context)?.translate('addCompanyAccount')}",
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const CompanySignUp()));
                },
              ),
              const Padding(padding: const EdgeInsets.only(top: 10)),
              MainButton(
                label:
                    "${AppLocalizations.of(context)?.translate('addEmpolyeeAccount')}",
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddCvScreen()));
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(Localizations.localeOf(context).languageCode == "en"
                     ?"if you already have an account":"اذا كان لديك حساب"),
                 const SizedBox(width: 5,),
                 InkWell(
                   onTap: (){
                     pushPage(context, const LogInScreen());
                   },
                   child: Text(Localizations.localeOf(context).languageCode == "en"
    ?"you can sign in":"يمكنك تسجيل الدخول", style: const TextStyle(
                     color: Colors.blue
                   ),),
                 ),
               ],
             )
            ],
          )
        ],
      ),
    );
  }
}
