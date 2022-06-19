// ignore_for_file: prefer_is_empty, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Pages/ChatingScreen/chating_screen.dart';
import 'package:bahrain_manpower/Pages/ChatingScreen/widget/user_chat_cell.dart';
import 'package:bahrain_manpower/models/chat/chat-user_list.dart';
import 'package:bahrain_manpower/services/chat_services.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/loader.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({Key? key}) : super(key: key);

  @override
  ChatsListScreenState createState() => ChatsListScreenState();
}

class ChatsListScreenState extends State<ChatsListScreen> {
  bool isLoading = true;
  late List<Datum>? userChatList;
  getAllListOfChat()async{
    final userList= await ChatServiceList().listAllUserChat();
    userChatList = userList.data;
    isLoading=false;
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getAllListOfChat();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
        title: Text(
          Localizations.localeOf(context).languageCode == "en"
              ?"chat list":"قيمة الدردشات",
          style: TextStyle(color: mainOrangeColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: mainOrangeColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:isLoading?const Loader(): userChatList?.length==0||userChatList==null?
      SizedBox(
          height: MediaQuery.of(context).size.height ,
          width: MediaQuery.of(context).size.width,
          child: Column(
        children: [
          Image.asset("assets/icon/chat_holde.png"),
          const SizedBox(height: 20,),
          Text(Localizations.localeOf(context).languageCode == "en"
              ?"no chat available":"لا يوجد دردشة متوفره لان",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20

          ),),
        ],
    ),
      ) :ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: userChatList?.length,
          itemBuilder: (context, int index) {
           return ChatUserCard(press: () async {

             if(userChatList?[index].isRead=="0"){

              var response = await ChatServiceList().markAsRead(userChatList?[index].chatId??"");

              if(response.data['status'] == "success"){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  ChattingScreen(reciverId: userChatList?[index].companyId??"",)),
                ).then((value){

                getAllListOfChat();
                  setState(() {

                  });
                });
              }
             }else{
             Navigator.push(
             context,
             MaterialPageRoute(builder: (context) =>  ChattingScreen(reciverId: userChatList?[index].companyId??"",)),
           );} },chat: userChatList?[index] );
    }),
    );
  }
}
