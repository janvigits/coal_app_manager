import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Core/lang_transaction.dart';

class AboutUsWebViewExample extends StatefulWidget {
  String webURL="";
  AboutUsWebViewExample({required this.webURL});
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<AboutUsWebViewExample> {
  @override
  void initState() {
    super.initState();
    _incrementCounter();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }
  String language = '';

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
        backgroundColor: Color(0xff18191b),
        appBar: AppBar(backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black87),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            language == "hi"
                ? HindiLang.aboutus.toUpperCase()
                : EngLang.aboutus.toUpperCase(),
            style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                color: Color(0xff525252)),
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
    body:



      WebView(
      initialUrl: widget.webURL,
    ));
  }
}