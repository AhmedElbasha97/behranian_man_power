class Chats {
  Chats({
    this.status,
    this.date,
  });

  String? status;
  List<Date>? date;

  factory Chats.fromJson(Map<String, dynamic> json) => Chats(
        status: json["status"],
        date: json["date"] == null
            ? null
            : List<Date>.from(json["date"].map((x) => Date.fromJson(x))),
      );
}

class Date {
  Date({
    this.chatId,
    this.clientId,
    this.workerId,
    this.created,
    this.messages,
  });

  String? chatId;
  String? clientId;
  String? workerId;
  String? created;
  List<Message>? messages;

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        chatId: json["chat_id"],
        clientId: json["client_id"],
        workerId: json["worker_id"],
        created: json["created"],
        messages: json["messages"] == null
            ? null
            : List<Message>.from(
                json["messages"].map((x) => Message.fromJson(x))),
      );
}

class Message {
  Message({
    this.id,
    this.clientId,
    this.workerId,
    this.chatId,
    this.message,
    this.isRead,
    this.created,
  });

  String? id;
  String? clientId;
  String? workerId;
  String? chatId;
  String? message;
  String? isRead;
  String? created;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        clientId: json["client_id"],
        workerId: json["worker_id"],
        chatId: json["chat_id"],
        message: json["message"],
        isRead: json["is_read"],
        created: json["created"],
      );
}
