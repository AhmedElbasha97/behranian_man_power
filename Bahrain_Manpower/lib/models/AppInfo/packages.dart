class PackagesModel {
  PackagesModel({
    this.packageId,
    this.titleAr,
    this.titleEn,
    this.value,
    this.featuresAr,
    this.featuresEn,
  });

  String? packageId;
  String? titleAr;
  String? titleEn;
  String? value;
  String? featuresAr;
  String? featuresEn;

  factory PackagesModel.fromJson(Map<String, dynamic> json) => PackagesModel(
        packageId: json["package_id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
        value: json["value"],
    featuresAr: json["features_ar"],
    featuresEn: json["features_en"],

      );
}
