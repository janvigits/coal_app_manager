import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coal_app_manager/Home/upcomingVesselDetails.dart';
import 'package:coal_app_manager/Home/upcomingVesselSeeAll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AuthScreens/login_page.dart';
import '../Core/custom_color.dart';
import '../main.dart';
import 'banner_getter_setter.dart';
import 'blogSeeAll.dart';
import 'liveProductDetails.dart';
import 'liveProductSeeAll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;
  int userId = 0;
  var bannerImageJsonResponse, userStatusJsonResponse;
  List<bannerGetterSetter> bannerGetterSetterList = [];
  List<dynamic> blogList = [];
  List<String> imgList = [];

  var jsonVersionDetailsResponse;
  PackageInfo? packageInfo;
  String language = '';
  BuildContext? dialogContext;
  bool bannerLoad = false;

  List<dynamic> upcomingVesselList = [];
  List<dynamic> liveProductsList = [];

//https://www.bbedut.com/bbedut_coalMines/WS/productData.php?method=productList&productTypeId=1&limit=0
  Future<String> upcomingVesselListApi() async {
    upcomingVesselList = [];
    String url = MyApp.appURL +
        "/WS/productData.php?method=productList&productTypeId=" +
        1.toString() +
        "&limit=0";
    print(url);
    try {
      var result = await http.get(Uri.parse(url));

      setState(() {
        var jsonResponse = json.decode(result.body);
        upcomingVesselList = jsonResponse['data'];

        print("list:" + upcomingVesselList.toString());
      });
    } on Exception catch (exception) {
      if (exception.toString().contains("HandshakeException")) {}
      print("hel" + exception.toString());
      // only executed if error is of type Exception
    } catch (error) {
      print("hel1" + error.toString());
      // executed for errors of all types other than Exception
    }
    return "Success";
  }

  Future<String> liveProductsListApi() async {
    liveProductsList = [];
    String url = MyApp.appURL +
        "/WS/productData.php?method=productList&productTypeId=" +
        2.toString() +
        "&limit=0";
    print(url);
    try {
      var result = await http.get(Uri.parse(url));

      setState(() {
        var jsonResponse = json.decode(result.body);
        liveProductsList = jsonResponse['data'];

        print("list:" + liveProductsList.toString());
      });
    } on Exception catch (exception) {
      if (exception.toString().contains("HandshakeException")) {}
      print("hel" + exception.toString());
      // only executed if error is of type Exception
    } catch (error) {
      print("hel1" + error.toString());
      // executed for errors of all types other than Exception
    }
    return "Success";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPackageInfo();
    _incrementCounter();
    getBannerImages();
    getBlogList();
    upcomingVesselListApi();
    liveProductsListApi();
  }

  _incrementCounter() async {
    print("onTap:");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // counterValue = (prefs.getInt('userId'))!;
    setState(() {
      userId = prefs.getInt('userId')!;
      language = prefs.getString('lang')!;

      updateDeviceToken();
      getUserStatus();
    });
  }

  // https://www.bbedut.com/bbedut_coalMines/WS/loginData.php?method=getUserStatus&userId=9
  Future<String> getUserStatus() async {
    String url = MyApp.appURL +
        "/WS/loginData.php?method=getUserStatus&userId=" +
        userId.toString();
    print("url:" + url);
    try {
      var result = await http.get(Uri.parse(url));
      // return json.decode(result.body)['data'];
      // print(jsonResponse['data'][0]['Class']);
      setState(() {
        userStatusJsonResponse = json.decode(result.body);
        if (userStatusJsonResponse['isActive'] == 0) {
          logoutPopup(context, userStatusJsonResponse['msg']);
        }
      });
    } on Exception catch (exception) {
      if (exception.toString().contains("HandshakeException")) {
        getBannerImages();
      }
      print("hel" + exception.toString());
      // only executed if error is of type Exception
    } catch (error) {
      print("hel1" + error.toString());
      // executed for errors of all types other than Exception
    }
    return "Success";
  }

  Future<String> getBannerImages() async {
    bannerLoad = true;
    bannerGetterSetterList = [];
    imgList = [];
    String url = MyApp.appURL + "/WS/loginData.php?method=getBannerImages";
    print("url:" + url);
    try {
      var result = await http.get(Uri.parse(url));
      // return json.decode(result.body)['data'];
      // print(jsonResponse['data'][0]['Class']);
      setState(() {
        bannerImageJsonResponse = json.decode(result.body);

        var tagObjsJson = bannerImageJsonResponse['data'] as List;

        bannerGetterSetterList = tagObjsJson
            .map((tagJson) => bannerGetterSetter.fromJson(tagJson))
            .toList();
        print("name: " + bannerGetterSetterList[0].imageUrl);

        for (int i = 0; i < bannerGetterSetterList.length; i++) {
          imgList.add(bannerGetterSetterList[i].imageUrl);
        }
        bannerLoad = false;
      });
    } on Exception catch (exception) {
      if (exception.toString().contains("HandshakeException")) {
        getBannerImages();
      }
      print("hel" + exception.toString());
      // only executed if error is of type Exception
    } catch (error) {
      print("hel1" + error.toString());
      // executed for errors of all types other than Exception
    }
    return "Success";
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
      versionDetails();
    });
  }

  Future<String> versionDetails() async {
    String url = MyApp.appURL + "/WS/loginData.php?method=getVersionCode";
    print("url: " + url);
    var result = await http.get(Uri.parse(url));
    jsonVersionDetailsResponse = json.decode(result.body);
    print("version:" + jsonVersionDetailsResponse.toString());

    print("version:" + int.parse(packageInfo!.buildNumber).toString());
    print("version1:" + int.parse(packageInfo!.buildNumber).toString());
    if (Platform.isAndroid) {
      if (jsonVersionDetailsResponse['androidMinVersionCode'] >
          int.parse(packageInfo!.buildNumber)) {
        showMandatoryVersionUpdateAlertDialog(context);
      } else {
        if (jsonVersionDetailsResponse['androidVersionCode'] >
            int.parse(packageInfo!.buildNumber)) {
          showVersionUpdateAlertDialog(context);
        }
      }
    }
    print("title: " + result.body.toString());
    return "Success";
  }

  showVersionUpdateAlertDialog(BuildContext context) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      //this right here
      child: Container(
        height: 230.0,
        width: 300.0,
        decoration: new BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
                bottomLeft: const Radius.circular(20.0),
                bottomRight: const Radius.circular(20.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Version Update',
                style: TextStyle(color: Color(0xffacacac), fontSize: 18.0),
              ),
            ),
            Stack(children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Text(
                      'Please update your App from Play Store with latest Features',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Color(0xff000000), fontSize: 15.0),
                    ),
                  ))
            ]),
            Padding(padding: EdgeInsets.only(top: 30.0)),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');

                            // LaunchReview.launch(writeReview: false);
                            OpenStore.instance.open(
                              appStoreId: '',
                              // AppStore id of your app
                              androidAppBundleId:
                                  'com.carriergoods.transport', // Android app bundle package name
                            );
                            setState(() {});
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(
                                color: Color(0xff000000), fontSize: 16.0),
                          ))),
                  Container(
                    width: 1,
                    height: 15, // Thickness
                    color: Color(0xff707070),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                                color: Color(0xffb94d25), fontSize: 16.0),
                          )))
                ])
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  showMandatoryVersionUpdateAlertDialog(BuildContext context) {
    Dialog errorDialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        //this right here
        child: WillPopScope(
          onWillPop: () async => false,
          child: Container(
            height: 240.0,
            width: 300.0,
            decoration: new BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                    bottomLeft: const Radius.circular(20.0),
                    bottomRight: const Radius.circular(20.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Version Update',
                    style: TextStyle(color: Color(0xffacacac), fontSize: 18.0),
                  ),
                ),
                Stack(children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Text(
                          "Since you are using an old version which we don't support now, so please update your App from Play Store with latest Features",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff000000), fontSize: 15.0),
                        ),
                      ))
                ]),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                // LaunchReview.launch().then((value) => versionDetails());
                                OpenStore.instance.open(
                                  appStoreId: '',
                                  // AppStore id of your app
                                  androidAppBundleId:
                                      'com.carriergoods.transport', // Android app bundle package name
                                );
                                setState(() {});
                              },
                              child: Text(
                                'Update',
                                style: TextStyle(
                                    color: Color(0xff000000), fontSize: 16.0),
                              ))),
                    ])
              ],
            ),
          ),
        ));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => errorDialog);
    dialogContext = context;
  }

  logoutPopup(BuildContext context, String msg) {
    Dialog errorDialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        //this right here
        child: WillPopScope(
          onWillPop: () async => false,
          child: Container(
            height: 240.0,
            width: 300.0,
            decoration: new BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                    bottomLeft: const Radius.circular(20.0),
                    bottomRight: const Radius.circular(20.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Color(0xffacacac), fontSize: 18.0),
                  ),
                ),
                Stack(children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Text(
                          msg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff000000), fontSize: 15.0),
                        ),
                      ))
                ]),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                // LaunchReview.launch().then((value) => versionDetails());
                                logout(0, "");
                                setState(() {});
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                    color: Color(0xff000000), fontSize: 16.0),
                              ))),
                    ])
              ],
            ),
          ),
        ));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => errorDialog);
    dialogContext = context;
  }

  logout(int userId, String name) async {
    print("onTap:");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', 0);
    await prefs.setString('name', "");
    // Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

  //https://www.bbedut.com/bbedut_coalMines/WS/loginData.php?method=blogList&userId=&limit=
  Future<String> getBlogList() async {
    blogList = [];
    String url = MyApp.appURL +
        "/WS/loginData.php?method=blogList&userId=" +
        userId.toString() +
        "&limit=0";
    print("url:" + url);
    try {
      var result = await http.get(Uri.parse(url));
      // return json.decode(result.body)['data'];
      // print(jsonResponse['data'][0]['Class']);
      setState(() {
        var jsonResponse = json.decode(result.body);
        blogList = jsonResponse['data'] as List;
      });
    } on Exception catch (exception) {
      if (exception.toString().contains("HandshakeException")) {
        getBannerImages();
      }
      print("hel" + exception.toString());
      // only executed if error is of type Exception
    } catch (error) {
      print("hel1" + error.toString());
      // executed for errors of all types other than Exception
    }
    return "Success";
  }

  Future<String> updateDeviceToken() async {
    blogList = [];
    String url = MyApp.appURL +
        "/WS/loginData.php?method=updateDeviceToken&userId=" +
        userId.toString() +
        "&deviceToken=" +
        MyApp.deviceToken;
    print("url:" + url);
    try {
      var result = await http.get(Uri.parse(url));
      // return json.decode(result.body)['data'];
      // print(jsonResponse['data'][0]['Class']);

    } on Exception catch (exception) {
      if (exception.toString().contains("HandshakeException")) {
        getBannerImages();
      }
      print("hel" + exception.toString());
      // only executed if error is of type Exception
    } catch (error) {
      print("hel1" + error.toString());
      // executed for errors of all types other than Exception
    }
    return "Success";
  }

  bannerImages(image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
            imageUrl: image,
            width: double.infinity,
            fit: BoxFit.fill,
            imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                ),
            placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
            errorWidget: (context, url, error) => Container(
                  color: CustomTheme.greyButtonColor,
                )),

        // Image.network(
        //   "$base" + "${data['slider_img']}",
        //   width: double.infinity,
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }

