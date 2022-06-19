// ignore_for_file: use_build_context_synchronously

import 'package:bahrain_manpower/Global/theme.dart';
import 'package:dio/dio.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  ContactUsScreenState createState() => ContactUsScreenState();
}

class ContactUsScreenState extends State<ContactUsScreen> {

   String? phoneTxt;
   String? emailTxt;
  bool isLoading=true;

  getContacts() async{
    Response response = await Dio().get("https://darskhsusy.com/api/settings");
    phoneTxt = response.data['mobile'];
    emailTxt = response.data['email'];
    isLoading=false;
    setState(() {});
  }

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _titleMessageFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _titleMessageController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void unFocusNodes() {
    _emailFocusNode.unfocus();
    _titleMessageFocusNode.unfocus();
    _contentFocusNode.unfocus();
  }

  Future<void> _makePhoneCall(String url) async {
    if (await launchUrl(Uri.parse(url))) {
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
        title: Text(
            "${AppLocalizations.of(context)?.translate('callUs')}",style: const TextStyle(color: Color(0xFF0671bf))),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Color(0xFF0671bf),),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading?const Loader():SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(width: MediaQuery.of(context).size.width,),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+20)),
            const Text("لتسجيل مركز تعليمى او مدرس مستقل",style: TextStyle(color: Colors.green),),

            const Text("اتصل بنا على",style: TextStyle(color: Colors.green),),
            InkWell(
              onTap: () => _makePhoneCall('tel: $phoneTxt'),
              child: Text("$phoneTxt",style: const TextStyle(color: Color(0xFF0671bf)),),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            const Text("او راسلنا على",style: TextStyle(color: Colors.green),),
            Text("$emailTxt",style: const TextStyle(color: Colors.green),),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .padding
                      .top + 10),
            ),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.85,
              child: TextField(
                focusNode: _emailFocusNode,
                controller: _emailController,
                textAlign: Localizations
                    .localeOf(context)
                    .languageCode == "en" ? TextAlign.left : TextAlign
                    .right,
                maxLength: 50,
                maxLines: 2,
                minLines: 1,
                decoration: const InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.only(
                      top: 20,
                      bottom: 1,
                      right: 20,
                      left: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0671bf)),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: "email",
                hintStyle: TextStyle(color: Color(0xFF0671bf))
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.85,
              child: TextField(
                focusNode: _titleMessageFocusNode,
                controller: _titleMessageController,
                textAlign: Localizations
                    .localeOf(context)
                    .languageCode == "en" ? TextAlign.left : TextAlign
                    .right,
                maxLines: 2,
                minLines: 1,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(
                      top: 20,
                      bottom: 1,
                      right: 20,
                      left: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0671bf)),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: "subject"   ,
                    hintStyle: TextStyle(color: Color(0xFF0671bf))                 ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.85,
              child: TextField(
                focusNode: _contentFocusNode,
                controller: _contentController,
                textAlign: Localizations
                    .localeOf(context)
                    .languageCode == "en" ? TextAlign.left : TextAlign
                    .right,
                maxLines: 15,
                minLines: 12,
                decoration: const InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0671bf)),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: "content"     ,
                    hintStyle: TextStyle(color: Color(0xFF0671bf))               ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Center(
              child: InkWell(
                onTap: () async {
                  final Email email = Email(
                    body: _contentController.text,
                    subject: _titleMessageController.text,
                    recipients: ['$emailTxt'],
                    isHTML: false,
                  );

                  await FlutterEmailSender.send(email);
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.075,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "send",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),

          ],
        ),
      ),
    );
  }
}
