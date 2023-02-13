import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Core/custom_color.dart';
import '../main.dart';

class blogSeeAll extends StatefulWidget {
  int userId;
  blogSeeAll({super.key, required this.userId});

  @override
  State<blogSeeAll> createState() => _blogSeeAllState();
}

class _blogSeeAllState extends State<blogSeeAll> {
  List<dynamic> blogGetterSetterList = [];
  late ScrollController _controller;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int apiLimit = 0;

  // https://www.bbedut.com/bbedut_nakshaGhar/WS/loginData.php?method=blogList&userId=&limit=
  Future<String> blogList() async {
    try {
      String url = MyApp.appURL +
          "/WS/loginData.php?method=blogList&userId=" +
          widget.userId.toString() +
          "&limit=0";
      print("url:" + url);
      var result = await http.get(Uri.parse(url));
      // return json.decode(result.body)['data'];
      // print(jsonResponse['data'][0]['Class']);
      setState(() {
        var jsonResponse = json.decode(result.body);
        blogGetterSetterList = jsonResponse['data'] as List;

        print("name: " + blogGetterSetterList[0]['blogTitle']);
      });
    } on Exception catch (exception) {
      if (exception.toString().contains("HandshakeException")) {}
      print("hel" + exception.toString());
      // only executed if error is of type Exception
    } catch (error) {
      print("hel1" + error.toString());
      // executed for errors of all types other than Exception
    }
    return "Success";
  }

  String k_m_b_generator(num value) {
    if (value < 999) {
      return value.toString();
    } else if (value > 999 && value < 99999) {
      return "${(value / 1000).toStringAsFixed(2)} K";
    } else if (value > 99999 && value < 999999) {
      return "${(value / 100000).toStringAsFixed(2)} L";
    } else if (value > 999999 && value < 999999999) {
      return "${(value / 1000000).toStringAsFixed(2)} M";
    } else if (value > 999999999) {
      return "${(value / 1000000000).toStringAsFixed(2)} B";
    } else {
      return value.toString();
    }
  }

