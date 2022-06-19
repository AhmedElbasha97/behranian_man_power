import 'package:bahrain_manpower/Global/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/models/AppInfo/about.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/appDataService.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/loader.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  AboutAppScreenState createState() => AboutAppScreenState();
}

class AboutAppScreenState extends State<AboutAppScreen> {
   late About data;
  bool loading = true;

  getData() async {
    data = await AppDataService().getabout();
    loading = false;
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
        title: Text("${AppLocalizations.of(context)?.translate('aboutApp')}",
            style: const TextStyle(
              color: Color(0xFF0671bf),
            )),
        centerTitle: true,
      ),
      body: Scaffold(
        body: loading
            ? const Loader()
            : ListView(
                children: [
                  const SizedBox(height: 10,),
                  Center(child: Text("${data.title}",style: const TextStyle(fontWeight: FontWeight.bold))),
                  Padding(
                    padding: const EdgeInsets.only(right: 40, left: 20),
                    child: Html(data: "${data.text}"),
                  ),
                  InkWell(
                    onTap: () {
                      launchURL("${data.video}");
                    },
                    child: Center(
                        child: Text("${data.video}",
                            style: const TextStyle(color: Colors.blueAccent))),
                  )
                ],
              ),
      ),
    );
  }
}
