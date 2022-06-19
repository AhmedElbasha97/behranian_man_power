import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/models/AppInfo/termsData.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/appDataService.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/loader.dart';

class TermsScreen extends StatefulWidget {

  const TermsScreen({Key? key}) : super(key: key);

  @override
  TermsScreenState createState() => TermsScreenState();
}

class TermsScreenState extends State<TermsScreen> {
   TermsData? term;
  bool isLoading = true;

  getTerms() async {
    term = await AppDataService().getTerms();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getTerms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
        title: Text(
          "${AppLocalizations.of(context)?.translate('terms')}",
          style: const TextStyle(color: Color(0xFF0671bf)),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                        Localizations.localeOf(context).languageCode == "en"
                            ? term?.detailsEn ?? ""
                            : term?.detailsAr ?? ""),
                  ),
                ),
              ),
            ),
    );
  }
}
