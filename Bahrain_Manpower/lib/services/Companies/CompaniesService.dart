// ignore_for_file: file_names, unused_catch_clause, empty_catches, prefer_adjacent_string_concatenation, avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:bahrain_manpower/models/Companies/Categories.dart';
import 'package:bahrain_manpower/models/Companies/Employees.dart' as company;
import 'package:bahrain_manpower/models/Companies/company.dart';
import 'package:bahrain_manpower/models/Companies/companyInfo.dart';
import 'package:bahrain_manpower/models/Companies/statistics_model.dart';
import 'package:bahrain_manpower/models/Companies/walletItemCompany.dart';
import 'package:bahrain_manpower/models/other/authresult.dart';
import 'package:bahrain_manpower/models/other/rating.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Global/Settings.dart';

class CompaniesService {
  String companies = "ar/companies/category";
  String categories = "ar/companies/categories";
  String employees = "ar/workers/company";
  String login = "login";
  String signup = "signup/company";
  String info = "company/profile";
  String deleteCvLink = "delete/workers";
  String socialMediaClicks = "clicks";
  String transations = "transaction";
  String editProfile = "set/company/info";

  Future<List<Categories>> getCategories() async {
    Response response;
    List<Categories> list = [];
    try {
      response = await Dio().get('$baseUrl$categories');
      var data = response.data;
      data.forEach((element) {
        list.add(Categories.fromJson(element));
      });
    } on DioError catch (e) {
    }
    return list;
  }Future<Rating?> getRating(String companyId) async {
    Response response;
    Rating? rate ;
    try {
      response = await Dio().get('http://manpower-kw.com/api/rating/$companyId');
      var data = response.data;
      rate =Rating.fromJson(data);
    } on DioError catch (e) {
    }
    return rate;
  }Future<StatisticsModel?> getStatistics(String companyId) async {
    Response response;
    StatisticsModel? statistics ;
    try {
      response = await Dio().get('http://manpower-kw.com/api/statistics/$companyId');
      var data = response.data;
      statistics =StatisticsModel.fromJson(data);
    } on DioError catch (e) {
    }
    return statistics;
  }

  Future<List<Company>> getCompanies(String id,
      {int page = 1, String searchKey = ""}) async {
    Response response;
    List<Company> list = [];
    try {
      response = await Dio()
          .get('$baseUrl$companies/$id/page/$page?keyword=$searchKey');
      var data = response.data;
      data.forEach((element) {
        list.add(Company.fromJson(element));
      });
    } on DioError catch (e) {
    }
    return list;
  }

  Future<List<company.Employees>> getEmployees(String? id,
      {String job = "",
      String nationality = "",
      String religion = "",
      String status = "",
      String city = "",
      String gender = "",
      int page = 1}) async {
    Response response;
    List<company.Employees> list = [];

    response = await Dio().get('$baseUrl$employees/$id' +
        "?occupation_id=$job&nationality_id=$nationality&religion_id=$religion&status_id=$status&gender_id=$gender&residence_id=$city");
    response.data.forEach((element) {
      list.add(company.Employees.fromJson(element));
    });

    return list;
  }

  Future<bool> companyLogin({ String? username,  String? password}) async {
    bool result = false;
    var data = {"username": username, "password": password};
    Response response;
    response = await Dio().post('$baseUrl$login', data: data);
    if (response.data["error"] == null) {
      result = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('companyData', response.data);
    }
    return result;
  }


  Future<AuthResult> companySignUp(
      { String? username,
       String? password,
       String? mobile,
       String? name,
       String? nameEn,
       String? email,
       String? categoryId,
       File? img}) async {
    AuthResult result;
    var data = FormData.fromMap({
      "username": username,
      "password": password,
      "mobile": mobile,
      "name_en": nameEn,
      "name_ar": name,
      "email": email,
      "category_id": categoryId,
      "image": img == null ? null : await MultipartFile.fromFile(img.path),
    });
    Response response;
    response = await Dio().post('$baseUrl$signup', data: data);
    result = AuthResult.fromJson(response.data);
    if ((response.data["error"] == null) &&(response.data["status"]=="success")) {
      SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString('id', '${response.data["data"]["company_id"]}');
      pref.setString('type', "company");
    }
    return result;
  }

  Future<AuthResult> companyeditProfile(
      { String? username,
       String? password,
       String? mobile,
       String? name,
       String? nameEn,
       String? email,
       String? categoryId,
       String? details,
       String? detailsEn,
       String? address,
       String? location,
       File? img,
       File? img1,
       File? img2,
       File? img3}) async {
    AuthResult result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("id") ?? "";
    var data = FormData.fromMap({
      "company_id": userId,
      "username": username,
      "password": password,
      "mobile": mobile,
      "name_en": nameEn,
      "name_ar": name,
      "email": email,
      "category_id": categoryId,
      "location":location,
      "address":address,
      "image": img == null ? null : await MultipartFile.fromFile(img.path),
      "image1": img1 == null ? null : await MultipartFile.fromFile(img1.path),
      "image2": img2 == null ? null : await MultipartFile.fromFile(img2.path),
      "image3": img3 == null ? null : await MultipartFile.fromFile(img3.path),
    });
    Response response;
    response = await Dio().post('$baseUrl$editProfile', data: data);
    result = AuthResult.fromJson(response.data);
    return result;
  }

  Future<CompanyInfo> getCompanyInfo(String? id) async {
    Response response;
    CompanyInfo data;
    var body = FormData.fromMap({"company_id": id});
    response = await Dio().post('$baseUrl$info', data: body);
    data = CompanyInfo.fromJson(response.data);
    return data;
  }

  Future<List<company.Employees>> getCompanyCvs({ String? id,  int? page}) async {
    Response response;
    List<company.Employees> list = [];
    try {
      response = await Dio().get('$baseUrl$employees/$id/page/$page');
      var data = response.data;
      data.forEach((element) {
        list.add(company.Employees.fromJson(element));
      });
    } on DioError catch (e) {
    }
    return list;
  }

  Future<bool> deleteCv({ String? id,  String? workerid}) async {
    bool result = false;
    Response response;
    var body = FormData.fromMap({
      "company_id": id,
      "worker_id": workerid,
    });
    response = await Dio().post('$baseUrl$deleteCvLink', data: body);
    print(response.data);
    if (response.data["status"] == "success") {
      result = true;
    }
    return result;
  }

  Future<CompanyInfo> socialMediaClicked(String? id, String socialMedia) async {
    Response response;
    CompanyInfo data;
    var body = FormData.fromMap({"company_id": id, "social": socialMedia});
    response = await Dio().post('$baseUrl$socialMediaClicks', data: body);
    data = CompanyInfo.fromJson(response.data);
    return data;
  }

  Future<List<CompanyWalletItem>> getTransations() async {
    Response response;
    List<CompanyWalletItem> list = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("id") ?? "";
      var body = {"company_id": userId};
      response = await Dio().post('$baseUrl$transations', data: body);
      List data = response.data;
      data.forEach((element) {
        list.add(CompanyWalletItem.fromJson(element));
      });
    } on DioError catch (e) {


      return [];
    }
    return list;
  }
}
