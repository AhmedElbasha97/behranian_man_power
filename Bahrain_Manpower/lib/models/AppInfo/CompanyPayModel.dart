import 'dart:convert';

CompanyPayModel companyPayModelFromJson(String str) => CompanyPayModel.fromJson(json.decode(str));

String companyPayModelToJson(CompanyPayModel data) => json.encode(data.toJson());

class CompanyPayModel {
  CompanyPayModel({
    this.status,
    this.pay,
  });

  String? status;
  bool? pay;

  factory CompanyPayModel.fromJson(Map<String, dynamic> json) => CompanyPayModel(
    status: json["status"],
    pay: json["pay"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "pay": pay,
  };
}
