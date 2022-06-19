// ignore_for_file: unnecessary_string_interpolations, unused_catch_clause, empty_catches, no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bahrain_manpower/Global/Settings.dart';
import 'package:bahrain_manpower/models/client/userClient.dart';
import 'package:bahrain_manpower/models/other/authresult.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String loginLink = "login";
  String loginwoker = "/worker";
  String signUp = "signup/client";
  String editProfile = "set/client/info";
  String clientProfile = "client/profile";
  String notificationTokenUrl ="update/token";
  Future<Response> sendUserTokenOfNotification(String userId,String notificationToken) async {
    Response response;
    var body =FormData.fromMap({
      "company_id":"$userId","token":"$notificationToken"
    });
    response = await Dio()
        .post("$baseUrl$notificationTokenUrl", data:body);
   return response;

  }
  Future<AuthResult?> login(
      { String? username,  String? password,  String? type}) async {
    AuthResult result;
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String link = "$baseUrl$loginLink";
    if (type == "worker") {
      link += loginwoker;
    }
    try {
      response = await Dio()
          .post(link, data: {"username": "$username", "password": "$password"});
      result = AuthResult.fromJson(response.data);
      if (response.data != null &&
          response.data != "" &&
          response.data['status'] == "success") {
        prefs.setString("type", type!);
        prefs.setString(
            "id",
            type == "client"
                ? response.data["data"]["memberid"]
                : type == "worker"
                    ? response.data["data"]["workerid"]
                    : response.data["data"]["companyid"]);
        prefs.setString(
            "name",
            type == "client"
                ? response.data["data"]["username"]
                : response.data["data"]["name"]);
        if (type == "company") {
          prefs.setString("image", response.data["data"]["picpath"]);
          prefs.setString('companyData', jsonEncode(response.data));
        }
        FirebaseMessaging.instance.getToken().then((token) async {
          var _= await sendUserTokenOfNotification(type == "worker"
              ? response.data["data"]["workerid"]
              :response.data["data"]["companyid"],token!);


        });




      }

      return result;
    } on DioError catch (e) {

    }
    return null;
  }

  Future<AuthResult?> createAccount(
      { String? name,
       String? username,
       String? password,
       String? mobile,
       String? email}) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthResult result;

    try {
      response = await Dio().post("$baseUrl$signUp", data: {
        "name": "$name",
        "username": "$username",
        "mobile": "$mobile",
        "email": "$email",
        "password": "$password"
      });
      result = AuthResult.fromJson(response.data);
      if (response.data['status'] == "success" && response.data != null) {
        prefs.setString("type", "client");
        prefs.setString("id", "${response.data['data']['memberid']}");
        prefs.setString("name", "${response.data['data']['username']}");
      }
      FirebaseMessaging.instance.getToken().then((token) async {
        var _= await sendUserTokenOfNotification("${response.data['data']['memberid']}",token!);

      });

      return result;
    } on DioError catch (e) {

    }
    return null;
  }

  Future<AuthResult?> editAccount(
      { String? name,
       String? username,
       String? password,
       String? mobile,
       String? email}) async {
    Response response;
    AuthResult result;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      var data = FormData.fromMap({
        "client_id": "$id",
        "name_en": name,
        "username": username,
        "mobile": mobile,
        "email": email,
        "password": password
      });
      response = await Dio().post("$baseUrl$editProfile", data: data);
      result = AuthResult.fromJson(response.data);
      return result;
    } on DioError catch (e) {
      print('error in LoginService => ${e.response}');

    }
    return null;
  }

  Future<UserClientModel?> getClientAccount({ String? id}) async {
    Response response;
    UserClientModel data;
    try {
      var body = FormData.fromMap({
        "client_id": id,
      });
      response = await Dio().post("$baseUrl$clientProfile", data: body);
      if (response.data['error'] == null && response.data != null) {
        data = UserClientModel.fromJson(response.data);
        return data;
      }
    } on DioError catch (e) {
      print('error in LoginService => ${e.response}');
    }
    return null;
  }
}
