
// ignore_for_file: file_names, unused_field, use_build_context_synchronously, unrelated_type_equality_checks, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bahrain_manpower/Global/theme.dart';
import 'package:bahrain_manpower/Global/utils/helpers.dart';
import 'package:bahrain_manpower/Pages/ChatingScreen/chating_screen.dart';
import 'package:bahrain_manpower/Pages/welcome_screen.dart';
import 'package:bahrain_manpower/models/Companies/Employees.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bahrain_manpower/models/Companies/company.dart';
import 'package:bahrain_manpower/models/Companies/statistics_model.dart';
import 'package:bahrain_manpower/models/other/rating.dart';
import 'package:bahrain_manpower/services/Companies/CompaniesService.dart';
import 'package:bahrain_manpower/services/OtherServices.dart/appDataService.dart';
import 'package:bahrain_manpower/services/notification/notification_services.dart';
import 'package:bahrain_manpower/widgets/Employees/employeesListCard.dart';
import 'package:bahrain_manpower/I10n/app_localizations.dart';
import 'package:bahrain_manpower/models/AppInfo/Filters.dart' as filter;
import 'package:bahrain_manpower/widgets/loader.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


// ignore: must_be_immutable
class CompanyDetailsScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final List subCategory;
  final String lang;
  final String? whatsAppNumber;
  final String? phoneNumber;
  final String? faceBookUrl;
  final String? twitterUrl;
  final String? youtubeUrl;
  final String? instagramUrl;
  final String? map;

   String? rating;
  final String? ratingNo;
  final String address;
  final String? details;
  List<String?> slider = [];
  Clicks clicks;
  CompanyDetailsScreen(
      this.faceBookUrl,
      this.instagramUrl,
      this.phoneNumber,
      this.twitterUrl,
      this.whatsAppNumber,
      this.youtubeUrl,
      this.categoryId,
      this.categoryName,
      this.subCategory,
      this.slider,
      this.lang,
      this.clicks,
      this.rating,
      this.ratingNo,
      this.map,
      this.address,
      this.details, {Key? key}) : super(key: key);

  @override
  CompanyDetailsScreenState createState() => CompanyDetailsScreenState();
}

