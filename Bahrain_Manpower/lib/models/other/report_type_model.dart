import 'dart:convert';

List<ReportType> reportTypeFromJson(String str) => List<ReportType>.from(json.decode(str).map((x) => ReportType.fromJson(x)));

String reportTypeToJson(List<ReportType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportType {
  ReportType({
    this.id,
    this.titleen,
    this.titlear,
    this.oid,
    this.publish,
    this.created,
  });

  String? id;
  String? titleen;
  String? titlear;
  String? oid;
  String? publish;
  String? created;

  factory ReportType.fromJson(Map<String, dynamic> json) => ReportType(
    id: json["id"],
    titleen: json["titleen"],
    titlear: json["titlear"],
    oid: json["oid"],
    publish: json["publish"],
    created: json["created"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "titleen": titleen,
    "titlear": titlear,
    "oid": oid,
    "publish": publish,
    "created": created,
  };
}
