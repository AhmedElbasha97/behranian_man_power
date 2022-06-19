// ignore_for_file: file_names, avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:bahrain_manpower/Global/Settings.dart';
import 'package:bahrain_manpower/models/other/authresult.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendCvService {
  String sendCvLink = "add/worker";
  String editWorker = "edit/workers";

  Future<AuthResult?> sendCv(
      String name,
      String nameEn,
      String jobId,
      String nationality,
      String cityId,
      String religion,
      String gender,
      String email,
      String whatsapp,
      String mobile,
      String password,
      String userName,
      String weight,
      String height,
      String childrenNo,
      List<String> education,
      List<String> languages,
      List<String> skills,
      String contractPeriod,
      String salary,
      String birthDate,
      String passportNumber,
      String experience,
      String passportDate,
      String passportEndDate,
      File? img1,
      File? img2,
      File? img3,
      [String? id = "0",
      bool isEdit = false]) async {
    AuthResult? result;

    print({
      "company_id": id,
      "name_en": name,
      "name_ar": nameEn,
      "occupation_id": jobId,
      "nationality_id": nationality,
      "residence_id": cityId,
      "religion_id": religion,
      "marital_status_id": 1,
      "gender_id": gender,
      "contract_period": contractPeriod,
      "salary": salary,
      "birth_date": birthDate,
      "experience": experience,
      "passport_no": passportNumber,
      "passport_date": passportDate,
      "passport_exp_date": passportEndDate,
      "skills": skills.toString(),
      "languages": languages.toString(),
      "education": education.toString(),
      "children": childrenNo,
      "length": height,
      "weight": weight,
      "username": userName,
      "password": password,
      "mobile": mobile,
      "whatsapp": whatsapp,
      "email": email,
      "image1": img1 == null
          ? null
          : await MultipartFile.fromFile(
              img1.path,
            ),
      "image2": img2 == null
          ? null
          : await MultipartFile.fromFile(
              img2.path,
            ),
      "image3": img3 == null
          ? null
          : await MultipartFile.fromFile(
              img3.path,
            ),
    });
    var data = FormData.fromMap({
      "company_id": id,
      "name_en": name,
      "name_ar": nameEn,
      "occupation_id": jobId,
      "nationality_id": nationality,
      "residence_id": cityId,
      "religion_id": religion,
      "marital_status_id": 1,
      "gender_id": gender,
      "contract_period": contractPeriod,
      "salary": salary,
      "birth_date": birthDate,
      "experience": experience,
      "passport_no": passportNumber,
      "passport_date": passportDate,
      "passport_exp_date": passportEndDate,
      "skills": skills,
      "languages": languages,
      "education": education,
      "children": childrenNo,
      "length": height,
      "weight": weight,
      "username": userName,
      "password": password,
      "mobile": mobile,
      "whatsapp": whatsapp,
      "email": email,
      "image1": img1 == null
          ? null
          : await MultipartFile.fromFile(
              img1.path,
            ),
      "image2": img2 == null
          ? null
          : await MultipartFile.fromFile(
              img2.path,
            ),
      "image3": img3 == null
          ? null
          : await MultipartFile.fromFile(
              img3.path,
            ),
    });
    try {
      Response response;
      response = await Dio()
          .post('$baseUrl${isEdit ? editWorker : sendCvLink}', data: data);
      result = AuthResult.fromJson(response.data);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (response.data != null && response.data['status'] == "success") {
        if (id == "0" && isEdit == false) {
          preferences.setString("id", response.data["data"]["workerid"]);
          preferences.setString("type", "worker");
        }
      }

      return result;

    } catch (e) {
      return result;
    }
  }
}
