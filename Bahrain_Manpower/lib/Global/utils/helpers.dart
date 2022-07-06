// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/I10n/AppLanguage.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/appData/terms_screen.dart';
import 'package:bahrain_manpower/Pages/auth/logIn_screen.dart';
import 'package:bahrain_manpower/Pages/welcome_screen.dart';
import 'package:bahrain_manpower/services/chatService.dart';
import 'package:bahrain_manpower/widgets/button_widget.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:provider/provider.dart';


launchURL(String url) async {try {
  await launch(
    url,
    customTabsOption: CustomTabsOption(
      toolbarColor: mainOrangeColor,
      enableDefaultShare: true,
      enableUrlBarHiding: true,
      showPageTitle: true,
      animation: CustomTabsSystemAnimation.slideIn(),
      extraCustomTabs: const <String>[
        // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
        'org.mozilla.firefox',
        // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
        'com.microsoft.emmx',
      ],
    ),
    safariVCOption: SafariViewControllerOption(
      preferredBarTintColor: mainOrangeColor,
      preferredControlTintColor: Colors.white,
      barCollapsingEnabled: true,
      entersReaderIfAvailable: false,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
    ),
  );
} catch (e) {
  // An exception is thrown if browser app is not installed on Android device.
  debugPrint(e.toString());
}

  // WebView(
  //   initialUrl: url,
  //   javascriptMode: JavascriptMode.unrestricted,
  // );
  // if (await launchUrl(Uri.parse(url),mode: LaunchMode.inAppWebView)) {
  // } else {
  //   throw 'Could not launch $url';
  // }
}

changeLangPopUp(BuildContext context) {
  var appLanguage = Provider.of<AppLanguage>(context);
  return CupertinoActionSheet(
    title: Text('${AppLocalizations.of(context)?.translate('language')}'),
    message:
        Text('${AppLocalizations.of(context)?.translate('changeLanguage')}'),
    actions: <Widget>[
      CupertinoActionSheetAction(
        child: const Text('English'),
        onPressed: () {
          appLanguage.changeLanguage(const Locale("en"));
          Navigator.pop(context);
        },
      ),
      CupertinoActionSheetAction(
        child: const Text('عربى'),
        onPressed: () {
          appLanguage.changeLanguage(const Locale("ar"));
          Navigator.pop(context);
        },
      )
    ],
    cancelButton: CupertinoActionSheetAction(
      isDefaultAction: true,
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
      child:  const Text('رجوع'),
    ),
  );
}

List<T?> map<T>(List list, Function handler) {
  List<T?> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}



showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('تسجيل الدخول'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('قم بتسجيل الدخول لتتمكن من إتمام عملية التسجيل.'),
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: const Text(
                'تسجيل الدخول',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LogInScreen(),
                ));
              },
            ),
          ),
          Center(
            child: TextButton(
              child: const Text('مستخدم جديد',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ));
              },
            ),
          ),
          Center(
            child: TextButton(
              child:
                  const Text('رجوع', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      );
    },
  );
}

///////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////
/// Page Navigation pages
////////////////////////////////////////////////
void popPage(BuildContext context) {
  Navigator.of(context).pop();
}

void pushPage(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void pushPageReplacement(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

////////////////////////////////////////////////
/// utilities
////////////////////////////////////////////////
bool emailvalidator(String email) {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  return emailValid;
}

////////////////////////////////////////////////
////////////////////////////////////////////////

void showTheDialog(BuildContext context, String title, String body,
    { Widget extraAction = const SizedBox()}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      List<Widget> actions = [];
      actions.add(
        TextButton(
          child: Text(AppLocalizations.of(context)?.translate('back')??""),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
      actions.add(extraAction);
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        title: Text(title == "" ? "" : title),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Column(
            children: <Widget>[
              Text(body == "" ? "" : body),
            ],
          ),
        ),
        actions: actions,
      );
    },
  );
}

void showMsgDialog(BuildContext context, String? clientId, String workerId) {
  bool chatloading = false;
  final TextEditingController textEditingController =
      TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5)),
                      color: Colors.white),
                  child: Row(
                    children: <Widget>[
                      // Text input
                      Flexible(
                        child: TextField(
                          textInputAction: TextInputAction.send,
                          onEditingComplete: () async {
                            if (textEditingController.text.isNotEmpty) {
                              chatloading = true;
                              setState(() {});
                              await ChatService().sendMessage(workerId,
                                  clientId, textEditingController.text);
                              textEditingController.clear();
                              chatloading = false;
                              setState(() {});
                              popPage(context);
                            }
                          },
                          style: const TextStyle(fontSize: 15.0),
                          controller: textEditingController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                ?.translate('typeMsg'),
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      // Send Message Button
                      Material(
                        color: Colors.white,
                        child: Container(
                          child: chatloading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: () async {
                                    if (textEditingController.text.isNotEmpty) {
                                      chatloading = true;
                                      setState(() {});
                                      await ChatService().sendMessage(workerId,
                                          clientId, textEditingController.text);
                                      textEditingController.clear();
                                      chatloading = false;
                                      setState(() {});
                                      popPage(context);
                                    }
                                  },
                                  color: const Color(0xFF184e7a),
                                ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
    },
  );
}

void showPaymentDialog(BuildContext context, Function onpay, String amount) {
  bool isAgree = false;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${AppLocalizations.of(context)?.translate('paymentMsg')} $amount KWD",
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        pushPage(context, const TermsScreen());
                      },
                      child: Text(
                        AppLocalizations.of(context)?.translate('termsAgree')??"",
                        style: const TextStyle(color: Colors.blue, fontSize: 13),
                      ),
                    ),
                    Checkbox(
                      value: isAgree,
                      onChanged: ( value) {
                        setState(() {
                          isAgree = value??false;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        if (isAgree) {
                          onpay();
                        }
                      },
                      background: mainOrangeColor,
                      text: AppLocalizations.of(context)?.translate('agree')??"",
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.3,

                    ),
                   CustomElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      background: Colors.red,
                      text: AppLocalizations.of(context)?.translate('cancel')??"",
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.3,

                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
    },
  );
}
