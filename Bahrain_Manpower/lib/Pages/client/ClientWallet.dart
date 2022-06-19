// ignore_for_file: file_names

import 'package:bahrain_manpower/Global/theme.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/models/client/walletItem.dart';
import 'package:bahrain_manpower/services/ClientService.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  TransactionScreenState createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  List<WalletItem> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getData();
  }

  getData() async {
    transactions = await ClientService().getTransations();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
      ),
      body: isLoading
          ? const Loader()
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("${transactions[index].created}"),
                    subtitle: Text("${transactions[index].amount}"),
                    trailing: Text("${transactions[index].id}"),
                  ),
                );
              },
            ),
    );
  }
}
