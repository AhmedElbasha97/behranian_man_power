class UserClientModel {
  UserClientModel({
    this.clientId,
    this.nameAr,
    this.nameEn,
    this.mobile,
    this.username,
    this.email,
    this.balance,
    this.tel,
    this.whatsapp,
    this.detailsAr,
    this.detailsEn,
  });

  String? clientId;
  String? nameAr;
  String? nameEn;
  String? mobile;
  String? username;
  String? email;
  String? balance;
  String? tel;
  String? whatsapp;
  String? detailsAr;
  String? detailsEn;

  factory UserClientModel.fromJson(Map<String, dynamic> json) =>
      UserClientModel(
        clientId: json["client_id"] ?? "",
        nameAr: json["name_ar"] ?? "",
        nameEn: json["name_en"] ?? "",
        mobile: json["mobile"] ?? "",
        username: json["username"] ?? "",
        email: json["email"] ?? "",
        balance: json["balance"] ?? "",
        tel: json["tel"] ?? "",
        whatsapp: json["whatsapp"] ?? "",
        detailsAr: json["details_ar"] ?? "",
        detailsEn: json["details_en"] ?? "",
      );
}
