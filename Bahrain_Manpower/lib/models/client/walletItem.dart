class WalletItem {
  WalletItem({
    this.id,
    this.amount,
    this.notes,
    this.workerId,
    this.created,
  });

  String? id;
  String? amount;
  String? notes;
  String? workerId;
  String? created;

  factory WalletItem.fromJson(Map<String, dynamic> json) => WalletItem(
        id: json["id"],
        amount: json["amount"],
        notes: json["notes"],
        workerId: json["worker_id"],
        created: json["created"],
      );
}
