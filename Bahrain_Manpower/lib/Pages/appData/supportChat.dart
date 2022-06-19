// ignore_for_file: file_names, unused_field

import 'package:bahrain_manpower/Global/theme.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({Key? key}) : super(key: key);

  @override
  SupportChatPageState createState() => SupportChatPageState();
}

class SupportChatPageState extends State<SupportChatPage> {
  late WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme:  IconThemeData(color: mainOrangeColor),
          backgroundColor: offWhite,
        ),
        body: WebView(
          initialUrl: 'https://tawk.to/chat/6078259af7ce1827093ab3f2/1f3al5p6d',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) async {
            _controller = webViewController;

            //I've left out some of the code needed for a webview to work here, fyi
          },
        ),

    );
  }
}
