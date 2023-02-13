// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:green_gold_globel/Home/enquiryDetails.dart';
// import 'package:green_gold_globel/main.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Core/custom_color.dart';

// class myEnquiry extends StatefulWidget {
//   const myEnquiry({super.key});

//   @override
//   State<myEnquiry> createState() => _myEnquiryState();
// }

// class _myEnquiryState extends State<myEnquiry> {
//   List<dynamic> enquiryList = [];
//   late ScrollController _controller;
//   bool _isFirstLoadRunning = false;
//   bool _isLoadMoreRunning = false;
//   int apiLimit = 0, userId = 0;

//   _incrementCounter() async {
//     print("onTap:");
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     // counterValue = (prefs.getInt('userId'))!;
//     setState(() {
//       userId = prefs.getInt('userId')!;
//       print("UserId" + userId.toString());
//     });
//     _firstLoad();
//     _controller = ScrollController()..addListener(_loadMore);
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _incrementCounter();
//   }

//   void _firstLoad() async {
//     enquiryList = [];
//     setState(() {
//       _isFirstLoadRunning = true;
//     });
//     try {
//       String url = MyApp.appURL +
//           "/WS/productData.php?method=getCustomerEnquiry&userId=" +
//           userId.toString() +
//           "&limit=" +
//           apiLimit.toString();

//       print("ut=rl;" + url);
//       var result = await http.get(Uri.parse(url));
//       setState(() {
//         var jsonResponse = json.decode(result.body);
//         if (jsonResponse['Result'] == "true") {
//           enquiryList = jsonResponse["data"];
//           setState(() {});
//           print(result.body);
//         } else {}
//         print("title: " + jsonResponse["msg"].toString());
//       });
//     } catch (err) {
//       if (kDebugMode) {
//         print('Something went wrong');
//       }
//     }
//     setState(() {
//       _isFirstLoadRunning = false;
//     });
//   }

//   void _loadMore() async {
//     if (_isFirstLoadRunning == false &&
//         _isLoadMoreRunning == false &&
//         _controller.position.extentAfter < 300) {
//       setState(() {
//         _isLoadMoreRunning = true; // Display a progress indicator at the bottom
//       });
//       apiLimit = apiLimit + 10;
//       try {
//         String url = MyApp.appURL +
//             "/WS/productData.php?method=getCustomerEnquiry&userId=" +
//             userId.toString() +
//             "&limit=" +
//             apiLimit.toString();
//         print(url);
//         var result = await http.get(Uri.parse(url));
//         setState(() {
//           var jsonResponse = json.decode(result.body);
//           if (jsonResponse['Result'] == "true") {
//             enquiryList.addAll(jsonResponse["data"]);
//             setState(() {});
//             print(result.body);
//           } else {}
//           print("title: " + jsonResponse["msg"].toString());
//         });
//       } catch (err) {
//         if (kDebugMode) {
//           print('Something went wrong!');
//         }
//       }

//       setState(() {
//         _isLoadMoreRunning = false;
//       });
//     }
//   }

