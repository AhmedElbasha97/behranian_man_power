// ignore_for_file: use_build_context_synchronously, file_names, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/reportScreen/report_screen.dart';
import 'package:bahrain_manpower/Pages/welcome_screen.dart';
import 'package:bahrain_manpower/models/Companies/Employees.dart';
import 'package:bahrain_manpower/widgets/Employees/bigPicture.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeesScreen extends StatefulWidget {
  final String amount;
  final Employees? data;
  final bool isCompany;
  final Function? onagree;

  const EmployeesScreen(
      {Key? key, this.data, this.isCompany = false, this.onagree, this.amount = ""}) : super(key: key);
  @override
  EmployeesScreenState createState() => EmployeesScreenState();
}

class EmployeesScreenState extends State<EmployeesScreen> {
  List<String?> imgList = [];
  final CarouselController _controller = CarouselController();
  silderdata() {
    if (widget.data != null) {
      if (widget.data!.image1 != null) {

        imgList.add(
          widget.data!.image1,
        );
      }
      if (widget.data!.image2 != null) {

        imgList.add(
          widget.data!.image2,
        );
      }
      if (widget.data!.image3 != null) {

        imgList.add(
          widget.data!.image3,
        );
      }
    }
  }
  void _showDialog(String content,String title,bool signing) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: !signing?Text(Localizations.localeOf(context).languageCode == "en"
                  ?"Close":"اغلق"):Text(Localizations.localeOf(context).languageCode == "en"
                  ?"sign up":"تسجيل دخول",),
              onPressed: () {
                !signing?Navigator.of(context).pop(): pushPage(context, const WelcomeScreen());
              },
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    silderdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
        centerTitle: true,
        title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icon/logoAppBar.png",
                scale: 8, fit: BoxFit.scaleDown)),
      ),
      body: ListView(
        children: [
          CarouselSlider.builder(
            carouselController: _controller,
            itemCount: imgList.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BigPicture(
                        link: imgList[index],
                      ),
                    ));
                  },
                  child: Center(
                      child: CachedNetworkImage(
                        imageUrl: imgList[index]!,
                        fit: BoxFit.cover,
                        width: 1000.0,
                        placeholder: (context, url) => SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Image.asset("assets/icon/employerPlaceHolder.png"),
                        ),
                      ),),
                ),
              );
            },
            options: CarouselOptions(
          autoPlay: true,
          viewportFraction: 1.0,
          height: MediaQuery.of(context).size.height * 0.3,
            ),

          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 100,
                height: 40,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: mainOrangeColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        if (widget.isCompany || widget.data!.isPaid!) {
                          launchURL("https://wa.me/${widget.data?.whatsapp}" +
                              "?text=" +
                              """ 
رأيت العامل/ة في تطبيق مان بور الجنسية - ${widget.data!.nationality!.titleAr} 
(${widget.data!.occupation!.titleAr})
وأريد حجزه / حجزها 

‏Nationality - ${widget.data!.nationality!.titleEn},(${widget.data!.occupation!.titleEn}) in Manpower APP ‏and I want book him / her Link him / her
                          """);
                        } else {
                          showPaymentDialog(context, () {
                            Navigator.of(context).pop();
                            if (widget.onagree != null) {
                              widget.onagree!();
                            }
                          }, widget.amount);
                        }
                      },
                      child: const Text("WhatsApp",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          )),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.isCompany || widget.data!.isPaid!) {
                    launchURL("tel:${widget.data?.company?.mobile}");
                  } else {
                    showPaymentDialog(context, () {
                      Navigator.of(context).pop();
                      if (widget.onagree != null) {
                        widget.onagree!();
                      }
                    }, widget.amount);
                  }
                },
                child: Container(
                  width: 80,
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: mainOrangeColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.phone,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text("${AppLocalizations.of(context)?.translate('call')}",
                          style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if(prefs.containsKey("id")) {
                    pushPage(context,
                        ReportScreen(employerId: widget.data?.workerId ?? "",));
                  }else{
                    _showDialog(Localizations.localeOf(context).languageCode == "en"
                        ?"you must sign in or sign up so you can report this account":"لا بد من انشاء حساب أولا أو تسجيل الدخول لكى تستطيع الابلاغ عن هذا الحساب", Localizations.localeOf(context).languageCode == "en"
                        ?"sorry":"عذرا",true);
                  }
                },
                child: Container(
                  width: 80,
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: mainOrangeColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.flag,
                          size: 20, color: Colors.white),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(Localizations.localeOf(context).languageCode == "en"
                          ?"Report":"الابلاغ",
                          style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String userId = prefs.getString("id") ?? "";
                  if (widget.isCompany || widget.data!.isPaid!) {
                    showMsgDialog(context, widget.data!.workerId, userId);
                  } else {
                    showPaymentDialog(context, () {
                      Navigator.of(context).pop();
                      if (widget.onagree != null) {
                        widget.onagree!();
                      }
                    }, widget.amount);
                  }
                },
                child: Container(
                  width: 80,
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: mainOrangeColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.commentAlt,
                          size: 20, color: Colors.white),
                      const SizedBox(
                        width: 5,
                      ),
                      Text("${AppLocalizations.of(context)?.translate('chat')}",
                          style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('name')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? widget.data?.nameEn ?? ""
                          : widget.data?.nameAr ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('job')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? widget.data?.occupation?.titleEn ?? ""
                          : widget.data?.occupation?.titleAr ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('contractTime')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data?.contractPeriod ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('exp')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data?.experience ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('birthday')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.data?.birthDate}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('monthlySalary')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data?.salary ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: widget.data!.language!.isEmpty
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('language')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.data?.language?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? widget.data?.language![index].titleEn??""
                                  : widget.data?.language![index].titleAr??"",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            );
                          },
                        ),
                      )
                    ],
                  ),
          ),
          Container(
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('nationality')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? widget.data?.nationality?.titleEn ?? ""
                          : widget.data?.nationality?.titleAr ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: widget.data!.skills!.isEmpty
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('skills')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.data?.skills?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? "${widget.data?.skills![index].titleEn}"
                                  : "${widget.data?.skills![index].titleAr}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            );
                          },
                        ),
                      )
                    ],
                  ),
          ),
          Container(
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('socialStatus')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? widget.data?.status?.titleEn ?? ""
                          : widget.data?.status?.titleAr ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('city')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? widget.data?.residence?.titleEn ?? ""
                          : widget.data?.residence?.titleAr ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: widget.data!.education!.isEmpty
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('certificates')}:",
                            style:
                                TextStyle(fontSize: 14, color: mainBlueColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 30,
                        child: ListView.builder(
                          itemCount: widget.data?.education?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? widget.data?.education![index].titleEn ?? ""
                                  : widget.data?.education![index].titleAr ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: mainOrangeColor),
                            );
                          },
                        ),
                      )
                    ],
                  ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('age')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data?.age ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('birthday')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.data?.birthDate}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('religion')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? widget.data?.religion?.titleEn ?? ""
                          : widget.data?.religion?.titleEn ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${AppLocalizations.of(context)?.translate('passportNo')}:",
                      style: TextStyle(fontSize: 14, color: mainBlueColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.data?.additional?.passportNo ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainOrangeColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          widget.data?.additional == null
              ? Container()
              : Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppLocalizations.of(context)?.translate('kidsNo')}:",
                                style: TextStyle(
                                    fontSize: 14, color: mainBlueColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data?.additional?.children ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: mainOrangeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppLocalizations.of(context)?.translate('passportissueDate')}:",
                                style: TextStyle(
                                    fontSize: 14, color: mainBlueColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data?.additional?.passportDate ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: mainOrangeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey[300],
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppLocalizations.of(context)?.translate('passportEndDate')}:",
                                style: TextStyle(
                                    fontSize: 14, color: mainBlueColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data?.additional?.passportExpDate ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: mainOrangeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppLocalizations.of(context)?.translate('weight')}:",
                                style: TextStyle(
                                    fontSize: 14, color: mainBlueColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data?.additional?.weight ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: mainOrangeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey[300],
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${AppLocalizations.of(context)?.translate('height')}:",
                                style: TextStyle(
                                    fontSize: 14, color: mainBlueColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data?.additional?.length ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: mainOrangeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
