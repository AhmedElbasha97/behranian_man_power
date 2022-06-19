// ignore_for_file: file_names, unnecessary_null_in_if_null_operators

class Categories {
  Categories({
    this.categoryId,
    this.categoryName,
    this.categoryNameEn,
  });

  String? categoryId;
  String? categoryName;
  String? categoryNameEn;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        categoryId: json["category_id"],
        categoryName:
            json["category_name"] ?? null,
        categoryNameEn:
            json["category_name_en"] ?? null,
      );
}
