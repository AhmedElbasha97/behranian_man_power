// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, file_names

import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/widgets/MainInputFiled.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/companies/CompanyProfile.dart';
import 'package:bahrain_manpower/Pages/companies/map_screen.dart';
import 'package:bahrain_manpower/models/Companies/Categories.dart';
import 'package:bahrain_manpower/models/Companies/companyInfo.dart';
import 'package:bahrain_manpower/models/other/authresult.dart';
import 'package:bahrain_manpower/services/Companies/CompaniesService.dart';
import 'package:bahrain_manpower/widgets/button_widget.dart';
import 'package:bahrain_manpower/widgets/loader.dart';



class CompanyEditProfile extends StatefulWidget {
  final CompanyInfo? data;
  const CompanyEditProfile(this.data, {Key? key}) : super(key: key);
  @override
  CompanyEditProfileState createState() => CompanyEditProfileState();
}

class CompanyEditProfileState extends State<CompanyEditProfile> {
  bool isLoading = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ImageSource imgSrc = ImageSource.gallery;
  final picker = ImagePicker();

   File? img;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _nameEnController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController detailsArController = TextEditingController();
  TextEditingController detailsEnController = TextEditingController();
   String address ="";
  List<Categories> categories = [];
  final List<File> _images = [];
   Categories? selectedCat;
  late LatLng selectedPlace;

