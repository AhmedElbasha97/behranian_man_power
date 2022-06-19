// ignore_for_file: prefer_is_empty, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Global/widgets/MainDrawer.dart';
import 'package:bahrain_manpower/I10n/AppLanguage.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/Pages/companies/CompanyDetails.dart';
import 'package:bahrain_manpower/models/AppInfo/homeSilder.dart';
import 'package:bahrain_manpower/models/Companies/Employees.dart';
import 'package:bahrain_manpower/models/Companies/company.dart';
import 'package:bahrain_manpower/services/Companies/CompaniesService.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/appDataService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/services/workersService.dart';
import 'package:bahrain_manpower/widgets/Employees/employeesListCard.dart';
import 'package:bahrain_manpower/widgets/home_card.dart';
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String categoryId;
  const HomeScreen({Key? key, this.categoryId = "1"}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isSearching = false;
 bool loadingMoreData = false;
  bool isLoadingMoreData = false;
  bool isSearchActive = false;
  bool errorSearch = false;
  bool more = false;
  List<String> filtersValue =["low_rate","high_rate"];
  List<String> filtersTitlesEn =["from High Rating To Low Rating","From Low Rating To High Rating"];
  List<String> filtersTitlesAR =["الترتيب من الاكثر تقيما إلى الاقل تقيما","الترتيب من الأقل تقيما إلى الاكثر تقيما"];

  bool isCategoryOn = true;
  bool isLoadingProducts = false;
  final CarouselController _controller = CarouselController();

  int _current = 0;
  int apiPage = 1;
  int totalProductsInCart = 0;
 String selectedFilter="";
  List<HomeSlider> imgList = [];
   List<Widget?>? child;
   List? photoSliderList;
  List<Company> companies = [];
  List<Employees> cvs = [];

   String? name;
   String? token;
   String? id;
   String? type;

  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();

  Widget changeLangPopUp(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return CupertinoActionSheet(
      title: Text('${AppLocalizations.of(context)?.translate('language')}'),
      message: Text(
          '${AppLocalizations.of(context)?.translate('changeLanguage')}'),
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
        child: const Text('رجوع'),

      ),
    );
  }

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getData();
  }

  getCv() async {
    cvs.addAll(await WorkerService()
        .getWorkerByCompanyCat(id: widget.categoryId, page: apiPage));
    isLoadingProducts = false;
    apiPage++;
    setState(() {});
  }

  getPhotoSlider() async {
    imgList = await AppDataService().getSliderPhotos();

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

              errorWidget: (context, url, error) =>SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                 child: Image.asset("assets/icon/companyplaceholder.png"),
              ),
            ),
          ),
        );
      },
    ).toList();
    setState(() {});
  }

  getCompnaies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = prefs.getString("type");
    id = prefs.getString("id");


    if (more) {
      setState(() {
        loadingMoreData = true;
      });
      apiPage++;
      List<Company> newComs = await CompaniesService().getCompanies(
          widget.categoryId,
          page: apiPage,
          searchKey: searchController.text);
      companies.addAll(newComs);
      if (newComs.isEmpty) {
        more = false;
      }
      setState(() {
        loadingMoreData = false;
      });
    }else{
      companies = await CompaniesService().getCompanies(
          widget.categoryId,
          page: apiPage,
          searchKey: searchController.text);
    }
    isLoading = false;
    setState(() {});
  }

  getData() {
    getCompnaies();
    getPhotoSlider();
  }
  searchingForCompany() async {
    setState(() {
      isSearching=true;
    });

    companies = await CompaniesService().getCompanies(
        widget.categoryId,
        page: apiPage,
        searchKey: searchController.text);
    isSearching=false;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(id, type),
      appBar: AppBar(
        iconTheme:  IconThemeData(color: mainOrangeColor),
        backgroundColor: offWhite,
        title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icon/logoAppBar.png",
                scale: 8, fit: BoxFit.scaleDown)),
        actions: [
          isCategoryOn
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: isSearchActive ? Colors.blue : Colors.white,
                  ),
                  onPressed: () {
                    isSearchActive = !isSearchActive;
                    setState(() {});
                  },
                )
              : Container(),
        ],
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : LazyLoadScrollView(
              scrollOffset: 1000,
              onEndOfPage: () {
                if (isCategoryOn) {
                  more=true;
                  getCompnaies();
                } else {
                  getCv();
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    isSearchActive
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextField(
                                controller: searchController,
                                focusNode: searchNode,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) {
                                  searchNode.unfocus();
                                  apiPage = 1;
                                  getCompnaies();
                                },
                                onChanged: (value) {
                                  apiPage = 1;
                                  getCompnaies();
                                  if (value == "") {
                                    apiPage = 1;
                                    getCompnaies();
                                    setState(() {});
                                  }

                                },
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Color(0xFF0671bf))),
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Color(0xFF0671bf))),
                                    disabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Color(0xFF0671bf))),
                                    focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        searchNode.unfocus();
                                        apiPage = 1;
                                        companies.clear();
                                        searchingForCompany();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.search,
                                        color: searchNode.hasFocus
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                    ),
                                    hintText: "search...",
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 1)),
                              ),
                            ))
                        : Container(),

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                        for(
                        var i=0;i<imgList.length;i++
                        )
                          Container (
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 5.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == i
                                    ? const Color(0xFF0D986A)
                                    : const Color(0xFFD8D8D8)),
                          )

                    ]),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                isCategoryOn = false;
                                isLoadingProducts = true;
                                apiPage = 1;
                                getCv();
                                setState(() {});
                              },
                              child: Container(
                                  color: isCategoryOn
                                      ? Colors.white
                                      : mainOrangeColor,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${AppLocalizations.of(context)?.translate('allCv')}",
                                    style: TextStyle(
                                        color: isCategoryOn
                                            ? Colors.grey[700]
                                            : Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                cvs.clear();
                                setState(() {
                                  isCategoryOn = true;
                                });
                              },
                              child: Container(
                                  color: isCategoryOn
                                      ? mainOrangeColor
                                      : Colors.white,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${AppLocalizations.of(context)?.translate('companies')}",
                                    style: TextStyle(
                                        color: isCategoryOn
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isCategoryOn
                        ?isSearching? Loader(width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height * 0.5,):companies.length==0?
                    SizedBox(
                      width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage("assets/icon/companyplaceholder.png",),
                          ),
                          const SizedBox(height: 20,),
                          Text(Localizations.localeOf(context).languageCode == "en"
                              ?isSearchActive?"no office match this name available":"no office available right now":isSearchActive?"لا يوجد مكتب يطابق هذا الاسم متاح الان":"لا يوجد مكتب متاح الان",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ):ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: loadingMoreData?companies.length+1:companies.length,
                            itemBuilder: (context, index) {
                              return loadingMoreData&&index==companies.length?Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.height * 0.22,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    children: [
                                      Text(Localizations.localeOf(context).languageCode == "en" ?"Loading":"جاري التحميل"),
                                      const SizedBox(width: 10,),
                                      const CircularProgressIndicator()

                                    ],
                                  ),
                                ),
                              ):
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                        builder: (context) =>
                                        CompanyDetailsScreen(
                                              companies[index].social?.facebook,
                                          companies[index].social?.instagram,
                                          companies[index].companymobile,
                                          companies[index].social?.twitter,
                                          companies[index].whatsapp,
                                          companies[index].social?.youtube,
                                          companies[index].companyId,

                                          Localizations.localeOf(context)
                                                      .languageCode ==
                                                  "en"
                                              ? companies[index].companyName
                                              : companies[index].companyName,
                                          const [],
                                          [
                                            companies[index].slider!.picpath,
                                            companies[index].slider!.picpath2,
                                            companies[index].slider!.picpath3
                                          ],
                                          Localizations.localeOf(context)
                                                      .languageCode ==
                                                  "en"
                                              ? "en"
                                              : "ar",
                                          companies[index].clicks??Clicks(facebook: "  ", youtube: "", instagram: "", chat: "", whatsapp: ""),
                                          companies[index].rating == "null"
                                              ? "0"
                                              : companies[index].rating,
                                          companies[index].ratingNo == "null"
                                              ? "0"
                                              : companies[index].ratingNo,
                                          companies[index].map,
                                          companies[index].address??"",
                                          companies[index].details,
                                        ),
                                      ))
                                      .whenComplete(() async {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7),
                                  child: HomeCard(
                                    categoryId: companies[index].companyId,
                                    title: companies[index].companyName ?? "",
                                    image: companies[index].picpath,
                                    address: companies[index].address ?? "",
                                    facebookUrl:
                                        companies[index].social!.facebook ?? "",
                                    instagramUrl:
                                        companies[index].social!.instagram ?? "",
                                    twitterUrl:
                                        companies[index].social!.twitter ?? "",
                                    whatsappUrl:
                                        companies[index].companymobile ?? "",
                                    phone: companies[index].companymobile ?? "",
                                  ),
                                ),
                              );
                            },
                          )
                        : isLoadingProducts
                            ? Loader(width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height * 0.5,)
                            :cvs.length==0?SizedBox(
                        width: MediaQuery.of(context).size.width ,
                          height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage("assets/icon/employerPlaceHolder.png",),
                          ),
                          const SizedBox(height: 20,),
                          Text(Localizations.localeOf(context).languageCode == "en"
                              ?isSearchActive?"no employer match this name available":"no employers available right now":isSearchActive?"لا يوجد موظف  يطابق هذا الاسم متاح الان":"لا يوجد موظفين متحين لان",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ) : ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cvs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: EmployeesCards(
                                      isCompanyProfile: true,
                                      isCV: false,
                                      data: cvs[index],
                                      name: cvs[index].nameAr,
                                      whatsApp: cvs[index].whatsapp,
                                      img: cvs[index].image1,
                                      phone: cvs[index].mobile,
                                      country: cvs[index].nationality?.titleAr??"",
                                      job: cvs[index].occupation?.titleAr??"", onagree: (){print("ho");}, amount: " ", cvId: "", onDelete: (){print("hi delete");},
                                    ),
                                  );
                                })
                  ],
                ),
              ),
            ),
    );
  }
}
