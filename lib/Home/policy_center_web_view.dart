import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PolicyCenterWebViewExample extends StatefulWidget {
  String redirectionURL="";
  PolicyCenterWebViewExample(
      {required this.redirectionURL})
      ;
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<PolicyCenterWebViewExample> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff18191b),
        appBar: AppBar(
          backwardsCompatibility: false,iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
          systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Colors.black87),
          title: Text(
            'App Info Details',
            style: TextStyle(
                fontFamily: "Montserrat", fontWeight: FontWeight.bold,color: Color(0xff000000)),
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
        body:WebView(
      initialUrl: widget.redirectionURL,)
    );
  }
}