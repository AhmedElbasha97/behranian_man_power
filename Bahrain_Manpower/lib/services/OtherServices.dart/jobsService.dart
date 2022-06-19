// ignore_for_file: file_names, avoid_print

import 'package:dio/dio.dart';
import 'package:bahrain_manpower/Global/Settings.dart';
import 'package:bahrain_manpower/models/other/vacancy.dart';

class JobsService {
  String jobs = "list/jobs";
  String newJob = "new/job";

  Future<List<Vacancy>> getJobs() async {
    Response response;
    List<Vacancy> list = [];
    response = await Dio().post('$baseUrl$jobs');
    response.data.forEach((element) {
      list.add(Vacancy.fromJson(element));
    });

    return list;
  }

  Future<bool> addnewJob(
      { String? title,
       String? details,
       String? salary,
       int? jobtype,
       String? note,
       String? location}) async {
    try {
      var body = FormData.fromMap({
        "title": title,
        "details": details,
        "salary": salary,
        "job_type": "$jobtype",
        "job_location": location,
        "notes": note
      });
      Response response = await Dio().post('$baseUrl$newJob', data: body);
      print(response.data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
