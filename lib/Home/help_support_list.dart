import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/color.dart';
import '../main.dart';
import 'dart:convert';

import 'add_help_support_ticket.dart';
import 'help_support_details.dart';
import 'help_support_getter_setter.dart';

class HelpSupportList extends StatefulWidget {
  HelpSupportList({
    required this.userId,
  });
  int userId;
  final String title = "AutoComplete Demo";

  @override
  _AutoCompleteDemoState createState() => _AutoCompleteDemoState();
}

class _AutoCompleteDemoState extends State<HelpSupportList> {
  static List<helpSupportGetterSetter> helpSupportGetterSetterList = [];

  ScrollController _scrollController = new ScrollController();
  var jsonResponse, withdrawalJsonResponse;
  int isEarningOrWithdrawal = 0;
  String startDate = "", endDate = "";
  bool isFilterApply = false;
  String language = '';

  String convertDateFormat(String dateTimeString) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
    DateFormat newDateFormat = DateFormat("dd MMM yyyy hh:mm a");
    DateTime dateTime = dateFormat.parse(dateTimeString);
    String selectedDate = newDateFormat.format(dateTime);
    return selectedDate;
  }

  static String convertDateFormatValue(String dateTimeString) {
    DateFormat newDateFormat = DateFormat("dd MMM yyyy");
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(dateTimeString);
    String selectedDate = newDateFormat.format(dateTime);
    return selectedDate;
  }

  // https://www.bbedut.com/bbedut_astro/astrologerDetail.php?method=astrologerWithdrawalIssueList&astrologerId=1
  Future<String> astrologerWithdrawalIssueList() async {
    String url = MyApp.appURL +
        "/WS/customerIssues.php?method=customerIssueList&customerId=" +
        widget.userId.toString() +
        "&startDate=" +
        startDate +
        "&endDate=" +
        endDate;
    print("url:" + url);
    try {
      var result = await http.get(Uri.parse(url));
      setState(() {
        jsonResponse = json.decode(result.body);
        var tagObjsJson = jsonResponse['data'] as List;
        helpSupportGetterSetterList = tagObjsJson
            .map((tagJson) => helpSupportGetterSetter.fromJson(tagJson))
            .toList();
      });
    } on Exception catch (exception) {
      if (exception.toString().contains("HandshakeException")) {
        astrologerWithdrawalIssueList();
      }
      print("hel" + exception.toString());
    } catch (error) {
      print("hel1" + error.toString());
    }
    return "Success";
  }

  @override
  void initState() {
    // getUsers();
    super.initState();
    _incrementCounter();
    astrologerWithdrawalIssueList();
  }

  _incrementCounter() async {
    print("onTap:");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString('lang')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          backwardsCompatibility: false,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Help and Support'.toUpperCase(),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddHelpSupportTicket(
                          customerId: widget.userId,
                        ))).then((_) => setState(() {
                  astrologerWithdrawalIssueList();
                }));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 29,
          ),
          backgroundColor: Colors.blue,
          tooltip: 'Capture Picture',
          elevation: 3,
          splashColor: Colors.grey,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 1,
              ),
              SizedBox(
                height: 1,
              ),
              helpSupportGetterSetterList.length != 0
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: helpSupportGetterSetterList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(
                                left: 0, right: 0, top: 10, bottom: 5),
                            child: Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(0),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HelpSupportDetails(
                                                      issueId:
                                                          helpSupportGetterSetterList[
                                                                  index]
                                                              .issueId))).then(
                                          (_) => setState(() {
                                                // getUserRatings();
                                              }));
                                    },
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Stack(children: <Widget>[
                                                Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        helpSupportGetterSetterList[
                                                                index]
                                                            .issueTittle
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Color(
                                                                0xffbf4900))))
                                              ])),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Stack(children: <Widget>[
                                                Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text("Date",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff525252)))),
                                                Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Text(
                                                        convertDateFormat(
                                                            helpSupportGetterSetterList[
                                                                    index]
                                                                .issueDate
                                                                .toString()),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 16,
                                                            color: Color(
                                                                0xff000000))))
                                              ])),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Stack(children: <Widget>[
                                                Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text("Ticket No",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff525252)))),
                                                Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Text(
                                                        helpSupportGetterSetterList[
                                                                index]
                                                            .ticketNo
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 16,
                                                            color: Color(
                                                                0xff000000))))
                                              ])),
                                          helpSupportGetterSetterList[index]
                                                      .isResolved ==
                                                  1
                                              ? Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              30, 10, 30, 10),
                                                      child: Container(
                                                          height: 35,
                                                          width: 170,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  offset:
                                                                      Offset(
                                                                          0, 1),
                                                                  blurRadius: 1,
                                                                  color: Colors
                                                                      .blue)
                                                            ],
                                                          ),
                                                          child: InkWell(
                                                              onTap: () {
                                                                print("onTap");
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                HelpSupportDetails(issueId: helpSupportGetterSetterList[index].issueId))).then(
                                                                    (_) =>
                                                                        setState(
                                                                            () {
                                                                          // getUserRatings();
                                                                        }));
                                                              },
                                                              child: Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            "Click to check status",
                                                                            style: TextStyle(
                                                                                fontFamily: "Montserrat",
                                                                                fontSize: 16,
                                                                                color: Color(0xffffffff)),
                                                                          ),
                                                                        ))
                                                                  ])))))
                                              : SizedBox(
                                                  height: 1,
                                                ),
                                        ]))));
                      })
                  : Column(children: <Widget>[
                      Image(
                        image: AssetImage("assets/images/no_data.png"),
                        height: MediaQuery.of(context).size.width - 5,
                        width: MediaQuery.of(context).size.width - 5,
                        // color: CustomTheme.ButtonBg,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Current Nothing To Show",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff444747)),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                    ])
            ],
          ),
        ));
  }
}
