import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Pages/ChatingScreen/widget/messages_list.dart';
import 'package:bahrain_manpower/Pages/ChatingScreen/widget/text_field_chat_bar.dart';
import 'package:bahrain_manpower/models/chat/chat_list.dart';
import 'package:bahrain_manpower/services/chat_services.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Global/Settings.dart';
import '../../Global/utils/helpers.dart';
import '../../services/Companies/CompaniesService.dart';


class ChattingScreen extends StatefulWidget {
 final String reciverId;

  const ChattingScreen({Key? key, required this.reciverId}) : super(key: key);

  @override
  State<ChattingScreen> createState() => ChattingScreenState();
}

class ChattingScreenState extends State<ChattingScreen> {
  final TextEditingController myController = TextEditingController();
  Timer? timer;
  late final String userId;
bool isLoading = true;

  final ChatServiceList services =ChatServiceList();
   late List<Message> listOfMessages ;
   sendMessage(String massage) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     var type = prefs.getString("type");
     var id = prefs.getString("id");
     if(type == "company"){
       var payed = await CompaniesService().getPayed(id!);
       if(!payed!.pay!){
         showPaymentDialog(context,(){
           launchURL(
               "${url}StripePayment/form?company_id=${id}");

         },"10 KD");
       }else{
         MassageList? massageList = await services.sendMassage(
             widget.reciverId, massage);
         listOfMessages = massageList.date![0].messages!;

         setState(() {});
       }
     }else {
       MassageList? massageList = await services.sendMassage(
           widget.reciverId, massage);
       listOfMessages = massageList.date![0].messages!;

       setState(() {});
     }
   }
   getId() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     userId =  prefs.getString("id") ?? "";
   }


  checkForNewMasssageLists() async {
       MassageList massageList = await services.listAllChats(
           widget.reciverId);
       listOfMessages= massageList.date![0].messages!;

       isLoading =false;
       setState(() {
       });

     }

  @override
  void initState() {
    super.initState();
    getId();
    NotificationServices.checkNotificationAppInForeground(context);

    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) => checkForNewMasssageLists());
  }
   @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
        title: Text(
          Localizations.localeOf(context).languageCode == "en"
              ?"chat":"دردشة فورية",
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
//massage list used to display massages
            isLoading?Loader(height: MediaQuery.of(context).size.height*0.79,):MessagesList( listOfMessages: listOfMessages, userID: userId, ),
            //Main widget at the end of screen
           TextFieldChatBar(sendMassage: (value){
             sendMessage(value.toString());

            }, myController: myController,)


          ],
        ),
      ),
    );
  }


   }


