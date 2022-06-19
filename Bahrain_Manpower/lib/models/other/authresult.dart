class AuthResult {
  AuthResult({
    this.status,
    this.messageEn,
    this.messageAr,
  });

  String? status;
  String? messageEn;
  String? messageAr;

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        status: json["status"],
        messageEn: json["message_en"],
        messageAr: json["message_ar"],
      );
}