  @override
  void initState() {
    super.initState();
    getCategories();
    fillData();
  }
  void _navigateAndDisplaySelection(BuildContext context) async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    selectedPlace =result;
    List<Placemark> i =
    await placemarkFromCoordinates(result.latitude, result.longitude);
    Placemark placeMark = i.first;
     address="${placeMark.street},${placeMark.subAdministrativeArea},${placeMark.subLocality},${placeMark.country}";
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(address)));
  }
  fillData() {
    _nameController =
        TextEditingController(text: widget.data?.data?.nameAr);
    _nameEnController =
        TextEditingController(text: widget.data?.data?.nameEn);
    _emailController =
        TextEditingController(text: widget.data?.data?.email);
    _usernameController =
        TextEditingController(text: widget.data?.data?.username);
    _mobileController =
        TextEditingController(text: widget.data?.data?.mobile);
    addressController =
        TextEditingController(text: widget.data?.data?.address);
    detailsArController =
        TextEditingController(text: widget.data?.data?.detailsAr);
    detailsEnController =
        TextEditingController(text: widget.data?.data?.detailsEn);
    selectedCat = Categories(
        categoryId: widget.data?.data?.categoryId,
        categoryName: widget.data?.data?.categoryNameAr,
        categoryNameEn: widget.data?.data?.nameEn);
  }

  getPhotos(int index, ImageSource src) async {
    final pickedFile = await picker.pickImage(source: src);
    if (pickedFile != null) {
      if (_images.isNotEmpty) {
        if (_images.asMap()[index] == null) {

          _images.add(File(pickedFile.path));
        } else {

          _images[index] = File(pickedFile.path);
        }
      } else {
        _images.add(File(pickedFile.path));
      }

      setState(() {});
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          iconTheme:  IconThemeData(color: mainOrangeColor),
          backgroundColor: offWhite,
        ),
        body: isLoading
            ? const Loader()
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 10),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(0)),
                          border: Border.all(color: Colors.white, width: 1),
                          color: Colors.white),
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxHeight: 150, minHeight: 100.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 3,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                bool? done = await selectImageSrcs();
                                if (done??false) {
                                  getPhotos(index, imgSrc);
                                }
                                setState(() {});
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 95,
                                    height: 95,
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
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
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('username')}",
                    inputType: TextInputType.text,
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('password')}",
                    inputType: TextInputType.visiblePassword,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('companyName')}",
                    inputType: TextInputType.name,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('companyNameEn')}",
                    inputType: TextInputType.name,
                    controller: _nameEnController,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('mobile')}",
                    inputType: TextInputType.phone,
                    controller: _mobileController,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label: "${AppLocalizations.of(context)?.translate('email')}",
                    inputType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      showAdaptiveActionSheet(
                        context: context,
                        title: Text(
                          "${AppLocalizations.of(context)?.translate('department')}",
                          textAlign: TextAlign.start,
                        ),
                        actions: categories
                            .map<BottomSheetAction>((Categories value) {
                          return BottomSheetAction(
                              title: Text(
                                '${value.categoryName}',
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 12),
                              ),
                              onPressed: () {
                                selectedCat = value;
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
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: mainOrangeColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            selectedCat == null
                                ? "${AppLocalizations.of(context)?.translate('department')}"
                                : "${selectedCat!.categoryName}",
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.start,
                          ),
                        )),
                  ),
                  const SizedBox(height: 10),
                  CustomElevatedButton(
                    bordersColor:mainOrangeColor ,
                    hasTextStyle: true,
                    text:  AppLocalizations.of(context)?.translate('selectOnMap')??"",
                    textStyle: const TextStyle(color: Colors.black),
                    background: Colors.white,
                    borderReduis: 10.0,
                    onPressed: () {
                      _navigateAndDisplaySelection(context);
                    }, width: MediaQuery.of(context).size.height * 0.9,
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('companyName')}",
                    inputType: TextInputType.name,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 10),
                  MainInputFiled(
                    label:
                        "${AppLocalizations.of(context)?.translate('companyNameEn')}",
                    inputType: TextInputType.name,
                    controller: _nameEnController,
                  ),
                  const SizedBox(height: 10),

                  InkWell(
                    onTap: () {
                      signUp();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: mainOrangeColor),
                      child: Text(
                          "${AppLocalizations.of(context)?.translate('save')}",
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ));
  }

  getCategories() async {
    categories = await CompaniesService().getCategories();
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool?> selectImageSrcs() async {
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

  getPhoto(ImageSource src) async {
    final pickedFile = await picker.pickImage(source: src);
    if (pickedFile != null) {
      img = File(pickedFile.path);
    }
    setState(() {});
  }

  signUp() async {
    isLoading = true;

    setState(() {});
    if(selectedPlace==null){
    List<Placemark> i =
    await placemarkFromCoordinates(selectedPlace.latitude, selectedPlace.longitude);
    Placemark placeMark = i.first;
    address="${placeMark.street},${placeMark.subAdministrativeArea},${placeMark.subLocality},${placeMark.country}";
    }

    AuthResult result = await CompaniesService().companyeditProfile(
        username:
            _usernameController.text == "" ? "" : _usernameController.text,
        password:
            _passwordController.text == "" ? "" : _passwordController.text,
        mobile: _mobileController.text == "" ? "" : _mobileController.text,
        name: _nameController.text == "" ? "" : _nameController.text,
        nameEn: _nameEnController.text == "" ? "" : _nameEnController.text,
        email: _emailController.text == "" ? "" : _emailController.text,
        img1: _images.isEmpty ? null : _images.first,
        img2: _images.length < 2 ? null : _images[1],
        img3: _images.length < 3 ? null : _images[2],
        address: selectedPlace==null ? null : address,
        details:
            detailsArController.text == "" ? null : detailsArController.text,
        detailsEn:
            detailsEnController.text == "" ? null : detailsEnController.text,
        location: selectedPlace==null
            ? "0,0"
            : "${selectedPlace.latitude},${selectedPlace.longitude}",
        categoryId: selectedCat == null ? null : selectedCat!.categoryId);
    if (result.status == "success") {
      final snackBar = SnackBar(
          content: Text(
              "${AppLocalizations.of(context)?.translate('signinSuccessMsg')}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const CompanyProfileScreen(),
      ));
    } else {
      final snackBar = SnackBar(
          content: Text(Localizations.localeOf(context).languageCode == "en"
              ? result.messageEn!
              : result.messageAr!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    isLoading = false;

    setState(() {});
  }
}
