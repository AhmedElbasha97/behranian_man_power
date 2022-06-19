// ignore_for_file: file_names

class CompanyUserModel {
  CompanyUserModel({
    this.companyid,
    this.membership,
    this.userstats,
    this.password,
    this.name,
    this.namear,
    this.expiration,
    this.email,
    this.username,
    this.mobile,
    this.tel,
    this.whatsapp,
    this.address,
    this.map,
    this.detailsAr,
    this.detailsEn,
    this.country,
    this.specialtyid,
    this.specialty,
    this.subscriptionid,
    this.subscriptions,
    this.picpath,
  });

  String? companyid;
  String? membership;
  String? userstats;
  String? password;
  String? name;
  String? namear;
  dynamic expiration;
  String? email;
  String? username;
  String? mobile;
  String? tel;
  String? whatsapp;
  dynamic address;
  String? map;
  dynamic detailsAr;
  dynamic detailsEn;
  String? country;
  String? specialtyid;
  String? specialty;
  String? subscriptionid;
  String? subscriptions;
  String? picpath;

  factory CompanyUserModel.fromJson(Map<String, dynamic> json) =>
      CompanyUserModel(
        companyid: json["companyid"],
        membership: json["membership"],
        userstats: json["userstats"],
        password: json["password"],
        name: json["name"],
        namear: json["namear"],
        expiration: json["expiration"],
        email: json["email"],
        username: json["username"],
        mobile: json["mobile"],
        tel: json["tel"],
        whatsapp: json["whatsapp"],
        address: json["address"],
        map: json["map"],
        detailsAr: json["details_ar"],
        detailsEn: json["details_en"],
        country: json["country"],
        specialtyid: json["specialtyid"],
        specialty: json["specialty"],
        subscriptionid:
            json["subscriptionid"],
        subscriptions:
            json["subscriptions"],
        picpath: json["picpath"],
      );
}
