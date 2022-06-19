// To parse this JSON data, do
//
//     final massageList = massageListFromJson(jsonString);

import 'dart:convert';

MassageList massageListFromJson(String str) => MassageList.fromJson(json.decode(str));

String massageListToJson(MassageList data) => json.encode(data.toJson());

class MassageList {
  MassageList({
    this.status,
    this.date,
  });

  String? status;
  List<Date>? date;

  factory MassageList.fromJson(Map<String, dynamic> json) => MassageList(
    status: json["status"],
    date: json["date"] == null ? null : List<Date>.from(json["date"].map((x) => Date.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "date": date == null ? null : List<dynamic>.from(date!.map((x) => x.toJson())),
  };
}

class Date {
  Date({
    this.chatId,
    this.created,
    this.messages,
  });

  String? chatId;
  String? created;
  List<Message>? messages;

  factory Date.fromJson(Map<String, dynamic> json) => Date(
    chatId: json["chat_id"],
    created: json["created"],
    messages: json["messages"] == null ? null : List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "chat_id": chatId,
    "created": created,
    "messages": messages == null ? null : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    this.messageId,
    this.companyId,
    this.message,
    this.created,this.time,
  });

  String? messageId;
  String? companyId;
  String? message;
  String? created;
  String? time;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    messageId: json["message_id"],
    companyId: json["company_id"],
    message: json["message"],
    created: json["created"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "message_id": messageId,
    "company_id": companyId,
    "message": message,
    "created": created,
    "time": time,
  };
}
