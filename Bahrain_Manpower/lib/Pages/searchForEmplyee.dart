// ignore_for_file: file_names, use_build_context_synchronously

import 'package:bahrain_manpower/Global/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Global/widgets/MainDrawer.dart';
import 'package:bahrain_manpower/Pages/welcome_screen.dart';
import 'package:bahrain_manpower/models/AppInfo/homeSilder.dart';
import 'package:bahrain_manpower/models/Companies/Categories.dart';
import 'package:bahrain_manpower/models/workers/workersCategories.dart';
import 'package:bahrain_manpower/services/Companies/CompaniesService.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/appDataService.dart';
import 'package:bahrain_manpower/services/workersService.dart';
import 'package:bahrain_manpower/widgets/Companies/companyCategoryCard.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Global/Settings.dart';
import '../services/notification/notification_services.dart';

class  SearchForEmployee extends StatefulWidget {
  const SearchForEmployee({Key? key}) : super(key: key);

  @override
  SearchForEmployeeState createState() => SearchForEmployeeState();
}

class SearchForEmployeeState extends State<SearchForEmployee> {
   List<Widget?>? child;


   List? photoSliderList;
   final CarouselController _controller = CarouselController();
  bool isLoading = true;
  List<Categories> categories = [];
  List<WorkersCategory> workercategories = [];

  List<HomeSlider> imgList = [];
   String? type;
   String? id;

  getPhotoSlider() async {
    imgList = await AppDataService().getSliderPhotos();
  }

  getCategories() async {
    categories = await CompaniesService().getCategories();
    workercategories = await WorkerService().getCategories();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString("type");
    id = prefs.getString("id");
  }

  photoSlider() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString("type");
    id = prefs.getString("id");
   if(type == "company"){
     var payed = await CompaniesService().getPayed(id!);
     if(!payed!.pay!){
      
         launchURL(
             "${url}StripePayment/form?company_id=${id}");


     }
   }

    String? route;
    if(prefs.containsKey("route")){
      route = prefs.getString("route");
    NotificationServices.notificationSelectingAction(route,context);
    prefs.remove("route");
    }
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
    NewVersion(
      androidId: "com.sync.bahrain_manpower",
      iOSId: "com.sync.bahrain_manpower",
    ).showAlertIfNecessary(context: context);

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
          ? const Loader()
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
                      });
                    },
                  ),
                ),
               id ==null? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( Localizations.localeOf(context).languageCode == "en"
                        ?"if you don't have an account":"اذا لم يكن لديك حساب"),
                    const SizedBox(width: 4,),
                    InkWell(
                      onTap: (){
                        pushPage(context, const WelcomeScreen());
                      },
                      child: Text(
                         Localizations.localeOf(context).languageCode == "en"
                            ?"you can create an account":"يمكنك إنشاء حساب",style: const TextStyle(
                        color: Colors.blue
                      ),
                      ),
                    )
                  ],
                ):const SizedBox(),
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
                        name:
                            Localizations.localeOf(context).languageCode == "en"
                                ? categories[index].categoryNameEn??""
                                : categories[index].categoryName??"",
                        isSpecial: true,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 70 * (workercategories.length).toDouble(),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    itemCount: workercategories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CompanyCategoryCard(
                        id: workercategories[index].categoryWorkerId??"",
                        name:
                            Localizations.localeOf(context).languageCode == "en"
                                ? workercategories[index].categoryWorkerNameEn??""
                                : workercategories[index].categoryWorkerName??"",
                        isSpecial: false,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25)
              ],
            ),
    );
  }
}
