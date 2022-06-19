// ignore_for_file: file_names

class TermsData {
  TermsData({
    this.titleAr,
    this.titleEn,
    this.detailsAr,
    this.detailsEn,
  });

  String? titleAr;
  String? titleEn;
  String? detailsAr;
  String? detailsEn;

  factory TermsData.fromJson(Map<String, dynamic> json) => TermsData(
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
        detailsAr: json["details_ar"],
        detailsEn: json["details_en"],
      );
}
