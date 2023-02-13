import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:http/http.dart' as http;

import '../Core/custom_color.dart';
import '../main.dart';
import 'upcomingVesselDetails.dart';

class upcomingVesselPage extends StatefulWidget {
  const upcomingVesselPage({super.key});

  @override
  State<upcomingVesselPage> createState() => _upcomingVesselPageState();
}

class _upcomingVesselPageState extends State<upcomingVesselPage> {
  TextEditingController searchController = TextEditingController();
  late ScrollController _controller;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int apiLimit = 0;
  List<dynamic> upcomingVesselList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  void _firstLoad() async {
    upcomingVesselList = [];
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      String url = MyApp.appURL +
          "/WS/productData.php?method=productList&productTypeId=" +
          1.toString() +
          "&limit=" +
          apiLimit.toString();

      print("ut=rl;" + url);
      var result = await http.get(Uri.parse(url));
      setState(() {
        var jsonResponse = json.decode(result.body);
        if (jsonResponse['Result'] == "true") {
          upcomingVesselList = jsonResponse["data"];
          setState(() {});
          print(result.body);
        } else {}
        print("title: " + jsonResponse["msg"].toString());
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      apiLimit = apiLimit + 10;
      try {
        String url = MyApp.appURL +
            "/WS/productData.php?method=productList&productTypeId=" +
            1.toString() +
            "&limit=" +
            apiLimit.toString();
        print(url);
        var result = await http.get(Uri.parse(url));
        setState(() {
          var jsonResponse = json.decode(result.body);
          if (jsonResponse['Result'] == "true") {
            upcomingVesselList.addAll(jsonResponse["data"]);
            setState(() {});
            print(result.body);
          } else {}
          print("title: " + jsonResponse["msg"].toString());
        });
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.bgColor,
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
        appBar: AppBar(
            backgroundColor: CustomTheme.bgColor,
            elevation: 0,
            title: Text("Upcoming Vessel"),
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
        body: _isFirstLoadRunning == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    //height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CustomTheme.backbutton),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: searchController,
                        // enabled: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search",
                          hintStyle: TextStyle(
                              color: CustomTheme.shadowcolor, fontSize: 16),
                        ),
                        style: TextStyle(
                            color: CustomTheme.shadowcolor, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    controller: _controller,
                    itemCount: upcomingVesselList.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          print("lisststtsts:" +
                              upcomingVesselList[index].toString());
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
                              left: 15.0, right: 15, top: 10, bottom: 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CustomTheme.boxColor,
                            ),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: CustomTheme.buttonColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.asset(
                                                  "assets/images/logo.jpg",
                                                  height: 30,
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                upcomingVesselList[index]
                                                    ['vesselName'],
                                                style: TextStyle(
                                                    color:
                                                        CustomTheme.buttonColor,
                                                    fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "₹ " +
                                                    upcomingVesselList[index]
                                                        ['coalQty'],
                                                style: TextStyle(
                                                    color:
                                                        CustomTheme.buttonColor,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, right: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Est Arrival Date",
                                            style: TextStyle(
                                                color:
                                                    CustomTheme.orengeTextColor,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            upcomingVesselList[index]
                                                ['estArrivalDate'],
                                            style: TextStyle(
                                                color: CustomTheme.white,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: CustomTheme.buttonColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                  upcomingVesselList[index]
                                                      ['coalTypeImage'],
                                                  height: 20,
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            upcomingVesselList[index]
                                                ['coalTypeName'],
                                            style: TextStyle(
                                                color: CustomTheme.buttonColor,
                                                fontSize: 12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, right: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.flag,
                                            color: CustomTheme.buttonColor,
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            upcomingVesselList[index]
                                                ['fromCountry'],
                                            style: TextStyle(
                                                color:
                                                    CustomTheme.orengeTextColor,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Image.asset(
                                          "assets/images/directions.png",
                                          height: 18,
                                          fit: BoxFit.cover,
                                          color: CustomTheme.buttonColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            upcomingVesselList[index]
                                                ['portName'],
                                            style: TextStyle(
                                                color: CustomTheme.buttonColor,
                                                fontSize: 12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, right: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12,
                                            color: Color.fromARGB(
                                                255, 176, 174, 174),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12,
                                            color: Color.fromARGB(
                                                255, 205, 203, 203),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12,
                                            color: CustomTheme.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      child: Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