  Future<Null> saveAndShare(String mediaURL, String blogURL) async {
    // _progressDialog.show;
    setState(() {
      // isBtn2 = true;
      // _progressDialog.dismiss();
    });

    // Uri uri = await _dynamicLinkService.createDynamicLink(boardID);
    var url = mediaURL;
    var response = await get(Uri.parse(url));
    final documentDirectory = (await getExternalStorageDirectory())?.path;
    File imgFile = new File('$documentDirectory/flutter.png');
    imgFile.writeAsBytesSync(response.bodyBytes);
    await FlutterShare.shareFile(
      title: 'Download app on Google play store',
      text: blogURL,
      filePath: '$documentDirectory/flutter.png' as String,
    );

    setState(() {
      // isBtn2 = false;
      // _progressDialog.dismiss();
      // Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    //blogList();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
    // Enable virtual display.
  }

  void _firstLoad() async {
    blogGetterSetterList = [];
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      String url = MyApp.appURL +
          "/WS/loginData.php?method=blogList&userId=" +
          widget.userId.toString() +
          "&limit=" +
          apiLimit.toString();

      print("ut=rl;" + url);
      var result = await http.get(Uri.parse(url));
      setState(() {
        var jsonResponse = json.decode(result.body);
        if (jsonResponse['Result'] == "true") {
          blogGetterSetterList = jsonResponse['data'] as List;

          print(result.body);
        } else {}
        print("title: " + jsonResponse["msg"].toString());
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      apiLimit = apiLimit + 10;
      try {
        String url = MyApp.appURL +
            "/WS/loginData.php?method=blogList&userId=" +
            widget.userId.toString() +
            "&limit=" +
            apiLimit.toString();
        print(url);
        var result = await http.get(Uri.parse(url));
        setState(() {
          var jsonResponse = json.decode(result.body);
          if (jsonResponse['Result'] == "true") {
            blogGetterSetterList.addAll(jsonResponse["data"]);
            setState(() {});
            print(result.body);
          } else {}
          print("title: " + jsonResponse["msg"].toString());
        });
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  Future<String> saveBlogSeen(int blogId) async {
    String url = MyApp.appURL +
        "/userData.php?method=saveBlogSeen&userId=" +
        widget.userId.toString() +
        "&blogId=" +
        blogId.toString();
    print("url:" + url);
    try {
      var result = await http.get(Uri.parse(url));
      // return json.decode(result.body)['data'];
      // print(jsonResponse['data'][0]['Class']);
      setState(() {});
    } on Exception catch (exception) {
      if (exception.toString().contains("HandshakeException")) {}
      print("hel" + exception.toString());
      // only executed if error is of type Exception
    } catch (error) {
      print("hel1" + error.toString());
      // executed for errors of all types other than Exception
    }
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.bgColor,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 30,
                  width: 30,
                  color: CustomTheme.white,
                  child: Center(
                      child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: Colors.black,
                  )),
                ),
              ),
            ),
          ),
          backgroundColor: CustomTheme.bgColor,
          elevation: 0,
          title: Text("Blogs"),
          centerTitle: true,
        ),
        body: _isFirstLoadRunning == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: blogGetterSetterList.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 5, bottom: 5),
                            child: InkWell(
                                onTap: () {
                                  if (widget.userId != 0) {
                                    if (blogGetterSetterList[index]['isSeen'] ==
                                        0) {
                                      setState(() {
                                        blogGetterSetterList[index]['isSeen'] =
                                            1;
                                        saveBlogSeen(blogGetterSetterList[index]
                                            ['blog']);
                                      });
                                    }
                                  }

                                  _launchURL(
                                      blogGetterSetterList[index]['blogUrl']);
                                },
                                child: Stack(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 0, top: 7, bottom: 0),
                                      child: Container(
                                        height: 240,
                                        width:
                                            (MediaQuery.of(context).size.width),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0xfffff9f5),
                                            ),
                                            color: Color(0xfffff9f5),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 0),
                                                  blurRadius: 2,
                                                  color: Color(0xffff6502))
                                            ],
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10))),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Stack(children: <Widget>[
                                                Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 0),
                                                        child: Container(
                                                          width: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width),
                                                          height: 145.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  blogGetterSetterList[
                                                                          index]
                                                                      [
                                                                      'blogImage']),
                                                            ),
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        0)),
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        ))),
                                                Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 8, 10, 0),
                                                        child: Container(
                                                            height: 20,
                                                            width: 55,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFffffff),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          13.0),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  offset:
                                                                      Offset(
                                                                          0, 0),
                                                                  blurRadius: 2,
                                                                  color: Color(
                                                                      0xFF555555),
                                                                )
                                                              ],
                                                            ),
                                                            child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .remove_red_eye,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 14,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                      k_m_b_generator(
                                                                          blogGetterSetterList[index]
                                                                              [
                                                                              'totalCnt']),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .justify,
                                                                      style: TextStyle(
                                                                          // fontFamily: "Montserrat",
                                                                          fontSize: 14,
                                                                          color: Color(0xff000000)))
                                                                ])))),
                                              ]),
                                              SizedBox(
                                                height: 0,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 5, 10, 0),
                                                child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        blogGetterSetterList[
                                                            index]['blogTitle'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: TextStyle(
                                                            // fontFamily: "Montserrat",
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xffbf4900)))),
                                              ),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 5, 0, 0),
                                                      child: Text(
                                                          blogGetterSetterList[
                                                                  index]
                                                              ['blogByName'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              // fontFamily: "Montserrat",
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xff666666))),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 5, 10, 0),
                                                      child: Text(
                                                          blogGetterSetterList[
                                                                  index]
                                                              ['blogDate'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              // fontFamily: "Montserrat",
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xff666666))),
                                                    )
                                                  ]),
                                              InkWell(
                                                child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 6, 10, 8),
                                                        child: Icon(
                                                          Icons.share,
                                                          color: Colors.black,
                                                          size: 18,
                                                        ))),
                                                onTap: () {
                                                  saveAndShare(
                                                      blogGetterSetterList[
                                                          index]['blogImage'],
                                                      blogGetterSetterList[
                                                          index]['blogUrl']);
                                                },
                                              )
                                            ]),
                                      )),
                                ])));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      child: Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
