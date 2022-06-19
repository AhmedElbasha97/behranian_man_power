// ignore_for_file: empty_catches, unused_local_variable

import 'package:dio/dio.dart';
import 'package:bahrain_manpower/Global/Settings.dart';
import 'package:bahrain_manpower/models/other/report_type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportServices{
  final reportTypeEndPoint="report/list";
  final sendingReport="report";
  Future<List<ReportType>?> getListOfReportType() async {
    try {
      Response response;
      List<ReportType> result=[];

      response = await Dio().get('$baseUrl$reportTypeEndPoint');
      var data = response.data;
      data.forEach((element) {
        result.add(ReportType.fromJson(element));
      });
      return result;
    } catch (e) {
    }
    return null;
  }
  sendReport( String employerId, String comment, String reportTypeId ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("id") ?? "";
    var body = {"report_list_id ": reportTypeId,"company_id":userId,"worker_id":employerId,"comment":comment};
   var  response = await Dio().post('$baseUrl$sendingReport', data: body);

  }

}