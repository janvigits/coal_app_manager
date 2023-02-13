import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsConditionWebViewExample extends StatefulWidget {
  String webURL = "";
  TermsConditionWebViewExample({required this.webURL});
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<TermsConditionWebViewExample> {
  var HtmlCode = '<h1> h1 Heading Tag</h1>' +
      '<h2> h2 Heading Tag </h2>' +
      '<p> Sample Paragraph Tag </p>' +
      '<img src="https://flutter-examples.com/wp-content/uploads/2019/04/install_thumb.png" alt="Image" width="250" height="150" border="3">';

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff18191b),
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.black87),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Terms & Condition'.toUpperCase(),
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
        body: WebView(
          initialUrl: widget.webURL,
        ));
  }
}
