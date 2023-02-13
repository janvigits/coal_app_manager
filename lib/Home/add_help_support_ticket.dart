import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'dart:convert';

import 'get_help_support_media.dart';

class AddHelpSupportTicket extends StatefulWidget {
  int customerId;
  AddHelpSupportTicket({required this.customerId});
  final String title = "AutoComplete Demo";
  static String individualPhotoPath = "";

  // var jsonResponse;

  @override
  _AutoCompleteDemoState createState() => _AutoCompleteDemoState();
}

class _AutoCompleteDemoState extends State<AddHelpSupportTicket> {
  TextEditingController issueTextController = new TextEditingController();
  TextEditingController issueTitleController = new TextEditingController();

  ScrollController _scrollController = new ScrollController();
  int astrologerId = 0;
  Dio dio = new Dio();
  var jsonResponse;
  Response? response;
  @override
  void initState() {
    // getUsers();
    super.initState();
    AddHelpSupportTicket.individualPhotoPath = "";
    // print("response:"+widget.jsonResponse.toString());
    // updateCounterValue();
  }

  String convertDateFormat(String dateTimeString) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
    DateFormat newDateFormat = DateFormat("dd MMM yyyy hh:mm a");
    DateTime dateTime = dateFormat.parse(dateTimeString);
    String selectedDate = newDateFormat.format(dateTime);
    return selectedDate;
  }

  Future<void> _showMessageMyDialog(
      BuildContext context, String result, String message) async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 250.0,
        width: 340.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                result,
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 18,
                    color: Color(0xff000000)),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: Text(
                "We got your request the concerned team will get back to you in 24-48 hours.",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 15,
                    color: Color(0xff000000)),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            InkWell(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 0, 20),
                height: 30,
                width: 60,
                decoration: BoxDecoration(
                  color: Color(0xff00529D),
                  border: Border.all(
                      color: Color(0xff00529D),
                      // Set border color
                      width: 0.6),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            "Ok",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 15,
                                color: Color(0xffffffff)),
                          ),
                        )),
                  ],
                ),
              ),
              onTap: () {
                print("onTap");
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pop(context);
                // Navigator.pop(context);
                // Navigator.pop(context);
                // Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }
  // https://www.bbedut.com/bbedut_astro/astrologerDetail.php?method=saveAstrologerWithdrawalIssue&astrologerId=1&withdrawalId=1&issueDetail=First%20Test%20Issue%20For%20Withdrawal%20Testing

  Future<String> saveIndividualDetails(
    BuildContext context,
  ) async {
    // https://www.bbedut.com/bbedut_astro/monetizeDetails.php?method=saveIndividualDetails
    String uploadurl =
        MyApp.appURL + "/WS/customerIssues.php?method=saveCustomerIssue";
    print("userid:" + widget.customerId.toString());
    FormData formdata = FormData.fromMap({
      "customerId": widget.customerId,
      "issueTitle": issueTitleController.text.trim(),
      "issueDetail": issueTextController.text.trim(),
    });
    if (AddHelpSupportTicket.individualPhotoPath != null &&
        AddHelpSupportTicket.individualPhotoPath != '') {
      formdata = FormData.fromMap({
        "customerId": widget.customerId,
        "issueTitle": issueTitleController.text.trim(),
        "issueDetail": issueTextController.text.trim(),
        "attachment": await MultipartFile.fromFile(
            AddHelpSupportTicket.individualPhotoPath,
            filename: basename(AddHelpSupportTicket.individualPhotoPath)),
        "attachmentType": "image",
      });
    }
    // {"result":"true","msg":"media has been uploaded/updated successfully","boardID":14131,"mediaID":14113,"confirmationID":1231231234}
    response = await dio
        .post(
          uploadurl,
          data: formdata,
        )
        .catchError((Object err) {});

    if (response!.statusCode == 200) {
      print(response.toString());
      jsonResponse = json.decode(response.toString());
      _showMessageMyDialog(context, "Success", jsonResponse['msg']);
      // Navigator.pop(context);
      // Navigator.pop(context);
      // _showToast("Individual Details saved successfully");

    } else {
      print("Error during connection to server.");
    }
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backwardsCompatibility: false,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Add Issue'.toUpperCase(),
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                    Widget>[
          SizedBox(
            height: 15,
          ),
          Padding(
              padding:
                  const EdgeInsets.only(left: 13, right: 13, top: 5, bottom: 5),
              child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffffffFF),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(2, 2),
                        blurRadius: 12,
                        color: Color(0xffe5e5e5),
                      )
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
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Stack(children: <Widget>[
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("Title",
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 16,
                                            color: Color(0xff525252)))),
                              ])),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                            height: 44,
                            decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              border: Border.all(
                                  color: Color(0xffffffff),
                                  // Set border color
                                  width: 0.6),
                              borderRadius: BorderRadius.circular(5.0),
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
                                  child: TextField(
                                    controller: issueTitleController,
                                    expands: true,
                                    maxLines: null,
                                    onChanged: (text) {
                                      print('First text field: $text');
                                    },
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xff111111)),
                                    decoration: InputDecoration(
                                        hintText: "Type here...",
                                        hintStyle: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xff555555)),
                                        contentPadding: EdgeInsets.all(10.0),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          Stack(children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                  child: Text(
                                    "Description",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        color: Color(0xff525252)),
                                  ),
                                )),
                          ]),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 20),
                            height: 124,
                            decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              border: Border.all(
                                  color: Color(0xffffffff),
                                  // Set border color
                                  width: 0.6),
                              borderRadius: BorderRadius.circular(5.0),
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
                                  child: TextField(
                                    controller: issueTextController,
                                    expands: true,
                                    maxLines: null,
                                    onChanged: (text) {
                                      print('First text field: $text');
                                    },
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xff111111)),
                                    decoration: InputDecoration(
                                        hintText: "Type here...",
                                        hintStyle: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xff555555)),
                                        contentPadding: EdgeInsets.all(10.0),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HelpSupportMedia(
                                          inputType: "indPhoto"),
                                    )).then((_) => setState(() {}));
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             ImageDetailsView(
                                //                 imageURL: jsonResponse[
                                //                 'issueAttachment']))).then(
                                //         (_) => setState(() {
                                //       // getUserRatings();
                                //     }));
                              },
                              child: Stack(children: <Widget>[
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 10),
                                      child: Text(
                                        "Add Issue Attachment".toUpperCase(),
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 16,
                                            color: Color(0xff525252)),
                                      ),
                                    )),
                              ])),
                          SizedBox(
                            height: 0,
                          ),
                          Stack(children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 5, 0, 20),
                                  child: Text(
                                    AddHelpSupportTicket.individualPhotoPath !=
                                            ''
                                        ? AddHelpSupportTicket
                                            .individualPhotoPath
                                            .split('/')
                                            .last
                                        : "",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 16,
                                        color: Color(0xff525252)),
                                  ),
                                )),
                          ]),
                        ],
                      ),
                    ),
                  ])))),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Container(
                      height: 36,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 1,
                              color: Colors.blue)
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          print("onTap");
                          print("path:" +
                              AddHelpSupportTicket.individualPhotoPath);

                          if (issueTextController.text != '') {
                            saveIndividualDetails(context);
                          }
                        },
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        letterSpacing: 1,
                                        fontSize: 17,
                                        color: Color(0xffffffff)),
                                  ),
                                )),
                          ],
                        ),
                      )))),
        ])));
  }
}
