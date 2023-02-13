import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

import 'policy_center_getter_setter.dart';
import 'policy_center_web_view.dart';

class PolicyCenterListDetails extends StatefulWidget {
  policyCenterGetterSetter policyCenterGetterSetterValue;
  PolicyCenterListDetails({required this.policyCenterGetterSetterValue});

  @override
  State<StatefulWidget> createState() {
    return PolicyCenterListDetailsUI();
  }
}

class PolicyCenterListDetailsUI extends State<PolicyCenterListDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // https://www.booard.in/boardWs/boardComment.php?method=seenCount&policyId=&username=

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.width;

    List<String> imgList =
        widget.policyCenterGetterSetterValue.attachmentUrl.split(',');
    // TODO: implement build
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          backwardsCompatibility: false,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.black87),
          title: Text(
            'App Info Details',
            style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                color: Color(0xff000000)),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xffffffff),
                Color(0xffffffff),
              ],
            )),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              //         Padding(
              //             padding: const EdgeInsets.only(
              //                 left: 10, right: 10, top: 12, bottom: 12),
              //             child: Stack(children: <Widget>[
              //               Align(
              //                   alignment: Alignment.topLeft,
              //                   child: Text(
              //                     widget.policyCenterGetterSetterValue.title,
              //                     style: TextStyle(
              //                         fontFamily: "Montserrat",
              //                         fontSize: 14,
              //                         color: Color(0xffe5e5e5)),
              //                   ))
              //             ])),
              // Container(
              //   width: double.infinity,
              //   alignment: Alignment.center,
              //   margin: EdgeInsets.symmetric(vertical: 2.0),
              //   child: Container(
              //           width: double.infinity,
              //           alignment: Alignment.center,
              //
              //           // color: isInView ? Colors.blue : Colors.amber,
              //           child: Column(children: <Widget>[
              //             CarouselSlider(
              //               options: CarouselOptions(
              //                 height: height,
              //                 enlargeCenterPage: false,
              //                 viewportFraction: 1.0,
              //                 enableInfiniteScroll: false,
              //
              //                 // onPageChanged: (index, reason) {
              //                 //   setState(() {
              //                 //     _current = index;
              //                 //   });
              //                 // }
              //                 // autoPlay: false,
              //               ),
              //               items: imgList
              //                   .map((item) => Container(
              //                           child: ClipRRect(
              //                         borderRadius: BorderRadius.only(
              //                             topLeft: Radius.circular(15),
              //                             topRight: Radius.circular(15),
              //                             bottomRight: Radius.circular(0),
              //                             bottomLeft: Radius.circular(0)),
              //                         child: Center(
              //                             child: InkWell(
              //                                 child: Image.network(
              //                           item,
              //                           fit: BoxFit.cover,
              //                           height: height,
              //                           width: height,
              //                         ))),
              //                       )))
              //                   .toList(),
              //             ),
              //           ]),
              //         ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),

              widget.policyCenterGetterSetterValue.attachmentUrl != ''
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                      child: Image.network(
                        widget.policyCenterGetterSetterValue.attachmentUrl,
                        fit: BoxFit.cover,
                      ))
                  : SizedBox(
                      height: 1,
                    ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 22, bottom: 12),
                  child: Stack(children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.policyCenterGetterSetterValue.title,
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              color: Color(0xff000000)),
                        ))
                  ])),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 05, bottom: 12),
                  child: Stack(children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.policyCenterGetterSetterValue.description,
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 15,
                              color: Color(0xff000000)),
                        ))
                  ])),
              widget.policyCenterGetterSetterValue.url != ''
                  ? Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: InkWell(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                              height: 35,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Color(0xffff6502),
                                border: Border.all(
                                    color: Color(0xffff6502),
                                    // Set border color
                                    width: 0.6),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Center(
                                  child: Text(
                                "Click to view",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 15,
                                    color: Color(0xffffffff)),
                              )),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PolicyCenterWebViewExample(
                                            redirectionURL: widget
                                                .policyCenterGetterSetterValue
                                                .url),
                                  ));
                            }),
                      ))
                  : SizedBox(
                      height: 1,
                    )
            ]))));
  }
}
