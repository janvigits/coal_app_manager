import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../BottomNavigatorbar/MainBottomAppBar.dart';
import '../Core/custom_color.dart';

import '../Widgets/CustomTextField.dart';
import '../Widgets/drop_list_model.dart';
import '../Widgets/select_drop_list.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String language = '';
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool? _passwordVisible;
  FirebaseMessaging? messaging;
  BuildContext? contextVal;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _passwordVisible = true;
    masterCustomerType();

    Firebase.initializeApp();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    );
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS,
        linux: initializationSettingsLinux);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    Firebase.initializeApp();

    messaging = FirebaseMessaging.instance;
    messaging!.getToken().then((value) {
      print(value);
      MyApp.deviceToken = value!;
      print("device token:" + MyApp.deviceToken.toString());
    });
    // getNotificationSetting();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification);

      final dynamic data = event.notification!.title;
      final String jsonArray = event.notification!.body
          .toString()
          .replaceAll("{", "")
          .replaceAll("}", "");
      print(jsonArray);
      print(data);
      String currentTime =
          DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.now());
      String description = "", boardImage = "";
      int notificationId = DateTime.now().millisecondsSinceEpoch;
      // logoutPopup(
      //     "Your account is inactived by the Admin, Please contact Admin");
    });

    flutterLocalNotificationsPlugin!.cancelAll();
    _incrementCounter1();
  }

  // logoutPopup(String msg) {
  //   Dialog errorDialog = Dialog(
  //       shape:
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  //       //this right here
  //       child: WillPopScope(
  //         onWillPop: () async => false,
  //         child: Container(
  //           height: 240.0,
  //           width: 300.0,
  //           decoration: new BoxDecoration(
  //               color: Color(0xffffffff),
  //               borderRadius: new BorderRadius.only(
  //                   topLeft: const Radius.circular(20.0),
  //                   topRight: const Radius.circular(20.0),
  //                   bottomLeft: const Radius.circular(20.0),
  //                   bottomRight: const Radius.circular(20.0))),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               Padding(
  //                 padding: EdgeInsets.all(15.0),
  //                 child: Text(
  //                   'Logout',
  //                   style: TextStyle(color: Color(0xffacacac), fontSize: 18.0),
  //                 ),
  //               ),
  //               Stack(children: <Widget>[
  //                 Align(
  //                     alignment: Alignment.center,
  //                     child: Padding(
  //                       padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
  //                       child: Text(
  //                         msg,
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             color: Color(0xff000000), fontSize: 15.0),
  //                       ),
  //                     ))
  //               ]),
  //               Padding(padding: EdgeInsets.only(top: 30.0)),
  //               Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Padding(
  //                         padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
  //                         child: TextButton(
  //                             onPressed: () {
  //                               Navigator.of(context, rootNavigator: true)
  //                                   .pop('dialog');
  //                               // LaunchReview.launch().then((value) => versionDetails());
  //                               logout(0, "");
  //                               setState(() {});
  //                             },
  //                             child: Text(
  //                               'Ok',
  //                               style: TextStyle(
  //                                   color: Color(0xff000000), fontSize: 16.0),
  //                             ))),
  //                   ])
  //             ],
  //           ),
  //         ),
  //       ));
  //   showDialog(
  //       context: contextVal!,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) => errorDialog);
  //   // dialogContext=context;
  // }

  // logout(int userId, String name) async {
  //   print("onTap:");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('userId', 0);
  //   await prefs.setString('name', "");
  //   Navigator.pop(context);
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginPage()),
  //   );
  // }

  _incrementCounter1() async {
    int counterValue = 0;
    print("onTap:");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // counterValue = (prefs.getInt('userId'))!;
    prefs.getInt('userId') == null
        ? counterValue = 0
        : counterValue = prefs.getInt('userId')!;
    print('Pressed $counterValue times.');

    if (counterValue != 0) {
      print("onTap1:");

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainBottomAppBar(),
          ));
      // setState(() {
      //
      // }));
    }
  }

  _incrementCounter(int userId, String name, int number, String imageUrl,
      String address) async {
    print("onTap:");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setString('name', name);
    await prefs.setInt('mobileNo', number);
    await prefs.setString('imageUrl', imageUrl);
    await prefs.setString('address', address);
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainBottomAppBar()));
  }

