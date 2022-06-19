// ignore_for_file: avoid_function_literals_in_foreach_calls, file_names

import 'package:dio/dio.dart';
import 'package:bahrain_manpower/models/AppInfo/Filters.dart';
import 'package:bahrain_manpower/models/AppInfo/about.dart';
import 'package:bahrain_manpower/models/AppInfo/homeSilder.dart';
import 'package:bahrain_manpower/models/AppInfo/packages.dart';
import 'package:bahrain_manpower/models/AppInfo/paymentData.dart';
import 'package:bahrain_manpower/models/AppInfo/termsData.dart';
import 'package:bahrain_manpower/models/other/privacy_policy_model.dart';
import '../../Global/Settings.dart';

class AppDataService {
  String slider = "ar/slider";
  String cvTitle = "ar/cv_text";
  String filters = "ar/filters";
  String about = "ar/aboutus";
  String packages = "packages";
  String paymentData = "financial/settings";
  String terms = "terms";
  String rating = "rating";
  Future<List<HomeSlider>> getSliderPhotos() async {
    Response response;
    List<HomeSlider> list = [];
    response = await Dio().get('$baseUrl$slider');
    List data = response.data;
    data.forEach((element) {
      list.add(HomeSlider.fromJson(element));
    });
    return list;
  }

  Future<String?> getCvTitle() async {
    Response response;
    response = await Dio().get('$baseUrl$cvTitle');
    return response.data['title'];
  }

  Future<FiltersData> getFilters() async {
    FiltersData data;
    Response response;
    response = await Dio().get('$baseUrl$filters');
    data = FiltersData.fromJson(response.data);
    return data;
  }

  Future<PaymentData> getPaymentData() async {
    PaymentData data;
    Response response;
    response = await Dio().get('$baseUrl$paymentData');
    data = PaymentData.fromJson(response.data);
    return data;
  }

  Future<TermsData> getTerms() async {
    TermsData data;
    Response response;
    response = await Dio().get('$baseUrl$terms');
    data = TermsData.fromJson(response.data);
    return data;
  }
  Future<PrivacyPolicyModel> getPrivacyPolicy() async {
    PrivacyPolicyModel data;
    Response response;
    response = await Dio().get('http://manpower-kw.com/api/policy');
    data = PrivacyPolicyModel.fromJson(response.data);
    return data;
  }

  Future<PrivacyPolicyModel> getTermsAndCondition() async {
    PrivacyPolicyModel data;
    Response response;
    response = await Dio().get('http://manpower-kw.com/api/terms');
    data = PrivacyPolicyModel.fromJson(response.data);
    return data;
  }

  Future<About> getabout() async {
    About data;
    Response response;
    response = await Dio().get('$baseUrl$about');
    data = About.fromJson(response.data);
    return data;
  }


  Future<List<PackagesModel>> getPackages() async {
    Response response;
    List<PackagesModel> list = [];
    response = await Dio().get('$baseUrl$packages');
    List data = response.data;
    data.forEach((element) {
      list.add(PackagesModel.fromJson(element));
    });
    return list;
  }

  sendRating(String? id, String? rate, String clientId) async {
    Response response;
    var body = FormData.fromMap(

        {"company_id": id, "rate": rate, "client_id": clientId});
    response=await Dio().post('$baseUrl$rating', data: body);
    return response.data["status"];
  }
}
