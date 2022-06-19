// ignore_for_file: file_names

import 'package:bahrain_manpower/Global/theme.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Pages/Jobs/jobdetails.dart';
import 'package:bahrain_manpower/models/other/vacancy.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/jobsService.dart';
import 'package:bahrain_manpower/widgets/loader.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  JobsScreenState createState() => JobsScreenState();
}

class JobsScreenState extends State<JobsScreen> {
  List<Vacancy> jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getJobs();
  }

  getJobs() async {
    jobs = await JobsService().getJobs();
    isLoading = false;
    setState(() {});
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
                  scale: 4, fit: BoxFit.scaleDown))),
      body: isLoading
          ? const Loader()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              itemCount: jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    pushPage(
                        context,
                        JobsDetailsScreen(
                          job: jobs[index],
                        ));
                  },
                  child: Card(
                    child: SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(jobs[index].title??"",style: const TextStyle(fontSize: 19),),
                      )),
                  ),
                );
              },
            ),
    );
  }
}