//https://www.bbedut.com/bbedut_coalMines/WS/loginData.php?method=checkLoginData&mobileNo=&password=&userTypeId=2
  Future<String> checkLoginData(String userType) async {
    String url = MyApp.appURL +
        "/WS/loginData.php?method=checkLoginData&mobileNo=" +
        mobilecontroller.text.toString().trim() +
        "&password=" +
        passwordcontroller.text.toString().trim() +
        "&userTypeId=" +
        userType.toString();
    print(url);
    var result = await http.get(Uri.parse(url));

    setState(() {
      var jsonResponse = json.decode(result.body);
      if (jsonResponse['Result'] == "true") {
        // DialogBuilder(context).hideOpenDialog();

        _incrementCounter(
            jsonResponse['userId'],
            jsonResponse['name'].toString(),
            jsonResponse['mobileNo'],
            jsonResponse['imageUrl'].toString(),
            jsonResponse['address'].toString());
      } else {
        // _showFailureMessageMyDialog(context, jsonResponse['msg'], "Sorry");
      }

      print("title: " + result.body);
    });
    return "Success";
  }

  // Future<void> _showFailureMessageMyDialog(
  //     BuildContext context, String msg, String mobileNo) async {
  //   showGeneralDialog(
  //     barrierLabel: "Barrier",
  //     barrierDismissible: false,
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     transitionDuration: Duration(milliseconds: 700),
  //     context: context,
  //     pageBuilder: (_, __, ___) {
  //       return WillPopScope(
  //           onWillPop: () async => false,
  //           child: Align(
  //             alignment: Alignment.center,
  //             child: Container(
  //               height: 300,
  //               width: 300,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   Padding(
  //                     padding: EdgeInsets.all(15.0),
  //                     child: Text(
  //                       mobileNo,
  //                       style: TextStyle(
  //                           decoration: TextDecoration.none,
  //                           fontFamily: "Montserrat",
  //                           fontSize: 18,
  //                           color: Color(0xff000000)),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.all(15.0),
  //                     child: Image.asset('assets/images/cross.png',
  //                         width: 40.0, height: 40.0),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
  //                     child: Text(
  //                       msg,
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                           fontFamily: "Montserrat",
  //                           decoration: TextDecoration.none,
  //                           fontSize: 15,
  //                           color: Color(0xff000000)),
  //                     ),
  //                   ),
  //                   Padding(padding: EdgeInsets.only(top: 20.0)),
  //                   Material(
  //                       child: InkWell(
  //                     child: Container(
  //                       margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                       height: 30,
  //                       width: 60,
  //                       decoration: BoxDecoration(
  //                         color: Color(0xff004AAD),
  //                         border: Border.all(
  //                             color: Color(0xff004AAD),
  //                             // Set border color
  //                             width: 0.6),
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                       child: Stack(
  //                         children: <Widget>[
  //                           Align(
  //                               alignment: Alignment.center,
  //                               child: Padding(
  //                                 padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                                 child: Text(
  //                                   "Ok",
  //                                   style: TextStyle(
  //                                       fontFamily: "Montserrat",
  //                                       fontSize: 15,
  //                                       color: Color(0xffffffff)),
  //                                 ),
  //                               )),
  //                         ],
  //                       ),
  //                     ),
  //                     onTap: () {
  //                       print("onTap");
  //                       DialogBuilder(context).hideOpenDialog();

  //                       Navigator.pop(context);
  //                       // Navigator.pop(context);
  //                       // Navigator.pop(context);
  //                       // Navigator.pop(context, true);
  //                     },
  //                   )),
  //                 ],
  //               ),
  //               margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //             ),
  //           ));
  //     },
  //     transitionBuilder: (_, anim, __, child) {
  //       return SlideTransition(
  //         position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  Future<String> DeviceToken() async {
    String url =
        "https://www.bbedut.com/bbedut_burgerKing/loginData.php?method=updateDeviceToken&userId=" +
            9.toString().trim() +
            "&deviceToken=" +
            MyApp.deviceToken.toString().trim();
    print(url);
    var result = await http.get(Uri.parse(url));
    setState(() async {
      var jsonResponse = json.decode(result.body);
      if (jsonResponse['Result'] == "true") {
        print("device token: " + MyApp.deviceToken.toString());
      } else {
        // _showFailureMessageMyDialog(context, jsonResponse['msg'], "");
      }

      print("title: " + result.body);
    });
    return "Success";
  }

  DropListModel? userTypedropListModel;
  OptionItem userTypeOptionItemSelected =
      OptionItem(roomTypeId: 3, roomTypeName: "Manager");
  List<dynamic> masterUserTypeList = [];
  bool masterType = false;
  String userType = "3";

  Future<String> masterCustomerType() async {
    masterType = true;
    String url = MyApp.appURL + "/WS/loginData.php?method=masterUserType";
    print(url);
    var result = await http.get(Uri.parse(url));
    // return json.decode(result.body)['data'];
    // print(jsonResponse['data'][0]['Class']);
    List<OptionItem> OptionItems = [];
    setState(() {
      var jsonResponse = json.decode(result.body);
      masterUserTypeList = jsonResponse['data'];
      for (int i = 0; i < masterUserTypeList.length; i++) {
        OptionItems.add(OptionItem(
            roomTypeId: masterUserTypeList[i]['id'],
            roomTypeName: masterUserTypeList[i]['type']));
      }
      userTypedropListModel = DropListModel(OptionItems);
      masterType = false;
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
//UserType

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 55, 52, 52),
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: CustomTheme.white,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      height: 30,
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Green Gold Global".toUpperCase(),
              style: TextStyle(color: CustomTheme.buttonColor, fontSize: 18),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25, top: 20),
                  child: Column(
                    children: [
                      SelectDropList(
                        this.userTypeOptionItemSelected,
                        this.userTypedropListModel!,
                        (optionItem) {
                          userTypeOptionItemSelected = optionItem;
                          String lan = userTypeOptionItemSelected.roomTypeName
                              .toString();
                          print('lang ====' + lan);

                          setState(() {
                            userType = userTypeOptionItemSelected.roomTypeId
                                .toString();
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                          widthRatio: 0.8,
                          controller: mobilecontroller,
                          TextTitle: "Mobile Number",
                          inputfortatter: 10,
                          keyboardType: TextInputType.phone),
                      SizedBox(
                        height: 20,
                      ),
                      // CustomTextField(
                      //     widthRatio: 0.8,
                      //     controller: passwordcontroller,
                      //     TextTitle: language == "hi"
                      //         ? HindiLang.password
                      //         : EngLang.password,
                      //     keyboardType: TextInputType.phone),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: CustomTheme.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: CustomTheme.boxColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black87.withOpacity(0.1),
                                    spreadRadius: .5,
                                    blurRadius: 3,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextField(
                                  controller: passwordcontroller,
                                  obscureText: _passwordVisible!,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible!;
                                          });
                                        },
                                        child: Icon(
                                          _passwordVisible!
                                              ? Icons.visibility_off_rounded
                                              : Icons.visibility_rounded,
                                          size: 24,
                                          color: CustomTheme.buttonColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontSize: 18, color: CustomTheme.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          print("usertypoe::" + userType.toString());
                          if (mobilecontroller.text.toString().trim() == '') {
                            final snackBar = SnackBar(
                                backgroundColor: Color(0xff222222),
                                content: Text("Error Mobile Number",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 14,
                                        color: Color(0xffffffff))));
                            // globalKey.currentState.showSnackBar(snackBar);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (mobilecontroller.text
                                  .toString()
                                  .trim()
                                  .length !=
                              10) {
                            final snackBar = SnackBar(
                                backgroundColor: Color(0xff222222),
                                content: Text("errorvalidmobileno",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 14,
                                        color: Color(0xffffffff))));
                            // globalKey.currentState.showSnackBar(snackBar);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (passwordcontroller.text
                                  .toString()
                                  .trim() ==
                              '') {
                            final snackBar = SnackBar(
                                backgroundColor: Color(0xff222222),
                                content: Text("errorpassword",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 14,
                                        color: Color(0xffffffff))));
                            // globalKey.currentState.showSnackBar(snackBar);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            // DialogBuilder(context).showLoadingIndicator("");
                            // checkLoginData(userType);
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 18,
                          width: MediaQuery.of(context).size.width / 1.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: CustomTheme.buttonColor,
                          ),
                          child: Center(
                              child: Text(
                            "Login".toUpperCase(),
                            style: TextStyle(
                                fontSize: 20, color: CustomTheme.fontcolor),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class DialogBuilder {
//   DialogBuilder(this.context);

//   final BuildContext context;

//   void showLoadingIndicator(String text) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return WillPopScope(
//             onWillPop: () async => false,
//             child: AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(8.0))),
//               backgroundColor: Colors.black87,
//               content: LoadingIndicator(text: text),
//             ));
//       },
//     );
//   }

//   void hideOpenDialog() {
//     Navigator.of(context).pop();
//   }
// }

// class LoadingIndicator extends StatelessWidget {
//   LoadingIndicator({this.text = ''});

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     var displayedText = text;

//     return Container(
//         padding: EdgeInsets.all(16),
//         color: Colors.black87,
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _getLoadingIndicator(),
//               _getHeading(context),
//               _getText(displayedText)
//             ]));
//   }

//   Padding _getLoadingIndicator() {
//     return Padding(
//         child: Container(
//             child: CircularProgressIndicator(strokeWidth: 3),
//             width: 32,
//             height: 32),
//         padding: EdgeInsets.only(bottom: 16));
//   }

//   Widget _getHeading(context) {
//     return Padding(
//         child: Text(
//           'Please wait …',
//           style: TextStyle(color: Colors.white, fontSize: 16),
//           textAlign: TextAlign.center,
//         ),
//         padding: EdgeInsets.only(bottom: 4));
//   }

//   Text _getText(String displayedText) {
//     return Text(
//       displayedText,
//       style: TextStyle(color: Colors.white, fontSize: 14),
//       textAlign: TextAlign.center,
//     );
//   }
// }