class CompanyDetailsScreenState extends State<CompanyDetailsScreen>
    with SingleTickerProviderStateMixin {
  StatisticsModel? stats;
   List? imgList;
   List<Widget?>? child;
  int _current = 0;
   bool? isAllCheck;
  bool isLoading = true;
  bool isLoadingMoreData = false;
  bool isLoadingAllData = false;
   ScrollController? _loadMoreDataController;
  int apiPage = 1;
  int myRating = 0;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  bool searchFound = false;
  Rating? rating;
  TabController? tabController;
   GoogleMapController? _mapController;
   final CarouselController _carosuelController = CarouselController();

  bool isExpand = false;
   filter.Occupation? selectedJob;
   filter.Religion? selectedReligon;
   filter.Status? selctedStatus;
   filter.Residence? selectedCity;
   filter.Nationality? selctedNationality;

   late filter.FiltersData data;

  List<Employees> employees = [];

    List<Widget> tabsList=[];
   String? globalSubCategory;

  @override
  void initState() {
    super.initState();

    NotificationServices.checkNotificationAppInForeground(context);

    tabController =
        TabController(length: (widget.subCategory.length + 1), vsync: this);
    _loadMoreDataController = ScrollController();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          iconTheme:  IconThemeData(color: mainOrangeColor),
          backgroundColor: offWhite,
          title: Text(
            "${widget.categoryName}",
            style: const TextStyle(color: Color(0xFF0671bf)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF0671bf),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: isLoading
            ? const Loader()
            : GestureDetector(
                onTap: () => searchFocusNode.unfocus(),
                child: SingleChildScrollView(
                  controller: _loadMoreDataController,
                  child: Column(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      child != null && child!.isNotEmpty
                          ? CarouselSlider.builder(
                        carouselController: _carosuelController,
                        itemCount: child!.length,
                        itemBuilder: (BuildContext context, int index, int realIndex) {
                          return child![index]!;
                        },
                              options: CarouselOptions(
                                autoPlay: child!.length == 1?false:true,
                                enlargeCenterPage: true,
                                scrollPhysics: child!.length == 1?const NeverScrollableScrollPhysics():const BouncingScrollPhysics(),
                                aspectRatio: 2.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                },
                              ),
                            )
                          : Container(),
                      DefaultTabController(
                        length: tabsList.length,
                        child: PreferredSize(
                          preferredSize: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height * 0.15),
                          child: TabBar(
                            isScrollable: true,
                            labelColor: Colors.blue,
                            unselectedLabelColor: const Color(0xFF0671bf),
                            controller: tabController,
                            tabs: tabsList,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[300],

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Image.asset(
                                "assets/icon/callUs.png",
                                scale: 9,
                              ),
                              onPressed: (){
                                getStats();
                                setState(() {

                                });
                                filterDialog();}
                            ),
                            IconButton(
                              icon: Image.asset(
                                "assets/icon/map.png",
                                scale: 9,
                              ),
                              onPressed: () => gMap(),
                            ),
                            IconButton(
                              icon: const Icon(Icons.info),
                              onPressed: () => detailsDialog(),
                            ),
                            GestureDetector(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: mainOrangeColor,
                                   
                                  ),
                                  Text(
                                      "${rating == "" ? 0 : rating?.data?.rating??""} (${widget.ratingNo ?? 0})")
                                ],
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => RatingDialog(
                                    initialRating: myRating.toDouble(),
                                    title: const Text(''),
                                    message: const Text(''),
                                    image: Container(),
                                    submitButtonText: 'send',
                                    onCancelled: () => print('cancelled'),
                                    onSubmitted: (response) async {
                                      String result = "";
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String? id = prefs.getString("id");
                                      String? type = prefs.getString("type");
                                      if (type == "client") {
                                        widget.rating = "${response.rating}";
                                        result=await AppDataService().sendRating(
                                            widget.categoryId,
                                          "${response.rating}",
                                            id!
                                           );

                                        if(result=="success"){
                                          getRating();
                                       }
                                        setState(() {});
                                      } else {
                                        showTheDialog(
                                            context,
                                            "",
                                            AppLocalizations.of(context)
                                                ?.translate('cantRate')??"");
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      employees.isEmpty
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ExpansionTile(
                                        collapsedBackgroundColor:
                                            mainOrangeColor,
                                        initiallyExpanded: isExpand,
                                        onExpansionChanged: (value) {
                                          setState(() {
                                            isExpand = value;
                                          });
                                        },
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.search,
                                              color: isExpand
                                                  ? mainBlueColor
                                                  : Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  ?.translate('searchEmployee')??"",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: isExpand
                                                      ? mainBlueColor
                                                      : Colors.white),
                                            ),
                                          ],
                                        ),
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3.5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                color: mainBlueColor,
                                              ),
                                            ),
                                            child: DropdownButton<
                                                filter.Occupation>(
                                              isExpanded: true,
                                              isDense: true,
                                              hint: Text(
                                                  selectedJob == null ? AppLocalizations.of(context)?.translate('job')??"" : selectedJob!.occupationName??"",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  )),
                                              underline: const SizedBox(),
                                              items: data.occupation!
                                                  .map<
                                                          DropdownMenuItem<
                                                              filter
                                                                  .Occupation>>(
                                                      (value) =>
                                                          DropdownMenuItem<
                                                              filter
                                                                  .Occupation>(
                                                            value: value,
                                                            child: Text(
                                                                Localizations.localeOf(context)
                                                                            .languageCode ==
                                                                        "en"
                                                                    ? value
                                                                        .occupationNameEn??""
                                                                    : value
                                                                        .occupationName??"",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      13,
                                                                )),
                                                          ))
                                                  .toList(),
                                              onChanged: (value) async {
                                                isLoading = true;
                                                setState(() {});
                                                selectedJob = value;
                                                await getData();
                                                isLoading = false;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3.5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                color: mainBlueColor,
                                              ),
                                            ),
                                            child:
                                                DropdownButton<filter.Religion>(
                                              isDense: true,
                                              isExpanded: true,
                                              hint: Text(
                                                  selectedReligon == null
                                                      ? AppLocalizations.of(
                                                              context)
                                                          ?.translate('religion')??""
                                                      : selectedReligon!
                                                          .religionName??"",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  )),
                                              underline: const SizedBox(),
                                              items: data.religion!
                                                  .map<
                                                          DropdownMenuItem<
                                                              filter.Religion>>(
                                                      (value) =>
                                                          DropdownMenuItem<
                                                              filter.Religion>(
                                                            value: value,
                                                            child: Text(
                                                                Localizations.localeOf(context)
                                                                            .languageCode ==
                                                                        "en"
                                                                    ? value
                                                                        .religionNameEn??""
                                                                    : value
                                                                        .religionName??"",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 13,
                                                                )),
                                                          ))
                                                  .toList(),
                                              onChanged: (value) async {
                                                isLoading = true;
                                                setState(() {});
                                                selectedReligon = value;
                                                await getData();
                                                isLoading = false;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 3.5),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(5)),
                                                border: Border.all(
                                                  color: mainBlueColor,
                                                ),
                                              ),
                                              child:
                                                  DropdownButton<filter.Status>(
                                                isDense: true,
                                                isExpanded: true,
                                                hint: Text(
                                                    selctedStatus == null
                                                        ? AppLocalizations.of(
                                                                context)
                                                            ?.translate(
                                                                'socialStatus')??""
                                                        : selctedStatus!
                                                            .statusName??"",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    )),
                                                underline: const SizedBox(),
                                                items: data.status!
                                                    .map<
                                                            DropdownMenuItem<
                                                                filter.Status>>(
                                                        (value) =>
                                                            DropdownMenuItem<
                                                                filter.Status>(
                                                              value: value,
                                                              child: Text(
                                                                  Localizations.localeOf(context)
                                                                              .languageCode ==
                                                                          "en"
                                                                      ? value
                                                                          .statusNameEn??""
                                                                      : value
                                                                          .statusName??"",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                  )),
                                                            ))
                                                    .toList(),
                                                onChanged: (value) async {
                                                  isLoading = true;
                                                  setState(() {});
                                                  selctedStatus = value;
                                                  await getData();
                                                  isLoading = false;
                                                  setState(() {});
                                                },
                                              )),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3.5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                color: mainBlueColor,
                                              ),
                                            ),
                                            child: DropdownButton<
                                                filter.Residence>(
                                              isDense: true,
                                              isExpanded: true,
                                              hint: Text(
                                                  selectedCity == null
                                                      ? AppLocalizations.of(
                                                              context)
                                                          ?.translate('city')??""
                                                      : selectedCity!
                                                          .residenceName??"",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  )),
                                              underline: const SizedBox(),
                                              items: data.residence!
                                                  .map<
                                                          DropdownMenuItem<
                                                              filter
                                                                  .Residence>>(
                                                      (value) =>
                                                          DropdownMenuItem<
                                                              filter.Residence>(
                                                            value: value,
                                                            child: Text(
                                                                Localizations.localeOf(context)
                                                                            .languageCode ==
                                                                        "en"
                                                                    ? value
                                                                        .residenceNameEn??""
                                                                    : value
                                                                        .residenceName??"",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 13,
                                                                )),
                                                          ))
                                                  .toList(),
                                              onChanged: (value) async {
                                                selectedCity = value;
                                                isLoading = true;
                                                setState(() {});
                                                await getData();
                                                isLoading = false;
                                                setState(() {});
                                                getData();
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3.5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                color: mainBlueColor,
                                              ),
                                            ),
                                            child: DropdownButton<
                                                filter.Nationality>(
                                              isDense: true,
                                              isExpanded: true,
                                              hint: Text(
                                                  selctedNationality == null
                                                      ? AppLocalizations.of(
                                                              context)
                                                          ?.translate(
                                                              'nationality')??""
                                                      : selctedNationality!
                                                          .nationalityName??"",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  )),
                                              underline: const SizedBox(),
                                              items: data.nationality!
                                                  .map<
                                                          DropdownMenuItem<
                                                              filter
                                                                  .Nationality>>(
                                                      (value) =>
                                                          DropdownMenuItem<
                                                              filter
                                                                  .Nationality>(
                                                            value: value,
                                                            child: Text(
                                                                Localizations.localeOf(context)
                                                                            .languageCode ==
                                                                        "en"
                                                                    ? value
                                                                        .nationalityNameEn??""
                                                                    : value
                                                                        .nationalityName??"",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 13,
                                                                )),
                                                          ))
                                                  .toList(),
                                              onChanged: (value) async {
                                                selctedNationality = value;
                                                isLoading = true;
                                                setState(() {});
                                                await getData();
                                                isLoading = false;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                      isLoadingAllData
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              50)),
                                  const Text(
                                    "جارى التحميل",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const Padding(padding: EdgeInsets.only(top: 30)),
                                  const CircularProgressIndicator(),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              50)),
                                ],
                              ),
                            )
                          : employees.isEmpty
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        widget.details ?? "",
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        widget.address,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: widget.map == "null" ||
                                                widget.map == ""
                                            ? const Center(
                                                child: Text(
                                                    "لا يوجد موقع محدد الان"),
                                              )
                                            : GoogleMap(
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target: widget.map ==
                                                              "null" ||
                                                          widget.map == ""
                                                      ? const LatLng(0, 0)
                                                      : LatLng(
                                                          double.parse(widget
                                                              .map!
                                                              .split(",")[0]),
                                                          double.parse(widget
                                                              .map!
                                                              .split(",")[1])),
                                                  zoom: 19.151926040649414,
                                                ),
                                                onMapCreated:
                                                    (GoogleMapController
                                                        controller) {
                                                  _mapController = controller;
                                                  setState(() {});
                                                },
                                                markers: {
                                                  Marker(
                                                    // This marker id can be anything that uniquely identifies each marker.
                                                    markerId: const MarkerId(
                                                        "currentState"),
                                                    position: widget.map ==
                                                                "null" ||
                                                            widget.map == ""
                                                        ? const LatLng(0, 0)
                                                        : LatLng(
                                                            double.parse(widget
                                                                .map!
                                                                .split(",")[0]),
                                                            double.parse(widget
                                                                .map!
                                                                .split(
                                                                    ",")[1])),
                                                    infoWindow: InfoWindow(
                                                      // title is the address
                                                      title:
                                                          "${widget.categoryName}",
                                                      // snippet are the coordinates of the position
                                                      snippet:
                                                          '${widget.categoryName}',
                                                    ),
                                                    icon: BitmapDescriptor
                                                        .defaultMarker,
                                                  )
                                                },
                                                liteModeEnabled: true,
                                              )),
                                  ],
                                )
                              : ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: employees.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: EmployeesCards(
                                        companyID: widget.categoryId??"",
                                        isCompanyProfile: true,
                                        isCV: false,
                                        data: employees[index],
                                        name: employees[index].nameAr,
                                        whatsApp: employees[index].whatsapp,
                                        img: employees[index].image1,
                                        phone: employees[index].mobile,
                                        country: employees[index]
                                            .nationality!
                                            .titleAr,
                                        job:
                                            employees[index].occupation!.titleAr,
                                      ),
                                    );
                                  },
                                )
                    ],
                  ),
                ),
              ));
  }

  getAllData() async {
    await getRating();
    await getStats();
    await initListOfTabs();
    await getData();
    await getFilters();
    photoSlider();
    isLoading = false;
    setState(() {});
  }
  getStats() async {
    stats = await CompaniesService().getStatistics(widget.categoryId??"");

  }
   getRating() async {
     rating = await CompaniesService().getRating(widget.categoryId??"");
   }
  getData() async {
    employees = await CompaniesService().getEmployees(widget.categoryId,
        job: selectedJob?.occupationId ?? "",
        city: selectedCity?.residenceId ?? "",
        religion: selectedReligon?.religionId ?? "",
        nationality: selctedNationality?.nationalityId ?? "",
        status: selctedStatus?.statusId ?? "");
  }

  getFilters() async {
    data = await AppDataService().getFilters();
  }
   detectNullPhotosUrl(List<String?>  imageURLS){
     List<String?> imgPass =[];
     for(int i = 0;i<imageURLS.length;i++){
       if(imageURLS[i]!="https://manpower-kw.com/uploads/0"&&imageURLS[i]!="https://manpower-kw.com/uploads/no-image-available.jpg"){

         imgPass.add(imageURLS[i]);

       }

     }
     return imgPass;
   }
  photoSlider() async {
    List<String?> paths= detectNullPhotosUrl(widget.slider);
    child = map<Widget>(
      paths,
      (index, i) {
        return Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: CachedNetworkImage(
              imageUrl: i,
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

  }

  Future<void> gMap() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: widget.map == "null" || widget.map == ""
                        ? const Center(
                            child: Text("لا يوجد موقع محدد الان"),
                          )
                        : GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: widget.map == "null" || widget.map == ""
                                  ? const LatLng(0, 0)
                                  : LatLng(
                                      double.parse(widget.map!.split(",")[0]),
                                      double.parse(widget.map!.split(",")[1])),
                              zoom: 19.151926040649414,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                              setState(() {});
                            },
                            markers: {
                              Marker(
                                // This marker id can be anything that uniquely identifies each marker.
                                markerId: const MarkerId("currentState"),
                                position: widget.map == "null" ||
                                        widget.map == ""
                                    ? const LatLng(0, 0)
                                    : LatLng(
                                        double.parse(widget.map!.split(",")[0]),
                                        double.parse(widget.map!.split(",")[1])),
                                infoWindow: InfoWindow(
                                  // title is the address
                                  title: "${widget.categoryName}",
                                  // snippet are the coordinates of the position
                                  snippet: '${widget.categoryName}',
                                ),
                                icon: BitmapDescriptor.defaultMarker,
                              )
                            },
                            liteModeEnabled: true,
                          )),
              );
            });
          },
        );
      },
    );
  }
   _launchURL(String url,String nameOfSocialProgram) async {
     if(url == "" || url == "https://wa.me/" || url == "tel:"){
       _showDialog(Localizations.localeOf(context).languageCode == "en"
           ?"the $nameOfSocialProgram is not available at the moment": "منصة $nameOfSocialProgram  غير متاحه الان",  Localizations.localeOf(context).languageCode == "en"
           ?"sorry":"عذرا",false);
     }
     if (await launchUrl(Uri.parse(url))) {

     } else {
       throw 'Could not launch $url';
     }
   }

   sendClick(id, socialMedia) async {
     await CompaniesService().socialMediaClicked(id, socialMedia).then((value) => {
       getStats(),
     setState(() {}),
     });


   }
   void _showDialog(String content,String title,bool signing) {
     // flutter defined function
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

  Future<void> filterDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const Padding(padding:   EdgeInsets.only(top: 15)),
                      Text(
                        "${widget.categoryName}",
                        style: const TextStyle(
                          color: Color(0xFF0671bf),
                        ),
                      ),
                      const Padding(padding:  EdgeInsets.only(top: 10)),
                      InkWell(
                        onTap: () {  _launchURL("https://wa.me/${widget.whatsAppNumber}","whatsapp");
                        sendClick(widget.categoryId, "whatsapp");
                          },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/whatsappBar.jpg",
                                scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "whatsapp",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF34bc48)),
                                    ),
                                    Text(stats?.data?.whatsapp??"0",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/whatsappIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {

                          detectUserType();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/messageBar.gif", scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "chat with us",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF79002d)),
                                    ),
                                    Text("${widget.clicks.chat}",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/messageIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL("tel:${widget.phoneNumber}","mobile");
                          sendClick(widget.categoryId, "mobile");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/dialerBar.gif", scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "call us",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF008000)),
                                    ),
                                    Text(stats?.data?.mobile??"0",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/dialerIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL("${widget.faceBookUrl}","facebook");
                          sendClick(widget.categoryId, "facebook");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/facebookBar.gif",
                                scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "facebook",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF3f5ca4)),
                                    ),
                                    Text(stats?.data?.facebook??"0",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/facebookIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL("${widget.youtubeUrl}","youtube");
                          sendClick(widget.categoryId, "youtube");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/youtubeBar.gif", scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "youtube",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFFcb0f0f)),
                                    ),
                                    Text(stats?.data?.youtube??"0",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/youtubeIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL("${widget.twitterUrl}","twitter");
                          sendClick(widget.categoryId, "twitter");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/twitterBar.jpg", scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "twitter",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF82c9f9)),
                                    ),
                                    Text(stats?.data?.twitter??"0",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/twitterIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL("${widget.instagramUrl}","instagram");
                          sendClick(widget.categoryId, "instagram");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icon/instagramBar.gif",
                                scale: 2),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "instagram",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFFf2785e)),
                                    ),
                                    Text(stats?.data?.instagram??"0",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey))
                                  ],
                                ),
                                Image.asset(
                                  "assets/icon/instagramIcon.gif",
                                  scale: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 100,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: const Color(0xFF0671bf)),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "رجوع",
                            style: TextStyle(color: Color(0xFF0671bf)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
   detectUserType() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();

     if (prefs.containsKey("id")){
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) =>  ChattingScreen(reciverId: widget.categoryId!,)),
       );
     }else{
       Localizations.localeOf(context).languageCode == "en"
           ?_showDialog("please sign in or sign up first", "you can't with this office",true):_showDialog("يجب عليك ان تسجل دخولك أولا أو تقوم بإنشاء حساب", "لا يمكنك التحدث مع هذا المكتب",true);
     }
   }

  Future<void> detailsDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      Text(
                        "${widget.categoryName}",
                        style: const TextStyle(
                          color: Color(0xFF0671bf),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.details ?? ""),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 100,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: const Color(0xFF0671bf)),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "رجوع",
                            style: TextStyle(color: Color(0xFF0671bf)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  initListOfTabs() {
    tabsList.add(InkWell(
      onTap: () async {
        tabController!.animateTo(0);
        apiPage = 1;
      },
      child: Column(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF0671bf),
            child: Icon(
              Icons.category,
              color: Colors.white,
            ),
          ),
          Text(
            widget.lang == "en" ? "all categories" : "كل الاقسام",
            style: const TextStyle(fontSize: 14),
          )
        ],
      ),
    ));

    for (int i = 0; i < widget.subCategory.length; i++) {
      tabsList.add(InkWell(
        onTap: () async {
          tabController!.animateTo(i + 1);
          apiPage = 1;
          globalSubCategory = widget.subCategory[i].id;
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("${widget.subCategory[i].image}"),
            ),
            Text(
              "${widget.lang == "en" ? widget.subCategory[i].titleEn : widget.subCategory[i].titleAr}",
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
      ));
    }
  }
}
