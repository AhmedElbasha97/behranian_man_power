// To parse this JSON data, do
//
//     final paymentData = paymentDataFromJson(jsonString);

// ignore_for_file: file_names

class PaymentData {
  PaymentData({
    this.subscriptionRenewal,
    this.viewConatcts,
    this.addJob,
  });

  String? subscriptionRenewal;
  String? viewConatcts;
  String? addJob;

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        subscriptionRenewal: json["subscription_renewal"],
        viewConatcts:
            json["view_conatcts"],
        addJob: json["add_job"],
      );
}
