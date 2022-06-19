// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Global/widgets/MainInputFiled.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:bahrain_manpower/Pages/Empolyees/empolyeeProfile.dart';
import 'package:bahrain_manpower/models/AppInfo/Filters.dart';
import 'package:bahrain_manpower/models/other/authresult.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/SendCvService.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/appDataService.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/loader.dart';

// ignore: must_be_immutable
class AddCvScreen extends StatefulWidget {
  String id;
  AddCvScreen({Key? key, this.id = "0"}) : super(key: key);
  @override
  AddCvScreenState createState() => AddCvScreenState();
}

class AddCvScreenState extends State<AddCvScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

   late FiltersData data;
  bool isLoading = true;
  String? title = "";
  final picker = ImagePicker();
  List<String> imgName = ["السيرة الذانية", "صورة شخصية", "صورة كاملة"];
  List<String> imgNameEn = ["CV", "Profile pictre", "Full Picture"];

   String? genderValue;
   Occupation? selectedJob;
   Gender? selectedGender;
  bool isSpecialJob = false;
   DateTime? pickedDate;
  ImageSource imgSrc = ImageSource.gallery;
  final List<File> _images = List<File>.empty();

  List<String> selectedSkills = [];
  List<String> skills = [];
  List<String> selectedLang = [];
  List<String> lang = [];
  List<String> selectedEducation = [];
  List<String> education = [];

   Nationality? seletedNationality;
   Residence? selctedCity;
   Religion? selectedReligon;
   Country? selectedCountry;
   Status? status;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nameEnController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightontroller = TextEditingController();
  final TextEditingController _childrenNoController = TextEditingController();
  final TextEditingController _contractPeriodController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _passportNoController = TextEditingController();
  final TextEditingController _experinceController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _passportDateController = TextEditingController();
  final TextEditingController _passportEndController = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode nameEnNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode whatsAppNode = FocusNode();
  FocusNode mobileNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode usernameNode = FocusNode();
  FocusNode weightNode = FocusNode();
  FocusNode heightNode = FocusNode();
  FocusNode childerNoNode = FocusNode();
  FocusNode contractNode = FocusNode();
  FocusNode salarayNode = FocusNode();
  FocusNode passportNode = FocusNode();
  FocusNode experinceNode = FocusNode();
  FocusNode birthdateNode = FocusNode();
  FocusNode passportdateNode = FocusNode();
  FocusNode passportEnddateNode = FocusNode();
  @override
  void initState() {
    super.initState();
    getData();
    NotificationServices.checkNotificationAppInForeground(context);

  }

  unfocus() {
    nameNode.unfocus();
    nameEnNode.unfocus();
    emailNode.unfocus();
    whatsAppNode.unfocus();
    mobileNode.unfocus();
    passwordNode.unfocus();
    usernameNode.unfocus();
    weightNode.unfocus();
    heightNode.unfocus();
    childerNoNode.unfocus();
    contractNode.unfocus();
    salarayNode.unfocus();
    passportNode.unfocus();
    experinceNode.unfocus();
    birthdateNode.unfocus();
    passportdateNode.unfocus();
    passportEnddateNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          iconTheme:  IconThemeData(color: mainOrangeColor),
          backgroundColor: offWhite,
          centerTitle: true,
          title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/icon/logoAppBar.png",
                  scale: 8, fit: BoxFit.scaleDown))),
      body: isLoading
          ? const Loader()
          : Container(
              color: Colors.grey[200],
              child: ListView(
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: mainOrangeColor,
                    child: Center(
                        child: Text(
                      "$title",
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    )),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            unfocus();

                            showAdaptiveActionSheet(
                              context: context,
                              title: Text(
                                selectedJob == null
                                    ? AppLocalizations.of(context)?.translate('job')??""
                                    : selectedJob!.occupationName??"",
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 12),
                              ),
                              actions: data.occupation!
                                  .map<BottomSheetAction>((Occupation value) {
                                return BottomSheetAction(
                                    title: Text(
                                      '${Localizations.localeOf(context).languageCode == "en" ? value.occupationNameEn : value.occupationName}',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    onPressed: () {
                                      selectedJob = value;
                                      if (value.formCv == "2") {
                                        isSpecialJob = true;
                                      } else {
                                        isSpecialJob = false;
                                      }
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    });
                              }).toList(),
                            );
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: mainOrangeColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  selectedJob == null
                                      ? "${AppLocalizations.of(context)?.translate('job')}"
                                      : "${selectedJob!.occupationName}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                              )),
                        ),
                        const SizedBox(height: 10),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(0)),
                              border: Border.all(color: Colors.white, width: 1),
                              color: Colors.white),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxHeight: 150, minHeight: 100.0),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: 3,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    bool? done = await selectImageSrc();
                                    if (done??false) {
                                      getPhoto(index, imgSrc);
                                    }
                                    setState(() {});
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: 95,
                                        height: 95,
                                        margin:
                                            const EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(20)),
                                            border: Border.all(
                                                color: const Color(0xFFB9B9B9)),
                                            color: const Color(0xFFF3F3F3)),
                                        alignment: Alignment.center,
                                        child: _images.asMap()[index] == null
                                            ? const Icon(
                                                Icons.camera_alt,
                                                size: 30,
                                              )
                                            : Image.file(_images[index]),
                                      ),
                                      Text(
                                          Localizations.localeOf(context).languageCode == "en" ? imgNameEn[index] : imgName[index],
                                          style: const TextStyle(fontSize: 10))
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('addJpg')}",
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 10),
                        MainInputFiled(
                          focusNode: nameNode,
                          label:
                              "${AppLocalizations.of(context)?.translate('name')}",
                          inputType: TextInputType.name,
                          controller: _nameController,
                        ),
                        const SizedBox(height: 10),
                        MainInputFiled(
                          focusNode: nameEnNode,
                          label:
                              "${AppLocalizations.of(context)?.translate('nameEn')}",
                          inputType: TextInputType.name,
                          controller: _nameEnController,
                        ),
                        const SizedBox(height: 10),
                        widget.id == "0"
                            ? MainInputFiled(
                                focusNode: emailNode,
                                label:
                                    "${AppLocalizations.of(context)?.translate('email')}",
                                inputType: TextInputType.emailAddress,
                                controller: _emailController,
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            unfocus();

                            showAdaptiveActionSheet(
                              context: context,
                              title: Text(
                                "${AppLocalizations.of(context)?.translate('gender')}",
                                textAlign: TextAlign.start,
                              ),
                              actions: data.gender!
                                  .map<BottomSheetAction>((Gender value) {
                                return BottomSheetAction(
                                    title: Text(
                                      '${Localizations.localeOf(context).languageCode == "en" ? value.genderNameEn : value.genderName}',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    onPressed: () {
                                      selectedGender = value;
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    });
                              }).toList(),
                            );
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: mainOrangeColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  selectedGender == null
                                      ? "${AppLocalizations.of(context)?.translate('gender')}"
                                      : "${selectedGender!.genderName}",
                                  style: TextStyle(color: Colors.grey[600]),
                                  textAlign: TextAlign.start,
                                ),
                              )),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            unfocus();
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1920),
                              lastDate: DateTime(2300),
                            ).then((date) {
                              setState(() {
                                _birthdateController.text =
                                    "${date!.day} / ${date.month} / ${date.year} ";
                              });
                            });
                          },
                          child: MainInputFiled(
                            enabled: false,
                            label:
                                "${AppLocalizations.of(context)?.translate('birthday')}",
                            inputType: TextInputType.datetime,
                            controller: _birthdateController,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // MainInputFiled(
                        //   label:
                        //       "${AppLocalizations.of(context).translate('address')}",
                        //   inputType: TextInputType.text,
                        // ),
                        const SizedBox(height: 10),
                        MainInputFiled(
                          focusNode: salarayNode,
                          label:
                              "${AppLocalizations.of(context)?.translate('monthlySalary')}",
                          inputType: TextInputType.number,
                          controller: _salaryController,
                        ),
                        const SizedBox(height: 10),
                        MainInputFiled(
                          focusNode: contractNode,
                          label:
                              "${AppLocalizations.of(context)?.translate('contractTime')}",
                          inputType: TextInputType.number,
                          controller: _contractPeriodController,
                        ),
                        const SizedBox(height: 10),
                        MainInputFiled(
                          focusNode: experinceNode,
                          label:
                              "${AppLocalizations.of(context)?.translate('exp')}",
                          inputType: TextInputType.number,
                          controller: _experinceController,
                        ),
                        const SizedBox(height: 10),
                        MainInputFiled(
                          focusNode: passportNode,
                          label:
                              "${AppLocalizations.of(context)?.translate('passportNo')}",
                          inputType: TextInputType.text,
                          controller: _passportNoController,
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            unfocus();

                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1920),
                              lastDate: DateTime(2300),
                            ).then((date) {
                              setState(() {
                                _passportDateController.text =
                                    "${date!.day} / ${date.month} / ${date.year} ";
                              });
                            });
                          },
                          child: MainInputFiled(
                            enabled: false,
                            label:
                                "${AppLocalizations.of(context)?.translate('passportissueDate')}",
                            inputType: TextInputType.number,
                            controller: _passportDateController,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            unfocus();

                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1920),
                              lastDate: DateTime(2300),
                            ).then((date) {
                              setState(() {
                                _passportEndController.text =
                                    "${date?.day} / ${date?.month} / ${date?.year} ";
                              });
                            });
                          },
                          child: MainInputFiled(
                            enabled: false,
                            label:
                                "${AppLocalizations.of(context)?.translate('passportEndDate')}",
                            inputType: TextInputType.number,
                            controller: _passportEndController,
                          ),
                        ),
                        const SizedBox(height: 10),
                        widget.id == "0"
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: MainInputFiled(
                                        focusNode: whatsAppNode,
                                        label:
                                            "${AppLocalizations.of(context)?.translate('whatsapp')}",
                                        inputType: TextInputType.phone,
                                        controller: _whatsappController,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        unfocus();
                                        showAdaptiveActionSheet(
                                          context: context,
                                          title: Text(
                                            "${AppLocalizations.of(context)?.translate('country')}",
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          actions: data.country!
                                              .map<BottomSheetAction>(
                                                  (Country value) {
                                            return BottomSheetAction(
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${Localizations.localeOf(context).languageCode == 'en' ? value.countryName : value.countryNameEn}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        "${value.dialing}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  selectedCountry = value;
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                });
                                          }).toList(),
                                        );
                                      },
                                      child: Text(
                                          "${selectedCountry == null ? data.country?.first.dialing : selectedCountry!.dialing}"),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        widget.id == "0"
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: MainInputFiled(
                                        focusNode: mobileNode,
                                        label:
                                            "${AppLocalizations.of(context)?.translate('mobile')}",
                                        inputType: TextInputType.phone,
                                        controller: _mobileController,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        unfocus();
                                        showAdaptiveActionSheet(
                                          context: context,
                                          title: Text(
                                            "${AppLocalizations.of(context)?.translate('country')}",
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          actions: data.country!
                                              .map<BottomSheetAction>(
                                                  (Country value) {
                                            return BottomSheetAction(
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${Localizations.localeOf(context).languageCode == 'en' ? value.countryName : value.countryNameEn}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        "${value.dialing}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  selectedCountry = value;
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                });
                                          }).toList(),
                                        );
                                      },
                                      child: Text(
                                          "${selectedCountry == null ? data.country?.first.dialing : selectedCountry!.dialing}"),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        widget.id == "0"
                            ? MainInputFiled(
                                focusNode: usernameNode,
                                label:
                                    "${AppLocalizations.of(context)?.translate('username')}",
                                inputType: TextInputType.text,
                                controller: _usernameController,
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        widget.id == "0"
                            ? MainInputFiled(
                                focusNode: passportNode,
                                label:
                                    "${AppLocalizations.of(context)?.translate('password')}",
                                inputType: TextInputType.visiblePassword,
                                controller: _passwordController,
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            unfocus();

                            showAdaptiveActionSheet(
                              context: context,
                              title: Text(
                                "${AppLocalizations.of(context)?.translate('city')}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 12),
                              ),
                              actions: data.residence!
                                  .map<BottomSheetAction>((Residence value) {
                                return BottomSheetAction(
                                    title: CheckboxListTile(
                                      value: selctedCity == null
                                          ? false
                                          : selctedCity!.residenceId ==
                                              value.residenceId,
                                      selected: selctedCity == null
                                          ? false
                                          : selctedCity!.residenceId ==
                                              value.residenceId,
                                      title: Text(
                                        '${Localizations.localeOf(context).languageCode == "en" ? value.residenceNameEn : value.residenceName}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      onChanged: ( result) {
                                        selctedCity = value;
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    onPressed: () {
                                      selctedCity = value;
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    });
                              }).toList(),
                            );
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: mainOrangeColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  selctedCity == null
                                      ? "${AppLocalizations.of(context)?.translate('city')}"
                                      : "${selctedCity!.residenceName}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                              )),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            unfocus();

                            showAdaptiveActionSheet(
                              context: context,
                              title: Text(
                                "${AppLocalizations.of(context)?.translate('nationality')}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 12),
                              ),
                              actions: data.nationality!
                                  .map<BottomSheetAction>((Nationality value) {
                                return BottomSheetAction(
                                    title: CheckboxListTile(
                                      value: seletedNationality == null
                                          ? false
                                          : seletedNationality!.nationalityId ==
                                              value.nationalityId,
                                      selected: seletedNationality == null
                                          ? false
                                          : seletedNationality!.nationalityId ==
                                              value.nationalityId,
                                      title: Text(
                                        '${Localizations.localeOf(context).languageCode == "en" ? value.nationalityNameEn : value.nationalityName}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      onChanged: (result) {
                                        seletedNationality = value;
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    onPressed: () {
                                      seletedNationality = value;
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    });
                              }).toList(),
                            );
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: mainOrangeColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  seletedNationality == null
                                      ? "${AppLocalizations.of(context)?.translate('nationality')}"
                                      : "${seletedNationality!.nationalityName}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                              )),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            unfocus();

                            showAdaptiveActionSheet(
                              context: context,
                              title: Text(
                                "${AppLocalizations.of(context)?.translate('religion')}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 12),
                              ),
                              actions: data.religion!
                                  .map<BottomSheetAction>((Religion value) {
                                return BottomSheetAction(
                                    title: CheckboxListTile(
                                      value: selectedReligon == null
                                          ? false
                                          : selectedReligon!.religionId ==
                                              value.religionId,
                                      selected: selectedReligon == null
                                          ? false
                                          : selectedReligon!.religionId ==
                                              value.religionId,
                                      title: Text(
                                        '${Localizations.localeOf(context).languageCode == "en" ? value.religionNameEn : value.religionName}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      onChanged: (result) {
                                        selectedReligon = value;
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    onPressed: () {
                                      selectedReligon = value;
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    });
                              }).toList(),
                            );
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: mainOrangeColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  selectedReligon == null
                                      ? "${AppLocalizations.of(context)?.translate('religion')}"
                                      : "${selectedReligon!.religionName}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                              )),
                        ),
                        const SizedBox(height: 10),
                        isSpecialJob
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  unfocus();

                                  showAdaptiveActionSheet(
                                    context: context,
                                    title: Text(
                                      "${AppLocalizations.of(context)?.translate('socialStatus')}",
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    actions: data.status!
                                        .map<BottomSheetAction>((Status value) {
                                      return BottomSheetAction(
                                          title: CheckboxListTile(
                                            value: status == null
                                                ? false
                                                : status!.statusId ==
                                                    value.statusId,
                                            selected: status == null
                                                ? false
                                                : status!.statusId ==
                                                    value.statusId,
                                            title: Text(
                                              '${Localizations.localeOf(context).languageCode == "en" ? value.statusNameEn : value.statusName}',
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            onChanged: (result) {
                                              status = value;
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          onPressed: () {
                                            status = value;
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          });
                                    }).toList(),
                                  );
                                },
                                child: MainInputFiled(
                                  label:
                                      "${status == null ? AppLocalizations.of(context)?.translate('socialStatus') : Localizations.localeOf(context).languageCode == "en" ? status!.statusNameEn : status!.statusName}",
                                  inputType: TextInputType.text,
                                  enabled: false,
                                ),
                              ),
                        const SizedBox(height: 10),
                        isSpecialJob
                            ? Container()
                            : MainInputFiled(
                                label:
                                    "${AppLocalizations.of(context)?.translate('kidsNo')}",
                                inputType: TextInputType.number,
                                controller: _childrenNoController,
                              ),
                        const SizedBox(height: 10),
                        isSpecialJob
                            ? Container()
                            : MainInputFiled(
                                focusNode: heightNode,
                                label:
                                    "${AppLocalizations.of(context)?.translate('height')}",
                                inputType: TextInputType.number,
                                controller: _heightontroller,
                              ),
                        const SizedBox(height: 10),
                        isSpecialJob
                            ? Container()
                            : MainInputFiled(
                                focusNode: weightNode,
                                label:
                                    "${AppLocalizations.of(context)?.translate('weight')}",
                                inputType: TextInputType.number,
                                controller: _weightController,
                              ),
                        const SizedBox(height: 10),
                        isSpecialJob
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  unfocus();

                                  showAdaptiveActionSheet(
                                    context: context,
                                    title: Text(
                                      "${AppLocalizations.of(context)?.translate('certificates')}",
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    actions: data.education!
                                        .map<BottomSheetAction>(
                                            (Education value) {
                                      return BottomSheetAction(
                                          title: CheckboxListTile(
                                            value: selectedEducation
                                                .contains(value.educationId),
                                            selected: selectedEducation
                                                .contains(value.educationId),
                                            title: Text(
                                              '${Localizations.localeOf(context).languageCode == "en" ? value.educationNameEn : value.educationName}',
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            onChanged: (result) {
                                              if (selectedEducation.contains(
                                                  value.educationId)) {
                                                selectedEducation
                                                    .remove(value.educationId);
                                                education.remove(
                                                    value.educationName);
                                              } else {
                                                selectedEducation
                                                    .add(value.educationId??"");
                                                education
                                                    .add(value.educationName??"");
                                              }
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          onPressed: () {
                                            if (selectedEducation
                                                .contains(value.educationId)) {
                                              selectedEducation
                                                  .remove(value.educationId);
                                              education
                                                  .remove(value.educationName);
                                            } else {
                                              selectedEducation
                                                  .add(value.educationId??"");
                                              education
                                                  .add(value.educationName??"");
                                            }
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          });
                                    }).toList(),
                                  );
                                },
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(10)),
                                      border:
                                          Border.all(color: mainOrangeColor),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        education.isEmpty
                                            ? "${AppLocalizations.of(context)?.translate('certificates')}"
                                            : education.join(","),
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12),
                                        textAlign: TextAlign.start,
                                      ),
                                    )),
                              ),
                        const SizedBox(height: 10),
                        isSpecialJob
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  unfocus();

                                  showAdaptiveActionSheet(
                                    context: context,
                                    title: Text(
                                      "${AppLocalizations.of(context)?.translate('languages')}",
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    actions: data.language!
                                        .map<BottomSheetAction>(
                                            (Language value) {
                                      return BottomSheetAction(
                                          title: CheckboxListTile(
                                            value: selectedLang
                                                .contains(value.languageId),
                                            selected: selectedLang
                                                .contains(value.languageId),
                                            title: Text(
                                              '${Localizations.localeOf(context).languageCode == "en" ? value.languageNameEn : value.languageName}',
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            onChanged: ( result) {
                                              if (selectedLang
                                                  .contains(value.languageId)) {
                                                selectedLang
                                                    .remove(value.languageId);
                                                lang.remove(value.languageName);
                                              } else {
                                                selectedLang
                                                    .add(value.languageId??"");
                                                lang.add(value.languageName??"");
                                              }
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          onPressed: () {
                                            if (selectedLang
                                                .contains(value.languageId)) {
                                              selectedLang
                                                  .remove(value.languageId);
                                              lang.remove(value.languageName);
                                            } else {
                                              selectedLang
                                                  .add(value.languageId??"");
                                              lang.add(value.languageName??"");
                                            }
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          });
                                    }).toList(),
                                  );
                                },
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(10)),
                                      border:
                                          Border.all(color: mainOrangeColor),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        lang.isEmpty
                                            ? "${AppLocalizations.of(context)?.translate('languages')}"
                                            : lang.toString(),
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12),
                                        textAlign: TextAlign.start,
                                      ),
                                    )),
                              ),
                        const SizedBox(height: 10),
                        isSpecialJob
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  unfocus();

                                  showAdaptiveActionSheet(
                                    context: context,
                                    title: Text(
                                      "${AppLocalizations.of(context)?.translate('skills')}",
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    actions: data.skills!
                                        .map<BottomSheetAction>((Skill value) {
                                      return BottomSheetAction(
                                          title: CheckboxListTile(
                                            value: selectedSkills
                                                .contains(value.skillsId),
                                            selected: selectedSkills
                                                .contains(value.skillsId),
                                            title: Text(
                                              '${Localizations.localeOf(context).languageCode == "en" ? value.skillsNameEn : value.skillsName}',
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            onChanged: (result) {
                                              if (selectedSkills
                                                  .contains(value.skillsId)) {
                                                selectedSkills
                                                    .remove(value.skillsId);
                                                skills.remove(value.skillsName);
                                              } else {
                                                selectedSkills
                                                    .add(value.skillsId??"");
                                                skills.add(value.skillsName??"");
                                              }
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          onPressed: () {
                                            if (selectedSkills
                                                .contains(value.skillsId)) {
                                              selectedSkills
                                                  .remove(value.skillsId);
                                              skills.remove(value.skillsName);
                                            } else {
                                              selectedSkills
                                                  .add(value.skillsId??"");
                                              skills.add(value.skillsName??"");
                                            }
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          });
                                    }).toList(),
                                  );
                                },
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(10)),
                                      border:
                                          Border.all(color: mainOrangeColor),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        skills.isEmpty
                                            ? "${AppLocalizations.of(context)?.translate('skills')}"
                                            : skills.toString(),
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12),
                                        textAlign: TextAlign.start,
                                      ),
                                    )),
                              ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            sendCv();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: mainOrangeColor),
                            child: Text(
                                "${AppLocalizations.of(context)?.translate('save')}",
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  getPhoto(int index, ImageSource src) async {
    final pickedFile = await picker.pickImage(source: src);
    if (_images.isNotEmpty) {
      if (_images.asMap()[index] == null) {

        _images.add(File(pickedFile!.path));
      } else {

        _images[index] = File(pickedFile!.path);
      }
    } else {
      _images.add(File(pickedFile!.path));
    }
    setState(() {});
  }

  Future<bool?> selectImageSrc() async {
    bool? done = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              title: Center(
                  child:
                      Text(AppLocalizations.of(context)?.translate('select')??"")),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.camera_alt),
                          Text(
                              AppLocalizations.of(context)?.translate('camera')??""),
                        ],
                      ),
                      onPressed: () {
                        imgSrc = ImageSource.camera;
                        Navigator.pop(context, true);
                      },
                    ),
                    MaterialButton(
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.photo),
                          Text(
                              AppLocalizations.of(context)?.translate('galary')??""),
                        ],
                      ),
                      onPressed: () {
                        imgSrc = ImageSource.gallery;
                        Navigator.pop(context, true);
                      },
                    )
                  ],
                ),
              ],
            ));
    return done;
  }

  getData() async {
    title = await AppDataService().getCvTitle();
    data = await AppDataService().getFilters();
    if (data.country!.isNotEmpty) {
      selectedCountry = data.country!.first;
    }
    isLoading = false;
    setState(() {});
  }

  sendCv() async {
    isLoading = true;
    setState(() {});
    AuthResult? result = await SendCvService().sendCv(
        _nameController.text,
        _nameEnController.text,
        selectedJob == null ? "" : selectedJob!.occupationId??"",
        seletedNationality == null ? "" : seletedNationality!.nationalityId??"",
        selctedCity == null ? "" : selctedCity!.residenceId??"",
        selectedReligon == null ? "" : selectedReligon!.religionId??"",
        selectedGender == null ? "" : selectedGender!.genderId??"",
        _emailController.text,
        selectedCountry == null
            ? _whatsappController.text
            : "${selectedCountry!.dialing}${_whatsappController.text}",
        // "${selectedCountry == null ? "" : selectedCountry.dialing ?? ""}
        selectedCountry == null
            ? _mobileController.text
            : "${selectedCountry!.dialing}${_mobileController.text}",
        _passwordController.text,
        _usernameController.text,
        _weightController.text,
        _heightontroller.text,
        _childrenNoController.text,
        selectedEducation,
        selectedLang,
        selectedSkills,
        _contractPeriodController.text,
        _salaryController.text,
        _birthdateController.text,
        _passportNoController.text,
        _experinceController.text,
        _passportDateController.text,
        _passportEndController.text,
        _images.isEmpty ? null : _images[0],
        _images.length < 2 ? null : _images[1],
        _images.length < 3 ? null : _images[2],
        widget.id);
    if (result?.status == "success") {
      pushPageReplacement(context, const EmployeeProfile());
    } else {
      final snackBar = SnackBar(
          content: Text(Localizations.localeOf(context).languageCode == "en"
              ? result?.messageEn??""
              : result?.messageAr??""));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      isLoading = false;
      setState(() {});
    }
  }
}
