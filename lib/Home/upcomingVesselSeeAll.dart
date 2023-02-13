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

class upcomingVesselSeeAll extends StatefulWidget {
  const upcomingVesselSeeAll({super.key});

  @override
  State<upcomingVesselSeeAll> createState() => _upcomingVesselSeeAllState();
}

class _upcomingVesselSeeAllState extends State<upcomingVesselSeeAll> {
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
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 30,
                  width: 30,
                  color: CustomTheme.white,
                  child: Center(
                      child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: Colors.black,
                  )),
                ),
              ),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 55, 52, 52),
          elevation: 0.0,
          title: const Text(
            "Upcoming Vessel List",
            style: TextStyle(
                color: CustomTheme.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          centerTitle: true,
        ),
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
                  Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: upcomingVesselList.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
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
                                    estRate: upcomingVesselList[index]
                                            ['coalQty']
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
                                    sulphur: upcomingVesselList[index]
                                            ['sulphur']
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              padding:
                                                  const EdgeInsets.all(3.0),
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
                                                      color: CustomTheme
                                                          .buttonColor,
                                                      fontSize: 12),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "₹ " +
                                                      upcomingVesselList[index]
                                                          ['coalQty'],
                                                  style: TextStyle(
                                                      color: CustomTheme
                                                          .buttonColor,
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
                                                  color: CustomTheme
                                                      .orengeTextColor,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              padding:
                                                  const EdgeInsets.all(3.0),
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
                                                  color:
                                                      CustomTheme.buttonColor,
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
                                                  color: CustomTheme
                                                      .orengeTextColor,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  color:
                                                      CustomTheme.buttonColor,
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
