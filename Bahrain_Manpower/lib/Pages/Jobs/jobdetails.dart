import 'package:bahrain_manpower/Global/theme.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/models/other/vacancy.dart';

class JobsDetailsScreen extends StatefulWidget {
  final Vacancy? job;
  const JobsDetailsScreen({Key? key, this.job}) : super(key: key);
  @override
  JobsDetailsScreenState createState() => JobsDetailsScreenState();
}

class JobsDetailsScreenState extends State<JobsDetailsScreen> {
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
                  scale: 8, fit: BoxFit.scaleDown))),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        children: [
          Text(
            widget.job?.title ?? "",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Text(
            widget.job?.details ?? "",
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${AppLocalizations.of(context)?.translate('joblocation')} :${widget.job?.jobLocation ?? " "}",
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${AppLocalizations.of(context)?.translate('jobtype')} :${widget.job?.jobType ?? ""}",
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${AppLocalizations.of(context)?.translate('monthlySalary')} :${widget.job?.salary ?? ""}",
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${AppLocalizations.of(context)?.translate('notes')} :${widget.job?.notes ??""}",
            style: const TextStyle(
              fontSize: 17,
            ),
          )
        ],
      ),
    );
  }
}
