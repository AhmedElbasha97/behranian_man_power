import 'dart:convert';

UserList uesrListFromJson(String str) => UserList.fromJson(json.decode(str));

String uesrListToJson(UserList data) => json.encode(data.toJson());

class UserList {
  UserList({
    this.status,
    this.data,
  });

  String? status;
  List<Datum>? data;

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
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
    this.companyId,
    this.name,
    this.namear,
    this.chatId,
    this.lastMessage,
    this.lastMessageDate,
    this.lastMessageTime,
    this.isRead,
    this.picpath,
  });

  String? companyId;
  String? name;
  String? namear;
  String? chatId;
  String? lastMessage;
  String? lastMessageDate;
  String? lastMessageTime;
  String? isRead;
  String? picpath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    companyId: json["company_id"],
    name: json["name"],
    namear: json["namear"],
    chatId: json["chat_id"],
    lastMessage: json["last_message"],
    lastMessageDate: json["last_message_date"],
    lastMessageTime: json["last_message_time"],
    isRead: json["is_read"],
    picpath: json["picpath"],
  );

  Map<String, dynamic> toJson() => {
    "company_id": companyId,
    "name": name,
    "namear": namear,
    "chat_id": chatId,
    "last_message": lastMessage,
    "last_message_date": lastMessageDate,
    "last_message_time": lastMessageTime,
    "is_read": isRead,
    "picpath": picpath,
  };
}
