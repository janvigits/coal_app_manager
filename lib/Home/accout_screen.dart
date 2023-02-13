import 'package:coal_app_manager/Home/profile_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../AuthScreens/login_page.dart';
import '../Core/custom_color.dart';
import '../Core/lang_transaction.dart';
import '../Widgets/color.dart';
import '../main.dart';
import 'about_us_web_view.dart';
import 'contact_us_web_view.dart';
import 'help_support_list.dart';
import 'policy_center_list.dart';
import 'policy_web_view.dart';
import 'terms_condition_web_view.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpMobileUI();
  }
}

class SignUpMobileUI extends State<Setting> {
  String? name, imageUrl, address;
  int? userId;
  var jsonResponse;
  String language = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWebsitePages();
    getUserDetails();
  }

  getUserDetails() async {
    print("onTap:");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // counterValue = (prefs.getInt('userId'))!;
    setState(() {
      name = prefs.getString('name')!;
      imageUrl = prefs.getString('imageUrl')!;
      userId = prefs.getInt('userId')!;
    });

    // print('Pressed $counterValue times.');
  }

  getLanuage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    language = prefs.getString('lang')!;
    print('Languge' + language.toString());

    return language;
  }

  // https://www.bbedut.com/bbedut_secondHome/WS/loginData.php?method=getWebsitePages
  Future<String> getWebsitePages() async {
    String url = MyApp.appURL + "/WS/loginData.php?method=getWebsitePages";
    print(url);
    var result = await http.get(Uri.parse(url));
    // return json.decode(result.body)['data'];
    // print(jsonResponse['data'][0]['Class']);
    setState(() {
      jsonResponse = json.decode(result.body);

      print("title: " + result.body);
    });
    return "Success";
  }

  _incrementCounter(int userId, String name) async {
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

  saveLang(lang) async {
    setState(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('lang', lang);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
            title: Text("My Profile"),
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
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageUrl != null && imageUrl != ''
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: CustomTheme.buttonColor,
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(50)),
                          child: CircleAvatar(
                            radius: 48, // Image radius
                            backgroundImage: NetworkImage(imageUrl!),
                          ),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: CustomTheme.buttonColor, width: 2.5),
                              borderRadius: BorderRadius.circular(50)),
                          child: CircleAvatar(
                            radius: 48, // Image radius
                            backgroundImage:
                                AssetImage("assets/images/default.png"),
                          ),
                        ),
                ]),
            SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              name.toString(),
              style: TextStyle(color: CustomTheme.buttonColor, fontSize: 15),
            )),
            SizedBox(
              height: 25,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                    height: 105,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: CustomTheme.greyButtonColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, right: 0),
                                child: Stack(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60, top: 5, right: 0),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Profile",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.white),
                                          ))),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5, right: 20),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: CustomTheme.buttonColor,
                                          size: 20,
                                        ),
                                      ))
                                ])),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileUpdate(),
                                  )).then((value) => setState(() {
                                    getUserDetails();
                                  }));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 20),
                            child: Divider(
                              color: CustomTheme.white,
                              thickness: 1,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PolicyCenterList(
                                          appInfoId: -1, userId: userId!)));
                            },
                            child: Stack(children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 60, top: 5, right: 0),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "App Info",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: CustomTheme.white),
                                      ))),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 5, right: 20),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: CustomTheme.buttonColor,
                                      size: 20,
                                    ),
                                  ))
                            ]),
                          ),
                        ]))),
            SizedBox(
              height: 15,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: CustomTheme.greyButtonColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, right: 0),
                                child: Stack(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60, top: 5, right: 0),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "About Us",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.white),
                                          ))),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5, right: 20),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: CustomTheme.buttonColor,
                                          size: 20,
                                        ),
                                      ))
                                ])),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutUsWebViewExample(
                                      webURL: jsonResponse['aboutUs'],
                                    ),
                                  )).then((value) => setState(() {}));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 20),
                            child: Divider(
                              color: CustomTheme.white,
                              thickness: 1,
                            ),
                          ),
                          InkWell(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, right: 0),
                                child: Stack(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60, top: 5, right: 0),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Privacy Policy",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.white),
                                          ))),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5, right: 20),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: CustomTheme.buttonColor,
                                          size: 20,
                                        ),
                                      ))
                                ])),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewExample(
                                      webURL: jsonResponse['privacyPolicy'],
                                    ),
                                  )).then((value) => setState(() {}));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 20),
                            child: Divider(
                              color: CustomTheme.white,
                              thickness: 1,
                            ),
                          ),
                          InkWell(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, right: 0),
                                child: Stack(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60, top: 5, right: 0),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Contact Us",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.white),
                                          ))),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5, right: 20),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: CustomTheme.buttonColor,
                                          size: 20,
                                        ),
                                      ))
                                ])),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ContactUsWebViewExample(
                                      webURL: jsonResponse['contactUs'],
                                    ),
                                  )).then((value) => setState(() {}));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 20),
                            child: Divider(
                              color: CustomTheme.white,
                              thickness: 1,
                            ),
                          ),
                          InkWell(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, right: 0),
                                child: Stack(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60, top: 5, right: 0),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Terms & Condition",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.white),
                                          ))),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5, right: 20),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: CustomTheme.buttonColor,
                                          size: 20,
                                        ),
                                      ))
                                ])),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TermsConditionWebViewExample(
                                      webURL: jsonResponse['termsAndCondition'],
                                    ),
                                  )).then((value) => setState(() {}));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 20),
                            child: Divider(
                              color: CustomTheme.white,
                              thickness: 1,
                            ),
                          ),
                          InkWell(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, right: 0),
                                child: Stack(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60, top: 5, right: 0),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Help & Support",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.white),
                                          ))),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5, right: 20),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: CustomTheme.buttonColor,
                                          size: 20,
                                        ),
                                      ))
                                ])),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HelpSupportList(
                                      userId: userId!,
                                    ),
                                  )).then((value) => setState(() {}));
                            },
                          ),
                        ]))),
            SizedBox(
              height: 25,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 70),
                child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: CustomTheme.greyButtonColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, right: 0),
                                child: Stack(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 60, top: 5, right: 0),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Logout",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.white),
                                          ))),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5, right: 20),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: CustomTheme.buttonColor,
                                          size: 20,
                                        ),
                                      ))
                                ])),
                            onTap: () {
                              _incrementCounter(0, "");
                            },
                          )
                        ]))),
          ],
        ))));
  }
}
