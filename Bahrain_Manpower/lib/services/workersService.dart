// ignore_for_file: empty_catches, avoid_function_literals_in_foreach_calls, file_names

import 'package:dio/dio.dart';
import 'package:bahrain_manpower/Global/Settings.dart';
import 'package:bahrain_manpower/models/Companies/Employees.dart';
import 'package:bahrain_manpower/models/workers/workersCategories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerService {
  String categories = "ar/workers/categories";
  String worker = "ar/workers/category/";
  String profile = "worker/profile";
  String viewWorkerLink = "view/worker";
  String paidWorkers = "paid/worker";
  String workerByCategory = "ar/workers/companycategory";

  Future<List<WorkersCategory>> getCategories() async {
    Response response;
    List<WorkersCategory> list = [];
    try {
      response = await Dio().get('$baseUrl$categories');
      List data = response.data;
      data.forEach((element) {
        list.add(WorkersCategory.fromJson(element));
      });
    } on DioError {
    }
    return list;
  }

  Future<List<Employees>> getWorker(
      { String? id,
       int? page,
        String? userId,
      String nationalityId = "",
      String occupationId = "",
      String religionId = "",
      String statusId = "",
      String genderId = "",
      String residenceId = ""}) async {
    Response response;
    List<Employees> list = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("id") ?? "";
      response = await Dio().get('$baseUrl$worker$id/page/$page' "?company_id=$userId&occupation_id=$occupationId&nationality_id=$nationalityId&religion_id=$religionId&status_id=$statusId&gender_id=$genderId&residence_id=$residenceId&client_id=$userId");
      List data = response.data;
      data.forEach((element) {
        list.add(Employees.fromJson(element));
      });
    } on DioError {
    }
    return list;
  }

  Future<List<Employees>> getWorkerByCompanyCat({ String? id,  int? page}) async {
    Response response;
    List<Employees> list = [];
    try {
      response = await Dio().get('$baseUrl$workerByCategory/$id/page/$page');
      List data = response.data;
      data.forEach((element) {
        list.add(Employees.fromJson(element));
      });
    } on DioError {
    }
    return list;
  }

  Future<List<Employees>> getPaidWorker() async {
    Response response;
    List<Employees> list = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("id") ?? "";
      var body = {"client_id": userId};
      response = await Dio().post('$baseUrl$paidWorkers', data: body);
      List data = response.data;
      data.forEach((element) {
        list.add(Employees.fromJson(element));
      });
    } on DioError {

      return [];
    }
    return list;
  }

  Future<Employees?> getWorkerProfile({ String? id}) async {
    Response response;
     Employees? worker;
    try {
      var body = {"worker_id": id};
      response = await Dio().post('$baseUrl$profile', data: body);
      var data = response.data;
      worker = Employees.fromJson(data);
    } on DioError {
    }
    return worker;
  }

  Future<bool> viewCv({ String? id}) async {
    bool result = false;
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("id");
    try {
      var body = {"client_id": uid, "worker_id": id};
      response = await Dio().post('$baseUrl$viewWorkerLink', data: body);
      var data = response.data;
      if (data['status'] == "success") {
        result = true;
      }
      return result;
    } on DioError {
      return result;
    }
  }
}
