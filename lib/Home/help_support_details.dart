import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Widgets/color.dart';
import '../main.dart';
import 'image_details_view.dart';

class HelpSupportDetails extends StatefulWidget {
  HelpSupportDetails({
    required this.issueId,
  });
  final String title = "AutoComplete Demo";
  int issueId;

  // var jsonResponse;

  @override
  _AutoCompleteDemoState createState() => _AutoCompleteDemoState();
}

class _AutoCompleteDemoState extends State<HelpSupportDetails> {
  TextEditingController issueTextController = new TextEditingController();

  ScrollController _scrollController = new ScrollController();
  int astrologerId = 0;

  String convertDateFormat(String dateTimeString) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
    DateFormat newDateFormat = DateFormat("dd MMM yyyy hh:mm a");
    DateTime dateTime = dateFormat.parse(dateTimeString);
    String selectedDate = newDateFormat.format(dateTime);
    return selectedDate;
  }

  @override
  void initState() {
    // getUsers();
    super.initState();
    astrologerWithdrawalDetails();
  }

  // https://www.bbedut.com/bbedut_astro/astrologerDetail.php?method=astrologerEarningIssueDetail&issueId=1
  var jsonResponse;

  Future<String> astrologerWithdrawalDetails() async {
    String url = MyApp.appURL +
        "/WS/customerIssues.php?method=customerIssueDetail&issueId=" +
        widget.issueId.toString();
    print("url:" + url);
    try {
      var result = await http.get(Uri.parse(url));
      // return json.decode(result.body)['data'];
      // print(jsonResponse['data'][0]['Class']);
      setState(() {
        jsonResponse = json.decode(result.body);

        // print("title: " + astrologerCallGetterSetterList[0].name);
      });
    } on Exception catch (exception) {
      if (exception.toString().contains("HandshakeException")) {
        astrologerWithdrawalDetails();
      }
      print("hel" + exception.toString());
      // only executed if error is of type Exception
    } catch (error) {
      print("hel1" + error.toString());
      // executed for errors of all types other than Exception
    }
    return "Success";
  }

  Future<void> _showMyDialog(
      BuildContext context, String result, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            result,
            style: TextStyle(fontFamily: "Montserrat"),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: TextStyle(fontFamily: "Montserrat"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, false);
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  // https://www.bbedut.com/bbedut_astro/astrologerDetail.php?method=saveAstrologerWithdrawalIssue&astrologerId=1&withdrawalId=1&issueDetail=First%20Test%20Issue%20For%20Withdrawal%20Testing

  // Widget row(addressGetterSetter? user) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[
  //       Text(
  //         user!.asciiname,
  //         style: TextStyle(fontSize: 16.0),
  //       ),
  //       SizedBox(
  //         width: 10.0,
  //       ),
  //       Text(
  //         user.countryName!.toString(),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backwardsCompatibility: false,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Help and Support',
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
        body: jsonResponse != null
            ? SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 13, right: 13, top: 5, bottom: 5),
                        child: Container(
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
                            child: Container(
                                child: Stack(children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 5,
                                            bottom: 5),
                                        child: Stack(children: <Widget>[
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text("Ticket No",
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Color(0xff525252)))),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                  jsonResponse['ticketNo']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 16,
                                                      color:
                                                          Color(0xff000000))))
                                        ])),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 5,
                                            bottom: 5),
                                        child: Stack(children: <Widget>[
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text("Issue Raised On",
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Color(0xff525252)))),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                  convertDateFormat(
                                                      jsonResponse['issueDate']
                                                          .toString()),
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 16,
                                                      color:
                                                          Color(0xff000000))))
                                        ])),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 5,
                                            bottom: 5),
                                        child: Stack(children: <Widget>[
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text("Status",
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Color(0xff525252)))),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                  jsonResponse['status'],
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 16,
                                                      color:
                                                          Color(0xff000000))))
                                        ])),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Stack(children: <Widget>[
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              "Issue Title",
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff525252)),
                                            ),
                                          )),
                                    ]),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                      decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        border: Border.all(
                                            color: Color(0xffffffff),
                                            // Set border color
                                            width: 0.6),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 12,
                                            color: Color(0xffe5e5e5),
                                          )
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 10,
                                                bottom: 10),
                                            child: Text(
                                              jsonResponse['issueTitle'],
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontSize: 14,
                                                  color: Color(0xff000000)),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Stack(children: <Widget>[
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              "Issue Details",
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff525252)),
                                            ),
                                          )),
                                    ]),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                      decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        border: Border.all(
                                            color: Color(0xffffffff),
                                            // Set border color
                                            width: 0.6),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 12,
                                            color: Color(0xffe5e5e5),
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 10,
                                                bottom: 10),
                                            child: Text(
                                              jsonResponse['issueDetail'],
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontSize: 14,
                                                  color: Color(0xff000000)),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                    jsonResponse['resolvedOn'] != ''
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 10, 10, 0),
                                            child: Stack(children: <Widget>[
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Resolved On",
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff525252)),
                                                ),
                                              ),
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                      convertDateFormat(
                                                          jsonResponse[
                                                                  'resolvedOn']
                                                              .toString()),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontSize: 16,
                                                          color: Color(
                                                              0xff000000))))
                                            ]))
                                        : SizedBox(
                                            height: 10,
                                          ),
                                    jsonResponse['resolvedOn'] != ''
                                        ? Stack(children: <Widget>[
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 0, 0),
                                                  child: Text(
                                                    "Resolution details",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff525252)),
                                                  ),
                                                )),
                                          ])
                                        : SizedBox(
                                            height: 10,
                                          ),
                                    jsonResponse['resolvedOn'] != ''
                                        ? Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 5, 10, 20),
                                            decoration: BoxDecoration(
                                              color: Color(0xffffffff),
                                              border: Border.all(
                                                  color: Color(0xffffffff),
                                                  // Set border color
                                                  width: 0.6),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 10,
                                                          bottom: 10),
                                                  child: Text(
                                                    jsonResponse[
                                                        'resolutionDetail'],
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff000000)),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            height: 1,
                                          ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    jsonResponse['issueAttachment'] != ''
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImageDetailsView(
                                                              imageURL:
                                                                  jsonResponse[
                                                                      'issueAttachment']))).then(
                                                  (_) => setState(() {
                                                        // getUserRatings();
                                                      }));
                                            },
                                            child: Stack(children: <Widget>[
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 0, 20),
                                                    child: Text(
                                                      "See Issue Attachment",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontSize: 16,
                                                          color: Color(
                                                              0xff525252)),
                                                    ),
                                                  )),
                                            ]))
                                        : SizedBox(
                                            height: 5,
                                          ),
                                  ],
                                ),
                              ),
                            ]))))
                  ]))
            : SizedBox(
                height: 1,
              ));
  }
}
