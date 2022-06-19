import 'package:flutter/material.dart';
import 'package:bahrain_manpower/models/chat/chat_list.dart';
import 'chatting_cell.dart';
class MessagesList extends StatelessWidget {
   const MessagesList({Key? key, required this.listOfMessages, required this.userID, }) : super(key: key);
   final List<Message> listOfMessages ;
   final String userID;



  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:  const EdgeInsets.symmetric(horizontal: 10),
        decoration:  const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius:  const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child:Padding(
            padding:  const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: listOfMessages.length,
                itemBuilder: (context, int index) {
                  return Column(
                    children: [
                      ChattingCell(messageText: listOfMessages[index].message!, sender: listOfMessages[index].companyId==userID?true:false, messageTime: listOfMessages[index].time!,),


                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
