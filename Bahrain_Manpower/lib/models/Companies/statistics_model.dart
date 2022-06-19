// To parse this JSON data, do
//
//     final rating = ratingFromJson(jsonString);

import 'dart:convert';

StatisticsModel ratingFromJson(String str) => StatisticsModel.fromJson(json.decode(str));

String ratingToJson(StatisticsModel data) => json.encode(data.toJson());

class StatisticsModel {
  StatisticsModel({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory StatisticsModel.fromJson(Map<String, dynamic> json) => StatisticsModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? null : data?.toJson(),
  };
}

class Data {
  Data({
    this.facebook,
    this.twitter,
    this.youtube,
    this.instagram,
    this.chat,
    this.mobile,
    this.whatsapp,
  });

  String? facebook;
  String? twitter;
  String? youtube;
  String? instagram;
  String? chat;
  String? mobile;
  String? whatsapp;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    facebook: json["facebook"],
    twitter: json["twitter"],
    youtube: json["youtube"],
    instagram: json["instagram"],
    chat: json["chat"],
    mobile: json["mobile"],
    whatsapp: json["whatsapp"],
  );

  Map<String, dynamic> toJson() => {
    "facebook": facebook,
    "twitter": twitter,
    "youtube": youtube,
    "instagram": instagram,
    "chat": chat,
    "mobile": mobile,
    "whatsapp": whatsapp,
  };
}