//https://www.bbedut.com/bbedut_coalMines/WS/loginData.php?method=getBannerImages

  String k_m_b_generator(num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          color: Colors.white,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('Oflutter.com'),
                accountEmail: Text('example@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
                ),
              ),
              Container(
                color: CustomTheme.white,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('Favorites'),
                      onTap: () => null,
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Friends'),
                      onTap: () => null,
                    ),
                    ListTile(
                      leading: Icon(Icons.share),
                      title: Text('Share'),
                      onTap: () => null,
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Request'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () => null,
                    ),
                    ListTile(
                      leading: Icon(Icons.description),
                      title: Text('Policies'),
                      onTap: () => null,
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Exit'),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () => null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: CustomTheme.bgColor,
        appBar: AppBar(
            backgroundColor: CustomTheme.bgColor,
            elevation: 0,
            title: Text(""),
            centerTitle: true,
            actions: [
              Row(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.message,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        left: 17,
                        bottom: 17,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red),
                          child: Center(
                            child: Text(
                              "10",
                              style: TextStyle(
                                  fontSize: 8, color: CustomTheme.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.notifications,
                          size: 20,
                          color: CustomTheme.white,
                        ),
                      ),
                      Positioned(
                        left: 17,
                        bottom: 17,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red),
                          child: Center(
                            child: Text(
                              "10",
                              style: TextStyle(
                                  fontSize: 8, color: CustomTheme.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            ]),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.width * 0.45,
                  child: Column(
                    children: [
                      bannerLoad == true
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : CarouselSlider.builder(
                              itemCount: imgList.length,
                              itemBuilder: (context, index, _) {
                                dynamic data = imgList[index];

                                return GestureDetector(
                                  onTap: () {
                                    //miniStore(data);
                                  },
                                  child: bannerImages(imgList[index]),
                                );
                              },
                              options: CarouselOptions(
                                height:
                                    MediaQuery.of(context).size.width * 0.35,
                                viewportFraction: 1.0,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                reverse: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                },
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imgList.map(
                          (image) {
                            int index = imgList.indexOf(image);
                            return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == index
                                      ? CustomTheme.white
                                      : Colors.grey,
                                ));
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upcoming Vessel",
                      style: TextStyle(color: CustomTheme.white, fontSize: 16),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => upcomingVesselSeeAll(),
                            ));
                      },
                      child: Text(
                        "See All",
                        style: TextStyle(
                            color: CustomTheme.orengeTextColor, fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 220,
                  // margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: ListView.builder(
                    itemCount: upcomingVesselList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => upcomingVesselDetails(
                                  vesselName: upcomingVesselList[index]
                                          ['vesselName']
                                      .toString(),
                                  country: upcomingVesselList[index]
                                          ['fromCountry']
                                      .toString(),
                                  port: upcomingVesselList[index]['portName']
                                      .toString(),
                                  estArrivalDate: upcomingVesselList[index]
                                          ['estArrivalDate']
                                      .toString(),
                                  regionNAme: upcomingVesselList[index]
                                          ['regionName']
                                      .toString(),
                                  regionId: upcomingVesselList[index]
                                      ['regionId'],
                                  coalType: upcomingVesselList[index]
                                          ['coalTypeName']
                                      .toString(),
                                  calorificValue: upcomingVesselList[index]
                                          ['calorificValue']
                                      .toString(),
                                  totalMoisture: upcomingVesselList[index]
                                          ['totalMoisture']
                                      .toString(),
                                  ashContent: upcomingVesselList[index]
                                          ['ashContent']
                                      .toString(),
                                  estRate: upcomingVesselList[index]['coalQty']
                                      .toString(),
                                  coalTypeImage: upcomingVesselList[index]
                                          ['coalTypeImage']
                                      .toString(),
                                  productId: upcomingVesselList[index]
                                          ['productId']
                                      .toString(),
                                  inherentMoisture: upcomingVesselList[index]
                                          ['inherentMoisture']
                                      .toString(),
                                  volatileMatter: upcomingVesselList[index]
                                          ['volatileMatter']
                                      .toString(),
                                  sulphur: upcomingVesselList[index]['sulphur']
                                      .toString(),
                                  fixedCarbon: upcomingVesselList[index]
                                          ['fixedCarbon']
                                      .toString(),
                                  hardgroveGrindabilityIndex:
                                      upcomingVesselList[index]
                                              ['hardgroveGrindabilityIndex']
                                          .toString(),
                                  size: upcomingVesselList[index]['size']
                                      .toString(),
                                  phosphorus: upcomingVesselList[index]
                                          ['phosphorus']
                                      .toString(),
                                  csr: upcomingVesselList[index]['csr']
                                      .toString(),
                                  cri: upcomingVesselList[index]['cri']
                                      .toString(),
                                  aftId: upcomingVesselList[index]['aftId']
                                      .toString(),
                                  aftFt: upcomingVesselList[index]['aftFt']
                                      .toString(),
                                  aftHt: upcomingVesselList[index]['aftHt']
                                      .toString(),
                                  csn: upcomingVesselList[index]['csn']
                                      .toString(),
                                  ncv: upcomingVesselList[index]['ncv']
                                      .toString(),
                                ),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 0, top: 10, bottom: 10),
                          child: Container(
                            // height: 190,
                            width: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              // color: Colors.red
                              color: CustomTheme.boxColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: CustomTheme.buttonColor,
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          upcomingVesselList[index]
                                                  ['coalTypeImage']
                                              .toString(),
                                          height: 30,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    upcomingVesselList[index]['vesselName']
                                        .toString(),
                                    style: TextStyle(
                                        color: CustomTheme.buttonColor,
                                        fontSize: 14),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Coal Type",
                                                style: TextStyle(
                                                    color: CustomTheme
                                                        .orengeTextColor,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                upcomingVesselList[index]
                                                        ['coalTypeName']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: CustomTheme.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Arrival Date",
                                                style: TextStyle(
                                                    color: CustomTheme
                                                        .orengeTextColor,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                upcomingVesselList[index]
                                                        ['estArrivalDate']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: CustomTheme.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Country",
                                                style: TextStyle(
                                                    color: CustomTheme
                                                        .orengeTextColor,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                upcomingVesselList[index]
                                                        ['fromCountry']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: CustomTheme.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Port",
                                                style: TextStyle(
                                                    color: CustomTheme
                                                        .orengeTextColor,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                upcomingVesselList[index]
                                                        ['portName']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: CustomTheme.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "₹ " +
                                        upcomingVesselList[index]['coalQty']
                                            .toString(),
                                    style: TextStyle(
                                        color: CustomTheme.buttonColor,
                                        fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Live Products",
                      style: TextStyle(color: CustomTheme.white, fontSize: 16),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => liveProductSeeAll(),
                            ));
                      },
                      child: Text(
                        "See All",
                        style: TextStyle(
                            color: CustomTheme.orengeTextColor, fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 220,
                  // margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: ListView.builder(
                    itemCount: liveProductsList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => liveProductDetails(
                                  vesselName: liveProductsList[index]
                                          ['vesselName']
                                      .toString(),
                                  country: liveProductsList[index]
                                          ['fromCountry']
                                      .toString(),
                                  port: liveProductsList[index]['portName']
                                      .toString(),
                                  estArrivalDate: liveProductsList[index]
                                          ['arrivalDate']
                                      .toString(),
                                  regionNAme: liveProductsList[index]
                                          ['regionName']
                                      .toString(),
                                  regionId: liveProductsList[index]['regionId'],
                                  coalType: liveProductsList[index]
                                          ['coalTypeName']
                                      .toString(),
                                  calorificValue: liveProductsList[index]
                                          ['calorificValue']
                                      .toString(),
                                  totalMoisture: liveProductsList[index]
                                          ['totalMoisture']
                                      .toString(),
                                  ashContent: liveProductsList[index]
                                          ['ashContent']
                                      .toString(),
                                  estRate: liveProductsList[index]['coalQty']
                                      .toString(),
                                  coalTypeImage: liveProductsList[index]
                                          ['coalTypeImage']
                                      .toString(),
                                  productId: liveProductsList[index]
                                          ['productId']
                                      .toString(),
                                  inherentMoisture: liveProductsList[index]
                                          ['inherentMoisture']
                                      .toString(),
                                  volatileMatter: liveProductsList[index]
                                          ['volatileMatter']
                                      .toString(),
                                  sulphur: liveProductsList[index]['sulphur']
                                      .toString(),
                                  fixedCarbon: liveProductsList[index]
                                          ['fixedCarbon']
                                      .toString(),
                                  hardgroveGrindabilityIndex:
                                      liveProductsList[index]
                                              ['hardgroveGrindabilityIndex']
                                          .toString(),
                                  size: liveProductsList[index]['size']
                                      .toString(),
                                  phosphorus: liveProductsList[index]
                                          ['phosphorus']
                                      .toString(),
                                  csr:
                                      liveProductsList[index]['csr'].toString(),
                                  cri:
                                      liveProductsList[index]['cri'].toString(),
                                  aftId: liveProductsList[index]['aftId']
                                      .toString(),
                                  aftFt: liveProductsList[index]['aftFt']
                                      .toString(),
                                  aftHt: liveProductsList[index]['aftHt']
                                      .toString(),
                                  csn:
                                      liveProductsList[index]['csn'].toString(),
                                  ncv:
                                      liveProductsList[index]['ncv'].toString(),
                                ),
                              ));
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 0, top: 10, bottom: 10),
                              child: Container(
                                // height: 180,
                                width: 170,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  // color: Colors.red
                                  color: CustomTheme.boxColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: CustomTheme.buttonColor,
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(
                                              liveProductsList[index]
                                                      ['coalTypeImage']
                                                  .toString(),
                                              height: 30,
                                            )),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        liveProductsList[index]['vesselName']
                                            .toString(),
                                        style: TextStyle(
                                            color: CustomTheme.buttonColor,
                                            fontSize: 14),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Coal Type",
                                                    style: TextStyle(
                                                        color: CustomTheme
                                                            .orengeTextColor,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    liveProductsList[index]
                                                            ['coalTypeName']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            CustomTheme.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Arrival Date",
                                                    style: TextStyle(
                                                        color: CustomTheme
                                                            .orengeTextColor,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    liveProductsList[index]
                                                            ['arrivalDate']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            CustomTheme.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Country",
                                                    style: TextStyle(
                                                        color: CustomTheme
                                                            .orengeTextColor,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    liveProductsList[index]
                                                            ['fromCountry']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            CustomTheme.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Port",
                                                    style: TextStyle(
                                                        color: CustomTheme
                                                            .orengeTextColor,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    liveProductsList[index]
                                                            ['portName']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            CustomTheme.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "₹ " +
                                            liveProductsList[index]['coalQty']
                                                .toString(),
                                        style: TextStyle(
                                            color: CustomTheme.buttonColor,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 5,
                              child: Container(
                                height: 10,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: CustomTheme.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                        topRight: Radius.circular(2),
                                        bottomRight: Radius.circular(2))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 5,
                                      width: 5,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.red),
                                    ),
                                    Text(
                                      "Live",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 8),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Blog",
                        style:
                            TextStyle(color: CustomTheme.white, fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    blogSeeAll(userId: userId),
                              ));
                        },
                        child: Text(
                          "See All",
                          style: TextStyle(
                              color: CustomTheme.orengeTextColor, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 100.0,
                  // margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: ListView.builder(
                    itemCount: blogList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      int totalviews = blogList[index]['totalCnt'];
                      var myNumber = k_m_b_generator(totalviews);

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 0, top: 10, bottom: 10),
                        child: Container(
                          // height: 180,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            // color: Colors.red
                            color: CustomTheme.boxColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: CustomTheme.buttonColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(
                                              blogList[index]['blogImage']
                                                  .toString(),
                                              height: 30,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          blogList[index]['blogTitle']
                                              .toString(),
                                          style: TextStyle(
                                              color: CustomTheme.buttonColor,
                                              fontSize: 12),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: CustomTheme.buttonColor,
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Text(
                                            myNumber + " Views",
                                            style: TextStyle(
                                                color: CustomTheme.white,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12,
                                            color: Color.fromARGB(
                                                255, 176, 174, 174),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12,
                                            color: Color.fromARGB(
                                                255, 205, 203, 203),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12,
                                            color: CustomTheme.white,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
