import 'package:flutter/material.dart';
import 'package:bahrain_manpower/models/other/notification_list_model.dart';


class NotificationCell extends StatelessWidget {
  const NotificationCell({Key? key,  required this.notification, required this.press, required this.type}) : super(key: key);
  final Datum notification;
  final VoidCallback press;
  final String type;

  @override
  Widget build(BuildContext context) {
    return  InkWell(

      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade500,width: 1)
            )
        ),
        child:  Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(notification.type=="chat"?"assets/icon/chat_holde.png":notification.type=="update"?"assets/icon/updatePlaceholder.png":type=="company"?"assets/icon/companyplaceholder.png":"assets/icon/employerPlaceHolder.png"),
              ),
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.message??"",
                        style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w500 ),
                        maxLines: null,
                      ),
                      const SizedBox(height: 8),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          notification.created??"",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),

      ),
    );
  }
}