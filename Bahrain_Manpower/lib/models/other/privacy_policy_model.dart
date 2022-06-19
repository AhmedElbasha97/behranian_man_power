import 'dart:convert';

PrivacyPolicyModel privacyPolicyModelFromJson(String str) => PrivacyPolicyModel.fromJson(json.decode(str));

String privacyPolicyModelToJson(PrivacyPolicyModel data) => json.encode(data.toJson());

class PrivacyPolicyModel {
  PrivacyPolicyModel({
    this.titleAr,
    this.titleEn,
    this.detailsAr,
    this.detailsEn,
  });

  String? titleAr;
  String? titleEn;
  String? detailsAr;
  String? detailsEn;

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) => PrivacyPolicyModel(
    titleAr: json["title_ar"],
    titleEn: json["title_en"],
    detailsAr: json["details_ar"],
    detailsEn: json["details_en"],
  );

  Map<String, dynamic> toJson() => {
    "title_ar": titleAr,
    "title_en": titleEn,
    "details_ar": detailsAr,
    "details_en": detailsEn,
  };
}