// //https://www.bbedut.com/bbedut_coalMines/WS/productData.php?method=getCustomerEnquiry&userId=9&limit=0

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         drawer: Container(
//           width: MediaQuery.of(context).size.width * 0.7,
//           color: Colors.white,
//           child: ListView(
//             children: [
//               UserAccountsDrawerHeader(
//                 accountName: Text('Oflutter.com'),
//                 accountEmail: Text('example@gmail.com'),
//                 currentAccountPicture: CircleAvatar(
//                   child: ClipOval(
//                     child: Image.network(
//                       'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
//                       fit: BoxFit.cover,
//                       width: 90,
//                       height: 90,
//                     ),
//                   ),
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   image: DecorationImage(
//                       fit: BoxFit.fill,
//                       image: NetworkImage(
//                           'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
//                 ),
//               ),
//               Container(
//                 color: CustomTheme.white,
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: Icon(Icons.favorite),
//                       title: Text('Favorites'),
//                       onTap: () => null,
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.person),
//                       title: Text('Friends'),
//                       onTap: () => null,
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.share),
//                       title: Text('Share'),
//                       onTap: () => null,
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.notifications),
//                       title: Text('Request'),
//                     ),
//                     Divider(),
//                     ListTile(
//                       leading: Icon(Icons.settings),
//                       title: Text('Settings'),
//                       onTap: () => null,
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.description),
//                       title: Text('Policies'),
//                       onTap: () => null,
//                     ),
//                     Divider(),
//                     ListTile(
//                       title: Text('Exit'),
//                       leading: Icon(Icons.exit_to_app),
//                       onTap: () => null,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         backgroundColor: CustomTheme.bgColor,
//         appBar: AppBar(
//             backgroundColor: Color.fromARGB(255, 55, 52, 52),
//             elevation: 0,
//             title: Text("My Enquiry"),
//             centerTitle: true,
//             actions: [
//               Row(
//                 children: [
//                   Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: Icon(
//                           Icons.message,
//                           size: 20,
//                         ),
//                       ),
//                       Positioned(
//                         left: 17,
//                         bottom: 17,
//                         child: Container(
//                           height: 10,
//                           width: 10,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: Colors.red),
//                           child: Center(
//                             child: Text(
//                               "10",
//                               style: TextStyle(
//                                   fontSize: 8, color: CustomTheme.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: Icon(
//                           Icons.notifications,
//                           size: 20,
//                           color: CustomTheme.white,
//                         ),
//                       ),
//                       Positioned(
//                         left: 17,
//                         bottom: 17,
//                         child: Container(
//                           height: 10,
//                           width: 10,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: Colors.red),
//                           child: Center(
//                             child: Text(
//                               "10",
//                               style: TextStyle(
//                                   fontSize: 8, color: CustomTheme.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: 10,
//                   )
//                 ],
//               ),
//             ]),
//         body: _isFirstLoadRunning == true
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 20,
//                     ),
//                     enquiryList.length == 0
//                         ? Column(children: <Widget>[
//                             Image(
//                               image: AssetImage("assets/images/no_data.png"),
//                               height: MediaQuery.of(context).size.width - 5,
//                               width: MediaQuery.of(context).size.width - 5,
//                               // color: CustomTheme.ButtonBg,
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Text(
//                               "Currently, there is nothing to show",
//                               style: TextStyle(
//                                   fontFamily: "Montserrat",
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.bold,
//                                   color: CustomTheme.white),
//                             ),
//                             SizedBox(
//                               width: 3,
//                             ),
//                           ])
//                         : ListView.builder(
//                             controller: _controller,
//                             itemCount: enquiryList.length,
//                             shrinkWrap: true,
//                             physics: ScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               var enqstatus =
//                                   enquiryList[index]['enquiryStatus'];
//                               return InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => enquiryDetails(
//                                             enqId: enquiryList[index]['enquiryId']
//                                                 .toString(),
//                                             enqDate: enquiryList[index]['enquiryDate']
//                                                 .toString(),
//                                             vesselName: enquiryList[index]
//                                                     ['vesselName']
//                                                 .toString(),
//                                             estarrivalDate: enquiryList[index]
//                                                     ['estArrivalDate']
//                                                 .toString(),
//                                             coalQty: enquiryList[index]['coalQty']
//                                                 .toString(),
//                                             coalType: enquiryList[index]
//                                                     ['coalTypeName']
//                                                 .toString(),
//                                             coalTypeImg: enquiryList[index]
//                                                     ['coalTypeImage']
//                                                 .toString(),
//                                             country: enquiryList[index]['fromCountry'].toString(),
//                                             port: enquiryList[index]['portName'].toString(),
//                                             reqPrice: enquiryList[index]['requestedRate'].toString(),
//                                             reqQuany: enquiryList[index]['requestedQty'].toString(),
//                                             remark: enquiryList[index]['remark'].toString(),
//                                             totalUnread: enquiryList[index]['totalUnreadMsg'].toString(),
//                                             enqStatus: enquiryList[index]['enquiryStatus'].toString(),
//                                             arrivalDate: enquiryList[index]['arrivalDate'].toString(),
//                                             chatStatus: enquiryList[index]['chatStatus'].toString(),
//                                             chatID: enquiryList[index]['chatId'].toString()),
//                                       ));
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                     left: 15.0,
//                                     right: 15,
//                                     top: 10,
//                                   ),
//                                   child: Container(
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.9,
//                                     decoration: BoxDecoration(
//                                       color: CustomTheme.boxColor,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         children: [
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 8.0, right: 8),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       "Enquiry ID",
//                                                       style: TextStyle(
//                                                           color: CustomTheme
//                                                               .orengeTextColor,
//                                                           fontSize: 12),
//                                                     ),
//                                                     SizedBox(
//                                                       width: 10,
//                                                     ),
//                                                     Text(
//                                                       enquiryList[index]
//                                                               ['enquiryId']
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                           color: CustomTheme
//                                                               .buttonColor,
//                                                           fontSize: 12),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       "Enquiry Date",
//                                                       style: TextStyle(
//                                                           color: CustomTheme
//                                                               .orengeTextColor,
//                                                           fontSize: 12),
//                                                     ),
//                                                     SizedBox(
//                                                       width: 10,
//                                                     ),
//                                                     Text(
//                                                       enquiryList[index]
//                                                               ['enquiryDate']
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                           color:
//                                                               CustomTheme.white,
//                                                           fontSize: 12),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 5.0, bottom: 5),
//                                             child: Divider(
//                                               color: CustomTheme.white,
//                                               thickness: 1,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 8.0, right: 8),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 5.0),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         enquiryList[index]
//                                                                 ['vesselName']
//                                                             .toString(),
//                                                         style: TextStyle(
//                                                             color: CustomTheme
//                                                                 .white,
//                                                             fontSize: 12),
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                       ),
//                                                       SizedBox(
//                                                         height: 5,
//                                                       ),
//                                                       Text(
//                                                         "₹ " +
//                                                             enquiryList[index]
//                                                                     ['coalQty']
//                                                                 .toString(),
//                                                         style: TextStyle(
//                                                             color: CustomTheme
//                                                                 .buttonColor,
//                                                             fontSize: 12),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 5,
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 5.0, right: 10),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment.end,
//                                                     children: [
//                                                       Text(
//                                                         "Arrival Date",
//                                                         style: TextStyle(
//                                                             color: CustomTheme
//                                                                 .orengeTextColor,
//                                                             fontSize: 12),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 5,
//                                                       ),
//                                                       Text(
//                                                         enquiryList[index][
//                                                                         'estArrivalDate']
//                                                                     .toString() !=
//                                                                 "N/A"
//                                                             ? enquiryList[index]
//                                                                     [
//                                                                     'estArrivalDate']
//                                                                 .toString()
//                                                             : enquiryList[index]
//                                                                     [
//                                                                     'arrivalDate']
//                                                                 .toString(),
//                                                         style: TextStyle(
//                                                             color: CustomTheme
//                                                                 .white,
//                                                             fontSize: 12),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 12,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Row(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                   Container(
//                                                     height: 20,
//                                                     width: 20,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                       color: CustomTheme
//                                                           .buttonColor,
//                                                     ),
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               3.0),
//                                                       child: ClipRRect(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(50),
//                                                           child: Image.network(
//                                                             enquiryList[index][
//                                                                     'coalTypeImage']
//                                                                 .toString(),
//                                                             height: 20,
//                                                             fit: BoxFit.cover,
//                                                           )),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 10,
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 5.0),
//                                                     child: Text(
//                                                       enquiryList[index]
//                                                               ['coalTypeName']
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                           color:
//                                                               CustomTheme.white,
//                                                           fontSize: 12),
//                                                       maxLines: 1,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 5,
//                                                   )
//                                                 ],
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 5.0, right: 10),
//                                                 child: Row(
//                                                   children: [
//                                                     Icon(
//                                                       Icons.flag,
//                                                       color: CustomTheme
//                                                           .buttonColor,
//                                                       size: 12,
//                                                     ),
//                                                     SizedBox(
//                                                       width: 5,
//                                                     ),
//                                                     Text(
//                                                       enquiryList[index]
//                                                               ['fromCountry']
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                           color:
//                                                               CustomTheme.white,
//                                                           fontSize: 12),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 8,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Row(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                   Image.asset(
//                                                     "assets/images/directions.png",
//                                                     height: 18,
//                                                     fit: BoxFit.cover,
//                                                     color:
//                                                         CustomTheme.buttonColor,
//                                                   ),
//                                                   SizedBox(
//                                                     width: 10,
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 5.0),
//                                                     child: Text(
//                                                       enquiryList[index]
//                                                               ['portName']
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                           color:
//                                                               CustomTheme.white,
//                                                           fontSize: 12),
//                                                       maxLines: 1,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 5,
//                                                   )
//                                                 ],
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 5.0, right: 10),
//                                                 child: Row(
//                                                   children: [
//                                                     Icon(
//                                                       Icons
//                                                           .arrow_forward_ios_rounded,
//                                                       size: 12,
//                                                       color: Color.fromARGB(
//                                                           255, 176, 174, 174),
//                                                     ),
//                                                     SizedBox(
//                                                       width: 3,
//                                                     ),
//                                                     Icon(
//                                                       Icons
//                                                           .arrow_forward_ios_rounded,
//                                                       size: 12,
//                                                       color: Color.fromARGB(
//                                                           255, 205, 203, 203),
//                                                     ),
//                                                     SizedBox(
//                                                       width: 3,
//                                                     ),
//                                                     Icon(
//                                                       Icons
//                                                           .arrow_forward_ios_rounded,
//                                                       size: 12,
//                                                       color: CustomTheme.white,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 0,
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 5.0, bottom: 0),
//                                             child: Divider(
//                                               color: CustomTheme.white,
//                                               thickness: 1,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 8.0, right: 8),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 5.0),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "₹ " +
//                                                             enquiryList[index][
//                                                                     'requestedRate']
//                                                                 .toString(),
//                                                         style: TextStyle(
//                                                             color: CustomTheme
//                                                                 .buttonColor,
//                                                             fontSize: 12),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 5,
//                                                       ),
//                                                       Text(
//                                                         "Req. Price",
//                                                         style: TextStyle(
//                                                             color: CustomTheme
//                                                                 .orengeTextColor,
//                                                             fontSize: 12),
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 5,
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 5.0, right: 10),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment.end,
//                                                     children: [
//                                                       Text(
//                                                         enquiryList[index]
//                                                                 ['requestedQty']
//                                                             .toString(),
//                                                         style: TextStyle(
//                                                             color: CustomTheme
//                                                                 .white,
//                                                             fontSize: 12),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 5,
//                                                       ),
//                                                       Text(
//                                                         "Req. Qty",
//                                                         style: TextStyle(
//                                                             color: CustomTheme
//                                                                 .orengeTextColor,
//                                                             fontSize: 12),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 5.0, bottom: 0),
//                                             child: Divider(
//                                               color: CustomTheme.white,
//                                               thickness: 1,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 8.0, right: 8),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 5.0),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "Enquiry Status",
//                                                         style: TextStyle(
//                                                             color: CustomTheme
//                                                                 .orengeTextColor,
//                                                             fontSize: 12),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 5,
//                                                       ),
//                                                       Text(
//                                                         "Messages",
//                                                         style: TextStyle(
//                                                             color: CustomTheme
//                                                                 .orengeTextColor,
//                                                             fontSize: 12),
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 5,
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 5.0, right: 10),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment.end,
//                                                     children: [
//                                                       Text(
//                                                         enqstatus,
//                                                         style: TextStyle(
//                                                             color: enqstatus ==
//                                                                     "Working"
//                                                                 ? CustomTheme
//                                                                     .working
//                                                                 : enqstatus ==
//                                                                         "Rejected"
//                                                                     ? CustomTheme
//                                                                         .rejected
//                                                                     : enqstatus ==
//                                                                             "Converted"
//                                                                         ? CustomTheme
//                                                                             .converted
//                                                                         : enqstatus ==
//                                                                                 "Not Converted"
//                                                                             ? CustomTheme.notconverted
//                                                                             : enqstatus == "Not Contacted"
//                                                                                 ? CustomTheme.notcontacted
//                                                                                 : CustomTheme.white,
//                                                             fontSize: 12),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 5,
//                                                       ),
//                                                       Text(
//                                                         enquiryList[index][
//                                                                     'totalUnreadMsg']
//                                                                 .toString() +
//                                                             " unread",
//                                                         style: TextStyle(
//                                                             color: CustomTheme
//                                                                 .white,
//                                                             fontSize: 12),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     if (_isLoadMoreRunning == true)
//                       const Padding(
//                         padding: EdgeInsets.only(top: 2, bottom: 2),
//                         child: Center(
//                           child: SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator()),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
