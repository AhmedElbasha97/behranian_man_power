
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:intl/intl.dart';
import 'package:bahrain_manpower/models/chat/chat-user_list.dart';


class ChatUserCard extends StatelessWidget {
  const ChatUserCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  final Datum? chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical:10),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage:chat?.picpath != null ? chat?.picpath != "https://manpower-kw.com/uploads/no-image-available.jpg" ? chat?.picpath != "https://manpower-kw.com/uploads/0" ?NetworkImage(chat?.picpath??""):const AssetImage("assets/icon/employerPlaceHolder.png")as ImageProvider:const AssetImage("assets/icon/employerPlaceHolder.png"):const AssetImage("assets/icon/employerPlaceHolder.png"),
                ),
                if (chat?.isRead=="0"?true:false)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: mainOrangeColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ?chat?.name??"":chat?.namear??"",
                      style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        chat?.lastMessage??"",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: chat?.isRead=="1"?FontWeight.bold:FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity: 0.64,
                          child: Text(
                            chat?.lastMessageDate??"",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        chat?.lastMessageTime=="0"?Opacity(
                          opacity: 0.64,
                          child: Text(
                              DateFormat.jm().format(DateFormat("hh:mm:ss").parse(chat?.lastMessageTime==""?"00:00:00":chat?.lastMessageTime??"")),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ):const SizedBox(),

                      ],
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}