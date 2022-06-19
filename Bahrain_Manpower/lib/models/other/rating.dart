import 'dart:convert';

Rating ratingFromJson(String str) => Rating.fromJson(json.decode(str));

String ratingToJson(Rating data) => json.encode(data.toJson());

class Rating {
  Rating({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
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
    this.rating,
  });

  String? rating;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "rating": rating,
  };
}
