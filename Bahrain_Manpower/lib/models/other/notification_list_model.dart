import 'dart:convert';

NotificationList notificationListFromJson(String str) => NotificationList.fromJson(json.decode(str));

String notificationListToJson(NotificationList data) => json.encode(data.toJson());

class NotificationList {
  NotificationList({
    this.status,
    this.data,
  });

  String? status;
  List<Datum>? data;

  factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
    status: json["status"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.notificationId,
    this.message,
    this.type,
    this.created,
  });

  String? notificationId;
  String? message;
  String? type;
  String? created;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    notificationId: json["notification_id"],
    message: json["message"],
    type: json["type"],
    created: json["created"],
  );

  Map<String, dynamic> toJson() => {
    "notification_id": notificationId,
    "message": message,
    "type": type,
    "created": created,
  };
}
