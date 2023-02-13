// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:green_gold_globel/Home/chatScreenPage.dart';
// import 'package:green_gold_globel/Home/enquiryChat.dart';

// import '../Core/custom_color.dart';

// class enquiryDetails extends StatefulWidget {
//   String enqId,
//       enqDate,
//       vesselName,
//       arrivalDate,
//       estarrivalDate,
//       coalQty,
//       coalType,
//       coalTypeImg,
//       country,
//       port,
//       reqPrice,
//       reqQuany,
//       remark,
//       totalUnread,
//       enqStatus,
//       chatStatus,
//       chatID;
//   enquiryDetails(
//       {super.key,
//       required this.enqId,
//       required this.enqDate,
//       required this.arrivalDate,
//       required this.estarrivalDate,
//       required this.vesselName,
//       required this.coalQty,
//       required this.coalType,
//       required this.coalTypeImg,
//       required this.country,
//       required this.port,
//       required this.remark,
//       required this.totalUnread,
//       required this.reqPrice,
//       required this.reqQuany,
//       required this.enqStatus,
//       required this.chatStatus,
//       required this.chatID});

//   @override
//   State<enquiryDetails> createState() => _enquiryDetailsState();
// }

// class _enquiryDetailsState extends State<enquiryDetails> {
//   TextEditingController remarkController = TextEditingController();
//   int status = 0;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     remarkController.text = widget.remark;
//     status = int.parse(widget.chatStatus);
//     print("date::" + status.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: CustomTheme.bgColor,
//         appBar: AppBar(
//           backgroundColor: Color.fromARGB(255, 55, 52, 52),
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(50),
//                 child: Container(
//                   height: 30,
//                   width: 30,
//                   color: CustomTheme.white,
//                   child: Center(
//                       child: Icon(
//                     Icons.arrow_back_ios_rounded,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                 ),
//               ),
//             ),
//           ),
//           elevation: 0,
//           title: Text("Enquiry Details"),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                   left: 15.0,
//                   right: 15,
//                   top: 10,
//                 ),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   decoration: BoxDecoration(
//                     color: CustomTheme.boxColor,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Enquiry Status",
//                           style: TextStyle(
//                               color: CustomTheme.orengeTextColor, fontSize: 14),
//                         ),
//                         Text(
//                           widget.enqStatus,
//                           style: TextStyle(
//                               color: widget.enqStatus == "Working"
//                                   ? CustomTheme.working
//                                   : widget.enqStatus == "Rejected"
//                                       ? CustomTheme.rejected
//                                       : widget.enqStatus == "Converted"
//                                           ? CustomTheme.converted
//                                           : widget.enqStatus == "Not Converted"
//                                               ? CustomTheme.notconverted
//                                               : widget.enqStatus ==
//                                                       "Not Contacted"
//                                                   ? CustomTheme.notcontacted
//                                                   : CustomTheme.white,
//                               fontSize: 14),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                   left: 15.0,
//                   right: 15,
//                   top: 10,
//                 ),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   decoration: BoxDecoration(
//                     color: CustomTheme.boxColor,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 8.0, right: 8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     "Enquiry ID",
//                                     style: TextStyle(
//                                         color: CustomTheme.orengeTextColor,
//                                         fontSize: 12),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     widget.enqId,
//                                     style: TextStyle(
//                                         color: CustomTheme.buttonColor,
//                                         fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     "Enquiry Date",
//                                     style: TextStyle(
//                                         color: CustomTheme.orengeTextColor,
//                                         fontSize: 12),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     widget.enqDate,
//                                     style: TextStyle(
//                                         color: CustomTheme.white, fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5.0, bottom: 5),
//                           child: Divider(
//                             color: CustomTheme.white,
//                             thickness: 1,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 8.0, right: 8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 5.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       widget.vesselName,
//                                       style: TextStyle(
//                                           color: CustomTheme.white,
//                                           fontSize: 12),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       "₹ " + widget.coalQty,
//                                       style: TextStyle(
//                                           color: CustomTheme.buttonColor,
//                                           fontSize: 12),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(top: 5.0, right: 10),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "Arrival Date",
//                                       style: TextStyle(
//                                           color: CustomTheme.orengeTextColor,
//                                           fontSize: 12),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       widget.estarrivalDate != "N/A"
//                                           ? widget.estarrivalDate.toString()
//                                           : widget.arrivalDate.toString(),
//                                       style: TextStyle(
//                                           color: CustomTheme.white,
//                                           fontSize: 12),
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Container(
//                                   height: 20,
//                                   width: 20,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: CustomTheme.buttonColor,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(3.0),
//                                     child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(50),
//                                         child: Image.network(
//                                           widget.coalTypeImg.toString(),
//                                           height: 20,
//                                           fit: BoxFit.cover,
//                                         )),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 5.0),
//                                   child: Text(
//                                     widget.coalType,
//                                     style: TextStyle(
//                                         color: CustomTheme.white, fontSize: 12),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 5,
//                                 )
//                               ],
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(top: 5.0, right: 10),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.flag,
//                                     color: CustomTheme.buttonColor,
//                                     size: 12,
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     widget.country,
//                                     style: TextStyle(
//                                         color: CustomTheme.white, fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 8,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Image.asset(
//                                   "assets/images/directions.png",
//                                   height: 18,
//                                   fit: BoxFit.cover,
//                                   color: CustomTheme.buttonColor,
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 5.0),
//                                   child: Text(
//                                     widget.port,
//                                     style: TextStyle(
//                                         color: CustomTheme.white, fontSize: 12),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 5,
//                                 )
//                               ],
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(top: 5.0, right: 10),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     Icons.fire_truck_sharp,
//                                     color: CustomTheme.buttonColor,
//                                     size: 12,
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     widget.coalQty,
//                                     style: TextStyle(
//                                         color: CustomTheme.white, fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 25.0),
//                   child: Text(
//                     "Enquiry Detail",
//                     style: TextStyle(color: CustomTheme.white, fontSize: 14),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                   left: 15.0,
//                   right: 15,
//                   top: 10,
//                 ),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   decoration: BoxDecoration(
//                     color: CustomTheme.boxColor,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Requested Price",
//                               style: TextStyle(
//                                   color: CustomTheme.orengeTextColor,
//                                   fontSize: 14),
//                             ),
//                             Text(
//                               "₹ " + widget.reqPrice,
//                               style: TextStyle(
//                                   color: CustomTheme.buttonColor, fontSize: 14),
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Requested Quantity",
//                               style: TextStyle(
//                                   color: CustomTheme.orengeTextColor,
//                                   fontSize: 14),
//                             ),
//                             Text(
//                               widget.reqQuany,
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 14),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: CustomTheme.boxColor,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 15.0),
//                       child: Text(
//                         "Remark",
//                         style: TextStyle(
//                             color: CustomTheme.orengeTextColor, fontSize: 14),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 15.0, bottom: 5),
//                       child: TextFormField(
//                         controller: remarkController,
//                         // enabled: false,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText:
//                               "Please connect on call to discuss detail. Please connect on call to discuss detail",
//                           hintStyle: TextStyle(
//                               color: CustomTheme.shadowcolor, fontSize: 16),
//                         ),
//                         style:
//                             TextStyle(color: CustomTheme.white, fontSize: 16),
//                         maxLines: 6,
//                         minLines: 2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               status == 2
//                   ? GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                   enqID: widget.enqId.toString(),
//                                   chatID: widget.chatID.toString()),
//                             ));
//                       },
//                       child: Container(
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         decoration: BoxDecoration(
//                           color: CustomTheme.boxColor,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     "View chat".toUpperCase(),
//                                     style: TextStyle(
//                                         color: CustomTheme.white, fontSize: 16),
//                                   ),
//                                   SizedBox(
//                                     width: 15,
//                                   ),
//                                   Container(
//                                     height: 22,
//                                     width: 70,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: CustomTheme.white,
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         widget.totalUnread + " unread",
//                                         style: TextStyle(
//                                             color: Colors.red, fontSize: 13),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               Icon(
//                                 Icons.keyboard_arrow_right,
//                                 size: 20,
//                                 color: CustomTheme.white,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   : Container(
//                       width: MediaQuery.of(context).size.width * 0.9,
//                       decoration: BoxDecoration(
//                         color: CustomTheme.boxColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   "no chat to show".toUpperCase(),
//                                   style: TextStyle(
//                                       color: CustomTheme.white, fontSize: 16),
//                                 ),
//                               ],
//                             ),
//                             Icon(
//                               Icons.keyboard_arrow_right,
//                               size: 20,
//                               color: CustomTheme.white,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
