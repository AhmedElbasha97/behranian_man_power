class Company {
  Company(
      {this.companyId,
      this.companyName,
      this.address,
      this.categoryId,
      this.categoryName,
      this.companymobile,
      this.details,
      this.picpath,
      this.workers,
      this.slider,
      this.social,
      this.clicks,
      this.ratingNo,
      this.map,
        this.whatsapp,
      this.rating});

  String? companyId;
  String? companyName;
  String? address;
  String? categoryId;
  String? categoryName;
  String? companymobile;
  String? details;
  String? picpath;
  String? workers;
  Slider? slider;
  Social? social;
  Clicks? clicks;
  String? rating;
  String? ratingNo;
  String? map;
  String? whatsapp;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        companyId: json["company_id"],
        companyName: json["company_name"],
        address: json["address"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        companymobile: json["companymobile"],
        details: json["details"],
    whatsapp:json["whatsapp"],
        picpath: json["picpath"],
        workers: json["workers"],
        slider: Slider.fromJson(json["slider"]),
        social: Social.fromJson(json["social"]),
        rating: "${json['rating']}",
        ratingNo: "${json['ratingNo']}",
        map: "${json['map']}",
        clicks: json["clicks"] == null ? null : Clicks.fromJson(json["clicks"]),

      );
}

class Slider {
  Slider({
    this.picpath,
    this.picpath2,
    this.picpath3,
  });

  String? picpath;
  String? picpath2;
  String? picpath3;

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
        picpath: json["picpath"],
        picpath2: json["picpath2"],
        picpath3: json["picpath3"],
      );
}

class Social {
  Social({
    this.twitter,
    this.facebook,
    this.youtube,
    this.instagram,
  });

  String? twitter;
  String? facebook;
  String? youtube;
  String? instagram;

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        twitter: json["twitter"],
        facebook: json["facebook"],
        youtube: json["youtube"],
        instagram: json["instagram"],
      );
}

class Clicks {
  Clicks(
      {this.facebook,
      this.twitter,
      this.youtube,
      this.instagram,
      this.chat,
      this.mobile,
      this.whatsapp});

  String? facebook;
  String? twitter;
  String? youtube;
  String? instagram;
  String? chat;
  String? mobile;
  String? whatsapp;

  factory Clicks.fromJson(Map<String, dynamic> json) => Clicks(
        facebook: json["facebook"],
        twitter: json["twitter"],
        youtube: json["youtube"],
        instagram: json["instagram"],
        chat: json["chat"],
        whatsapp: json["whatsapp"],
        mobile: json["mobile"],
      );
}
