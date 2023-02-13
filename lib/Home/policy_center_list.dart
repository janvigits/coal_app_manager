import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Core/lang_transaction.dart';
import '../main.dart';
import 'policy_center_details.dart';
import 'policy_center_getter_setter.dart';

class PolicyCenterList extends StatefulWidget {
  int appInfoId = -1;
  int userId;
  PolicyCenterList({required this.appInfoId, required this.userId});
  @override
  State<StatefulWidget> createState() {
    return PolicyCenterListUI();
  }
}

class PolicyCenterListUI extends State<PolicyCenterList> {
  bool isPressed = false;
  TextEditingController emailController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<policyCenterGetterSetter> followersList = [];
  String language = '';

  _incrementCounter() async {
    print("onTap:");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString('lang')!;
    });
  }

  String getInitials(String bank_account_name) => bank_account_name.isNotEmpty
      ? bank_account_name.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';

  // https://www.alphaastrochannel.com/userData.php?method=updateAppInfoSeen&userId=9&appInfoId=34
  Future<String> updateAppInfoSeen(int appInfoId) async {
    String url = MyApp.appURL +
        "/WS/loginData.php?method=updateAppInfoSeen&userId=" +
        widget.userId.toString() +
        "&appInfoId=" +
        appInfoId.toString();
    print(url);
    var result = await http.get(Uri.parse(url));
    // return json.decode(result.body)['data'];
    // print(jsonResponse['data'][0]['Class']);
    setState(() {
      print("title: " + result.body);
    });
    return "Success";
  }

  // https://www.bbedut.com/ws/boardComment.php?method=getPolicyTokenList&username=7477043744
  Future<String> contentWriterFollowerList() async {
    String url = MyApp.appURL +
        "/WS/loginData.php?method=appInfoList&userId=" +
        widget.userId.toString();
    print(url);
    var result = await http.get(Uri.parse(url));
    // return json.decode(result.body)['data'];
    // print(jsonResponse['data'][0]['Class']);
    setState(() {
      var jsonResponse = json.decode(result.body);
      var tagObjsJson = jsonResponse['data'] as List;

      followersList = tagObjsJson
          .map((tagJson) => policyCenterGetterSetter.fromJson(tagJson))
          .toList();

      for (int i = 0; i < followersList.length; i++) {
        if (widget.appInfoId == followersList[i].appInfoId) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PolicyCenterListDetails(
                      policyCenterGetterSetterValue: followersList[i])));
        }
      }

      print("title: " + result.body);
    });
    return "Success";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _incrementCounter();
    contentWriterFollowerList();
  }

  @override
  Widget build(BuildContext context) {
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
            'App Info',
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
        body: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: followersList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 0),
                              child: InkWell(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black87.withOpacity(0.1),
                                          spreadRadius: .5,
                                          blurRadius: 1,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 0),
                                              child: Text(
                                                followersList[index].title,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff000000)),
                                              )),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 10,
                                                  top: 0,
                                                  bottom: 10),
                                              child: Text(
                                                followersList[index]
                                                    .description,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 14,
                                                    color: Color(0xff000000)),
                                              )),
                                        ])),
                                onTap: () {
                                  updateAppInfoSeen(
                                      followersList[index].appInfoId);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PolicyCenterListDetails(
                                                policyCenterGetterSetterValue:
                                                    followersList[index]),
                                      ));
                                },
                              ));
                        }))),
            followersList.length == 0
                ? Column(children: <Widget>[
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
                      language == "hi"
                          ? HindiLang.currentnothingtoshow
                          : EngLang.currentnothingtoshow,
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
                : SizedBox(
                    height: 1,
                  )
          ],
        ));
  }
}
