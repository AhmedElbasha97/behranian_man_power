// ignore_for_file: file_names, unused_field

import 'package:bahrain_manpower/Global/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Global/widgets/MainDrawer.dart';
import 'package:bahrain_manpower/models/AppInfo/homeSilder.dart';
import 'package:bahrain_manpower/models/Companies/Categories.dart';
import 'package:bahrain_manpower/services/Companies/CompaniesService.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/appDataService.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/Companies/companyCategoryCard.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanySearchScreen extends StatefulWidget {
  const CompanySearchScreen({Key? key}) : super(key: key);

  @override
  CompanySearchScreenState createState() => CompanySearchScreenState();
}

class CompanySearchScreenState extends State<CompanySearchScreen> {
   List<Widget?>? child;
   List? photoSliderList;
  int _current = 0;
  bool isLoading = true;
  List<Categories> categories = [];
  List<HomeSlider> imgList = [];
   final CarouselController _controller = CarouselController();
   String? type;
   String? id;

  getPhotoSlider() async {
    imgList = await AppDataService().getSliderPhotos();
  }

  getCategories() async {
    categories = await CompaniesService().getCategories();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString("type");
    id = prefs.getString("id");
  }

  photoSlider() async {
    await getPhotoSlider();
    await getCategories();
    child = map<Widget>(
      imgList,
      (index, i) {
        return Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: CachedNetworkImage(
              imageUrl: i.picpath,
              fit: BoxFit.cover,
              width: 1000.0,
              placeholder: (context, url) => SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    ).toList();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    photoSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: isLoading ? const Loader() : MainDrawer(id, type),
        appBar: AppBar(
            iconTheme:  IconThemeData(color: mainOrangeColor),
            backgroundColor: offWhite,
            centerTitle: true,
            title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/icon/logoAppBar.png",
                    scale: 8, fit: BoxFit.scaleDown))),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: child!.length,
                    itemBuilder: (BuildContext context, int index, int realIndex) {
                      return child![index]!;
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 70 * (categories.length).toDouble(),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CompanyCategoryCard(
                          id: categories[index].categoryId??"",
                          name: Localizations.localeOf(context).languageCode ==
                                  "en"
                              ? categories[index].categoryNameEn??""
                              : categories[index].categoryName??"",
                          isSpecial: true,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25)
                ],
              ));
  }
}
