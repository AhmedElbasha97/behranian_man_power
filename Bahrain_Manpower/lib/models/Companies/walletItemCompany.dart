class CompanyWalletItem {
  CompanyWalletItem({
    this.id,
    this.amount,
    this.notes,
    this.expiration,
    this.created,
  });

  String? id;
  String? amount;
  String? notes;
  String? expiration;
  String? created;

  factory CompanyWalletItem.fromJson(Map<String, dynamic> json) =>
      CompanyWalletItem(
        id: json["id"],
        amount: json["amount"],
        notes: json["notes"],
        expiration: json["expiration"],
        created: json["created"],
      );
}
