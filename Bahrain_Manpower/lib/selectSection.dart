import 'package:bahrain_manpower/Pages/searchForEmplyee.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/CVs/AddCVScreen.dart';
import 'package:bahrain_manpower/Pages/Jobs/addNewJob.dart';

class SelectSections extends StatefulWidget {
  const SelectSections({Key? key}) : super(key: key);

  @override
  SelectSectionsState createState() => SelectSectionsState();
}

class SelectSectionsState extends State<SelectSections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 100)),
          Image.asset(
            "assets/icon/logo.png",
            scale: 2,
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 40)),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddCvScreen(),
              ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: mainOrangeColor),
              child: Text(
                  "${AppLocalizations.of(context)?.translate('uploadCv')}",
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10)),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddNewJobScreen(),
              ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: mainOrangeColor),
              child: Text("${AppLocalizations.of(context)?.translate('addJob')}",
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10)),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SearchForEmployee(),
              ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: mainOrangeColor),
              child: Text(
                  "${AppLocalizations.of(context)?.translate('searchEmployee')}",
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
