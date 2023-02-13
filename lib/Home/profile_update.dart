import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Core/custom_color.dart';
import '../Core/lang_transaction.dart';
import '../Widgets/color.dart';
import '../Widgets/drop_list_model.dart';
import '../Widgets/select_drop_list.dart';
import '../Widgets/select_drop_shortlist.dart';
import '../main.dart';

class ProfileUpdate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupUI();
  }
}

class SignupUI extends State<ProfileUpdate> {
  bool isPressed = false;
  TextEditingController? nameController;
  TextEditingController? mobileNumberController;
  TextEditingController? passwordController;
  TextEditingController? newpasswordController;
  TextEditingController? confirmpasswordController;
  TextEditingController? addressController;
  TextEditingController? firmNameController;
  File? imageFile;
  String oldProfileFilePath = "";
  Response? response;
  var userDetailsJsonResponse;
  Dio dio = new Dio();
  int? mobileNumber, userId;
  String language = '';
  GlobalKey globalKey = new GlobalKey();

  String? name, imageUrl, address, firmName, customerType;
  // var jsonResponse;
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();

  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  String currentText = "";
  List<dynamic> masterCustomerTypeList = [];
  bool masterType = false;

  DropListModel? customerTypedropListModel;
  OptionItem customerTypeOptionItemSelected =
      OptionItem(roomTypeId: 0, roomTypeName: "");

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // errorController!.close();
  }

  Future<String> masterCustomerType() async {
    masterType = true;
    String url = MyApp.appURL + "/WS/loginData.php?method=masterCustomerType";
    print(url);
    var result = await http.get(Uri.parse(url));
    // return json.decode(result.body)['data'];
    // print(jsonResponse['data'][0]['Class']);
    List<OptionItem> OptionItems = [];
    setState(() {
      var jsonResponse = json.decode(result.body);
      masterCustomerTypeList = jsonResponse['data'];
      for (int i = 0; i < masterCustomerTypeList.length; i++) {
        OptionItems.add(OptionItem(
            roomTypeId: masterCustomerTypeList[i]['id'],
            roomTypeName: masterCustomerTypeList[i]['customerType']));
      }
      customerTypedropListModel = DropListModel(OptionItems);
      masterType = false;
    });
    return "Success";
  }

  // https://www.bbedut.com/bbedut_nakshaGhar/WS/loginData.php?method=userProfile&userId=1

  Future<String> userProfile() async {
    String url = MyApp.appURL +
        "/WS/loginData.php?method=userProfile&userId=" +
        userId.toString();
    print("url:" + url);
    try {
      var result = await http.get(Uri.parse(url));

      setState(() {
        userDetailsJsonResponse = json.decode(result.body);
        nameController = new TextEditingController(
            text: userDetailsJsonResponse['name'].toString());
        // passwordController = new TextEditingController(
        //     text: userDetailsJsonResponse['password'].toString());
        // newpasswordController = new TextEditingController(
        //     text: userDetailsJsonResponse['password'].toString());
        // confirmpasswordController = new TextEditingController(
        //     text: userDetailsJsonResponse['password'].toString());
        addressController = new TextEditingController(
            text: userDetailsJsonResponse['address'].toString());
        mobileNumberController = new TextEditingController(
            text: userDetailsJsonResponse['mobileNo'].toString());
        firmNameController = new TextEditingController(
            text: userDetailsJsonResponse['firmName'].toString());
        imageUrl = userDetailsJsonResponse['imageUrl'].toString();
        address = userDetailsJsonResponse['address'].toString();
        name = userDetailsJsonResponse['name'].toString();
        firmName = userDetailsJsonResponse['firmName'].toString();
        customerType = userDetailsJsonResponse['customerType'].toString();
        print("type" + customerType.toString());
        mobileNumber = userDetailsJsonResponse['mobileNo'];
        customerTypeOptionItemSelected =
            OptionItem(roomTypeId: 0, roomTypeName: customerType.toString());
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _incrementCounter();
    errorController = StreamController<ErrorAnimationType>();
    // nameController = new TextEditingController(text: '');
    passwordController = new TextEditingController(text: '');
    newpasswordController = new TextEditingController(text: '');
    confirmpasswordController = new TextEditingController(text: '');
    addressController = new TextEditingController(text: '');
    mobileNumberController = new TextEditingController(text: '');
  }

  _incrementCounter() async {
    print("onTap:");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // counterValue = (prefs.getInt('userId'))!;
    setState(() {
      name = prefs.getString('name')!;
      userId = prefs.getInt('userId')!;
      masterCustomerType();
      userProfile();

      print("address:" + address.toString());
    });

    // print('Pressed $counterValue times.');
  }

  // https://www.bbedut.com/bbedut_secondPartner/WS/loginData.php?method=getPasswordOtp&mobileNo=9826036135

  Future<String> getPasswordOtp(BuildContext context) async {
    String url = MyApp.appURL +
        "/WS/loginData.php?method=sendOtp&mobileNo=" +
        mobileNumberController!.text.toString().trim();
    print(url);
    var result = await http.get(Uri.parse(url));
    setState(() {
      var jsonResponse = json.decode(result.body);
      if (jsonResponse['Result'] == 'true') {
        _showVerifyOTPDialog(
            context, mobileNumberController!.text.toString().trim());
      } else {
        _showFailureMessageMyDialog(context, jsonResponse['msg'], "OTP");
      }
    });
    return "Success";
  }

  // https://www.bbedut.com/bbedut_transport/WS/loginData.php?method=editUserMobileNumber&userId=1&mobileNo=9826036135

  Future<String> editUserMobileNumber(
      BuildContext context, String mobileNumber) async {
    String url = MyApp.appURL +
        "/WS/loginData.php?method=editUserMobileNumber&userId=" +
        userId.toString() +
        "&mobileNo=" +
        mobileNumber;
    print(url);
    var result = await http.get(Uri.parse(url));
    // return json.decode(result.body)['data'];
    // print(jsonResponse['data'][0]['Class']);
    setState(() async {
      var jsonResponse = json.decode(result.body);
      if (jsonResponse['Result'] == "true") {
        mobileNumber = mobileNumberController!.text.toString().trim();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('mobileNo', int.parse(mobileNumber));

        _showSucessMessageMyDialog(context, jsonResponse['msg']);
      } else {
        _showFailureMessageMyDialog(context, jsonResponse['msg'], mobileNumber);
      }

      print("title: " + result.body);
    });
    return "Success";
  }

  Future<String> verifyOtp(BuildContext context, String mobileNumber) async {
    String url = MyApp.appURL +
        "/WS/loginData.php?method=verifyOtp&mobileNo=" +
        mobileNumber +
        "&loginOtp=" +
        textEditingController.text.toString().trim();
    print(url);
    var result = await http.get(Uri.parse(url));
    // return json.decode(result.body)['data'];
    // print(jsonResponse['data'][0]['Class']);
    setState(() {
      var jsonResponse = json.decode(result.body);
      if (jsonResponse['Result'] == "true") {
        editUserMobileNumber(context, mobileNumber);
      } else {
        _showFailureMessageMyDialog(context, jsonResponse['msg'], mobileNumber);
      }

      print("title: " + result.body);
    });
    return "Success";
  }

  // https://www.bbedut.com/bbedut_transport/WS/loginData.php?method=editUserPassword&userId=1&oldPassword=123456&password=1234567890

  Future<String> editUserPassword(BuildContext context) async {
    String url = MyApp.appURL +
        "/WS/loginData.php?method=editUserPassword&userId=" +
        userId.toString() +
        "&oldPassword=" +
        passwordController!.text.toString() +
        "&password=" +
        newpasswordController!.text.toString().trim();
    print(url);
    var result = await http.get(Uri.parse(url));
    setState(() {
      var jsonResponse = json.decode(result.body);

      if (jsonResponse['Result'] == 'true') {
        _showSucessMessageMyDialog(context, jsonResponse['msg']);
      } else {
        _showFailureMessageMyDialog(context, jsonResponse['msg'], 'Sorry');
      }
    });
    return "Success";
  }

  Future<Null> _pickImage(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      imageFile = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }

    if (imageFile != null) {
      setState(() {
        print("image123");
        oldProfileFilePath = imageFile!.path;
        // DialogBuilder(context).showLoadingIndicator("");
        editUserProfile(context);
        // _cropImage();
      });
    }
  }

  Future<void> editUserProfile(
    BuildContext context,
  ) async {
    // print(name);

    String uploadurl =
        MyApp.appURL + "/WS/loginData.php?method=editUserProfile";

    print("name:" + nameController!.text.toString().trim());
    print("name:" + nameController!.text.toString().trim());
    print("address:" + addressController!.text.toString().trim());

    FormData formdata = FormData.fromMap({
      "name": nameController!.text.toString().trim(),
      "userId": userId.toString(),
      "address": addressController!.text.toString().trim(),
      "customerType": customerType.toString(),
      "firmName": firmNameController!.text.toString().trim(),
    });
    if (oldProfileFilePath != null && oldProfileFilePath != '') {
      formdata = FormData.fromMap({
        "name": nameController!.text.toString().trim(),
        "userId": userId.toString(),
        "address": addressController!.text.toString().trim(),
        "firmName": firmNameController!.text.toString().trim(),
        "customerType": customerType.toString(),
        "imageUrlFile": await MultipartFile.fromFile(oldProfileFilePath,
            filename: basename(oldProfileFilePath)),
      });
    }

    response = await dio
        .post(
          uploadurl,
          data: formdata,
        )
        .catchError((Object err) {});
    // _progressDialog.dismiss();
    // imageUrl
    if (response!.statusCode == 200) {
      var jsonResponse = json.decode(response.toString());
      name = nameController!.text.toString().trim();
      address = addressController!.text.toString().trim();
      name = nameController!.text.toString().trim();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', nameController!.text.toString().trim());
      // if(jsonResponse['imageUrl']!='') {
      //   await prefs.setString('imageUrl', jsonResponse['imageUrl']);
      // }
      await prefs.setString(
          'address', addressController!.text.toString().trim());

      // userProfile();
      _showSucessMessageMyDialog(context, "Profile updated successfully");
      print(response.toString());
      // sh(
      //     context, "Success", json.decode(response.toString())['msg']);

    } else {
      print("Error during connection to server.");
    }

    print(url);
  }

  Future<String> sendOtp(BuildContext context, String mobileNumber) async {
    String url = MyApp.appURL +
        "/WS/loginData.php?method=sendOtp&mobileNo=" +
        mobileNumber;
    print(url);
    var result = await http.get(Uri.parse(url));
    // return json.decode(result.body)['data'];
    // print(jsonResponse['data'][0]['Class']);
    setState(() {
      var jsonResponse = json.decode(result.body);
      if (jsonResponse['Result'] == "true") {
        Navigator.pop(context);
      } else {
        _showFailureMessageMyDialog(
            context, jsonResponse['msg'], jsonResponse['mobileNo'].toString());
      }

      print("title: " + jsonResponse.toString());
    });
    return "Success";
  }

  Future<void> _showFailureMessageMyDialog(
      BuildContext context, String msg, String title) async {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 300,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        title,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: "Montserrat",
                            fontSize: 18,
                            color: Color(0xff000000)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Image.asset('assets/images/cross.png',
                          width: 40.0, height: 40.0),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            color: Color(0xff000000)),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Material(
                        child: InkWell(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Color(0xff004AAD),
                          border: Border.all(
                              color: Color(0xff004AAD),
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
                        // DialogBuilder(context).hideOpenDialog();

                        Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.pop(context, true);
                      },
                    )),
                  ],
                ),
                margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ));
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Future<void> _showSucessMessageMyDialog(
      BuildContext context, String message) async {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 300,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Congratulation",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: "Montserrat",
                            fontSize: 18,
                            color: Color(0xff000000)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Image.asset('assets/images/check.png',
                          width: 40.0, height: 40.0),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            color: Color(0xff000000)),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Material(
                        child: InkWell(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Color(0xff004AAD),
                          border: Border.all(
                              color: Color(0xff004AAD),
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
                        DialogBuilder(context).hideOpenDialog();
                        userProfile();
                        // Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.pop(context, true);
                      },
                    )),
                  ],
                ),
                margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ));
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Future<void> _showNewPasswordDialog(BuildContext context) async {
    //RenderObject? object = globalKey.currentContext!.findRenderObject();
    //object!.showOnScreen();
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
            onWillPop: () async => true,
            child: Align(
              alignment: Alignment.center,
              child: Form(
                key: globalKey,
                child: Container(
                  height: 420,
                  width: 300,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              language == "hi"
                                  ? HindiLang.createnewpassword
                                  : EngLang.createnewpassword,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: "Montserrat",
                                  fontSize: 20,
                                  color: Color(0xff666666)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                  child: Text(
                                    language == "hi"
                                        ? HindiLang.oldpassword
                                        : EngLang.oldpassword,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "Montserrat",
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff777777)),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Material(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                  child: Container(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: shadowColor.withOpacity(0.1),
                                            spreadRadius: .5,
                                            blurRadius: 3,
                                            offset: Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 0, 15, 3),
                                          child: TextField(
                                            controller: passwordController,
                                            autofillHints: [AutofillHints.name],
                                            decoration: InputDecoration(
                                                // labelText: 'Enter Mobile Number',
                                                hintText: 'Old Password',
                                                border: InputBorder.none),
                                            textInputAction:
                                                TextInputAction.next,
                                          ))))),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                  child: Text(
                                    language == "hi"
                                        ? HindiLang.newpassword
                                        : EngLang.newpassword,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "Montserrat",
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff777777)),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Material(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                  child: Container(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: shadowColor.withOpacity(0.1),
                                            spreadRadius: .5,
                                            blurRadius: 3,
                                            offset: Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 0, 15, 3),
                                          child: TextFormField(
                                            scrollPadding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom +
                                                    17 * 4),
                                            controller: newpasswordController,
                                            autofillHints: [AutofillHints.name],
                                            decoration: InputDecoration(
                                                // labelText: 'Enter Mobile Number',
                                                hintText: 'New Password',
                                                border: InputBorder.none),
                                            textInputAction:
                                                TextInputAction.next,
                                          ))))),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                  child: Text(
                                    language == "hi"
                                        ? HindiLang.confirmpassword
                                        : EngLang.confirmpassword,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "Montserrat",
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff777777)),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Material(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                  child: Container(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: shadowColor.withOpacity(0.1),
                                            spreadRadius: .5,
                                            blurRadius: 3,
                                            offset: Offset(0,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 0, 15, 3),
                                          child: TextField(
                                            controller:
                                                confirmpasswordController,
                                            autofillHints: [AutofillHints.name],
                                            decoration: InputDecoration(
                                                // labelText: 'Enter Mobile Number',
                                                hintText: language == "hi"
                                                    ? HindiLang.renterpassword
                                                    : EngLang.renterpassword,
                                                border: InputBorder.none),
                                            textInputAction:
                                                TextInputAction.next,
                                          ))))),
                          Padding(padding: EdgeInsets.only(top: 20.0)),
                          Material(
                              child: InkWell(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              height: 30,
                              width: 90,
                              decoration: BoxDecoration(
                                color: Color(0xff004AAD),
                                // border: Border.all(
                                //     color: Color(0xff004AAD),
                                //     // Set border color
                                //     width: 0.6),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Text(
                                          language == "hi"
                                              ? HindiLang.submit
                                              : EngLang.submit,
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
                              if (passwordController!.text.toString().trim() ==
                                  '') {
                                final snackBar = SnackBar(
                                    backgroundColor: Color(0xff222222),
                                    content: Text(
                                        'Old Password can not be left blank',
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 14,
                                            color: Color(0xffffffff))));
                                // globalKey.currentState.showSnackBar(snackBar);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else if (newpasswordController!.text
                                      .toString()
                                      .trim() ==
                                  '') {
                                final snackBar = SnackBar(
                                    backgroundColor: Color(0xff222222),
                                    content: Text(
                                        'New Password can not be left blank',
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 14,
                                            color: Color(0xffffffff))));
                                // globalKey.currentState.showSnackBar(snackBar);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else if (confirmpasswordController!.text
                                      .toString()
                                      .trim() !=
                                  newpasswordController!.text
                                      .toString()
                                      .trim()) {
                                final snackBar = SnackBar(
                                    backgroundColor: Color(0xff222222),
                                    content: Text(
                                        'New Password and Conform Password should be same',
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 14,
                                            color: Color(0xffffffff))));
                                // globalKey.currentState.showSnackBar(snackBar);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                DialogBuilder(context).hideOpenDialog();
                                editUserPassword(context);
                                passwordController!.text = "";
                                newpasswordController!.text = "";
                                confirmpasswordController!.text = "";
                              }
                              // Navigator.pop(context);
                              // Navigator.pop(context);
                              // Navigator.pop(context);
                              // Navigator.pop(context, true);
                            },
                          )),
                        ],
                      ),
                    ),
                  ),
                  margin: EdgeInsets.only(
                    bottom: 50,
                    left: 12,
                    right: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ));
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Future<void> _showVerifyOTPDialog(
      BuildContext context, String mobileNumber) async {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
            onWillPop: () async => true,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 300,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Verify OTP",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: "Montserrat",
                            fontSize: 20,
                            color: Color(0xff666666)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                            child: Text(
                              mobileNumber,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: "Montserrat",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff777777)),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                            child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width - 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor.withOpacity(0.1),
                                      spreadRadius: .5,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                    child: TextField(
                                      controller: textEditingController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(6),
                                      ],
                                      autofillHints: [AutofillHints.name],
                                      decoration: InputDecoration(
                                          // labelText: 'Enter Mobile Number',
                                          hintText: 'Enter OTP',
                                          border: InputBorder.none),
                                    ))))),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Material(
                        child: InkWell(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Color(0xff004AAD),
                          border: Border.all(
                              color: Color(0xff004AAD),
                              // Set border color
                              width: 0.6),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
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
                                        fontSize: 15,
                                        color: Color(0xffffffff)),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      onTap: () {
                        print("onTap" + currentText);
                        DialogBuilder(context).hideOpenDialog();
                        verifyOtp(context, mobileNumber);
                        // Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.pop(context, true);
                      },
                    )),
                  ],
                ),
                margin: EdgeInsets.only(
                  bottom: 50,
                  left: 12,
                  right: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ));
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Future<void> _showMobileNumberChangeDialog(BuildContext context) async {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
            onWillPop: () async => true,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 250,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        language == "hi"
                            ? HindiLang.chnagerregistrednumber
                            : EngLang.chnagerregistrednumber,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: "Montserrat",
                            fontSize: 20,
                            color: Color(0xff666666)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                            child: Text(
                              language == "hi"
                                  ? HindiLang.entermobilenumber
                                  : EngLang.entermobilenumber,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: "Montserrat",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff777777)),
                            ))
                      ],
                    ),
                    Material(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 3),
                            child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width - 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor.withOpacity(0.1),
                                      spreadRadius: .5,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                    child: TextField(
                                      controller: mobileNumberController,
                                      autofillHints: [AutofillHints.name],
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[0-9]")),
                                      ],
                                      decoration: InputDecoration(
                                          // labelText: 'Enter Mobile Number',
                                          hintText: language == "hi"
                                              ? HindiLang.entermobilenumber
                                              : EngLang.newpassword,
                                          border: InputBorder.none),
                                    ))))),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Material(
                        child: InkWell(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Color(0xff004AAD),
                          border: Border.all(
                              color: Color(0xff004AAD),
                              // Set border color
                              width: 0.6),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    language == "hi"
                                        ? HindiLang.submit
                                        : EngLang.submit,
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
                        if (mobileNumberController!.text.toString().trim() ==
                            '') {
                          final snackBar = SnackBar(
                              backgroundColor: Color(0xff222222),
                              content: Text(
                                  language == "hi"
                                      ? HindiLang.errormobilenumber
                                      : EngLang.errormobilenumber,
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      color: Color(0xffffffff))));
                          // globalKey.currentState.showSnackBar(snackBar);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          DialogBuilder(context).hideOpenDialog();
                          getPasswordOtp(context);
                        }
                        // Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.pop(context, true);
                      },
                    )),
                  ],
                ),
                margin: EdgeInsets.only(
                  bottom: 50,
                  left: 12,
                  right: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ));
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Future<void> _showNameChangeDialog(BuildContext context) async {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
            onWillPop: () async => true,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 210,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        language == "hi"
                            ? HindiLang.editprofilenmae
                            : EngLang.editprofilenmae,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: "Montserrat",
                            fontSize: 20,
                            color: Color(0xff666666)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                            child: Text(
                              language == "hi"
                                  ? HindiLang.enterprofilename
                                  : EngLang.enterprofilename,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: "Montserrat",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff777777)),
                            ))
                      ],
                    ),
                    Material(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 3),
                            child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width - 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor.withOpacity(0.1),
                                      spreadRadius: .5,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                    child: TextField(
                                      controller: nameController,
                                      autofillHints: [AutofillHints.name],
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-Z]")),
                                      ],
                                      decoration: InputDecoration(
                                          // labelText: 'Enter Mobile Number',
                                          hintText: language == "hi"
                                              ? HindiLang.enterprofilename
                                              : EngLang.enterprofilename,
                                          border: InputBorder.none),
                                    ))))),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Material(
                        child: InkWell(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Color(0xff004AAD),
                          border: Border.all(
                              color: Color(0xff004AAD),
                              // Set border color
                              width: 0.6),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    language == "hi"
                                        ? HindiLang.submit
                                        : EngLang.submit,
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
                        if (nameController!.text.toString().trim() == '') {
                          final snackBar = SnackBar(
                              backgroundColor: Color(0xff222222),
                              content: Text(
                                  language == "hi"
                                      ? HindiLang.errorname
                                      : EngLang.errorname,
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      color:
                                          Color.fromARGB(255, 166, 118, 118))));
                          // globalKey.currentState.showSnackBar(snackBar);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          DialogBuilder(context).hideOpenDialog();
                          editUserProfile(context);
                        }
                      },
                    )),
                  ],
                ),
                margin: EdgeInsets.only(
                  bottom: 50,
                  left: 12,
                  right: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ));
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Future<void> _showAddressChangeDialog(BuildContext context) async {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
            onWillPop: () async => true,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 210,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        language == "hi"
                            ? HindiLang.editprofileaddress
                            : EngLang.editprofileaddress,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: "Montserrat",
                            fontSize: 20,
                            color: Color(0xff666666)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                            child: Text(
                              language == "hi"
                                  ? HindiLang.enterprofileaddress
                                  : EngLang.enterprofileaddress,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: "Montserrat",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff777777)),
                            ))
                      ],
                    ),
                    Material(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 3),
                            child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width - 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor.withOpacity(0.1),
                                      spreadRadius: .5,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                    child: TextField(
                                      controller: addressController,
                                      autofillHints: [AutofillHints.name],
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                          // labelText: 'Enter Mobile Number',
                                          hintText: language == "hi"
                                              ? HindiLang.enterprofileaddress
                                              : EngLang.enterprofileaddress,
                                          border: InputBorder.none),
                                    ))))),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Material(
                        child: InkWell(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Color(0xff004AAD),
                          border: Border.all(
                              color: Color(0xff004AAD),
                              // Set border color
                              width: 0.6),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    language == "hi"
                                        ? HindiLang.submit
                                        : EngLang.submit,
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
                        if (addressController!.text.toString().trim() == '') {
                          final snackBar = SnackBar(
                              backgroundColor: Color(0xff222222),
                              content: Text(
                                  language == "hi"
                                      ? HindiLang.erroraddress
                                      : EngLang.erroraddress,
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      color: Color(0xffffffff))));
                          // globalKey.currentState.showSnackBar(snackBar);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          DialogBuilder(context).hideOpenDialog();
                          editUserProfile(context);
                        }
                      },
                    )),
                  ],
                ),
                margin: EdgeInsets.only(
                  bottom: 50,
                  left: 12,
                  right: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ));
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Future<void> _showFirmNameChangeDialog(BuildContext context) async {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
            onWillPop: () async => true,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 210,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Edit Firm name",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: "Montserrat",
                            fontSize: 20,
                            color: Color(0xff666666)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                            child: Text(
                              "Enter Firm Name",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: "Montserrat",
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff777777)),
                            ))
                      ],
                    ),
                    Material(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 3),
                            child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width - 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor.withOpacity(0.1),
                                      spreadRadius: .5,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                    child: TextField(
                                      controller: firmNameController,
                                      autofillHints: [AutofillHints.name],
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-Z]")),
                                      ],
                                      decoration: InputDecoration(
                                          // labelText: 'Enter Mobile Number',
                                          hintText: "Enter Firm Name",
                                          border: InputBorder.none),
                                    ))))),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Material(
                        child: InkWell(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        height: 30,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Color(0xff004AAD),
                          border: Border.all(
                              color: Color(0xff004AAD),
                              // Set border color
                              width: 0.6),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    language == "hi"
                                        ? HindiLang.submit
                                        : EngLang.submit,
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
                        if (firmNameController!.text.toString().trim() == '') {
                          final snackBar = SnackBar(
                              backgroundColor: Color(0xff222222),
                              content: Text("Firm Name can not be blank",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      color: Color(0xffffffff))));
                          // globalKey.currentState.showSnackBar(snackBar);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          DialogBuilder(context).hideOpenDialog();
                          editUserProfile(context);
                        }
                      },
                    )),
                  ],
                ),
                margin: EdgeInsets.only(
                  bottom: 50,
                  left: 12,
                  right: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ));
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
            // drawer: Container(
            //   width: MediaQuery.of(context).size.width * 0.7,
            //   color: Colors.white,
            //   child: ListView(
            //     children: [
            //       UserAccountsDrawerHeader(
            //         accountName: Text('Oflutter.com'),
            //         accountEmail: Text('example@gmail.com'),
            //         currentAccountPicture: CircleAvatar(
            //           child: ClipOval(
            //             child: Image.network(
            //               'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
            //               fit: BoxFit.cover,
            //               width: 90,
            //               height: 90,
            //             ),
            //           ),
            //         ),
            //         decoration: BoxDecoration(
            //           color: Colors.blue,
            //           image: DecorationImage(
            //               fit: BoxFit.fill,
            //               image: NetworkImage(
            //                   'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            //         ),
            //       ),
            //       Container(
            //         color: CustomTheme.white,
            //         child: Column(
            //           children: [
            //             ListTile(
            //               leading: Icon(Icons.favorite),
            //               title: Text('Favorites'),
            //               onTap: () => null,
            //             ),
            //             ListTile(
            //               leading: Icon(Icons.person),
            //               title: Text('Friends'),
            //               onTap: () => null,
            //             ),
            //             ListTile(
            //               leading: Icon(Icons.share),
            //               title: Text('Share'),
            //               onTap: () => null,
            //             ),
            //             ListTile(
            //               leading: Icon(Icons.notifications),
            //               title: Text('Request'),
            //             ),
            //             Divider(),
            //             ListTile(
            //               leading: Icon(Icons.settings),
            //               title: Text('Settings'),
            //               onTap: () => null,
            //             ),
            //             ListTile(
            //               leading: Icon(Icons.description),
            //               title: Text('Policies'),
            //               onTap: () => null,
            //             ),
            //             Divider(),
            //             ListTile(
            //               title: Text('Exit'),
            //               leading: Icon(Icons.exit_to_app),
            //               onTap: () => null,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            backgroundColor: CustomTheme.bgColor,
            appBar: AppBar(
              backgroundColor: CustomTheme.bgColor,
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
              elevation: 0,
              title: Text("My Profile"),
              centerTitle: true,
              // actions: [
              //   Row(
              //     children: [
              //       Stack(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.all(5.0),
              //             child: Icon(
              //               Icons.message,
              //               size: 20,
              //             ),
              //           ),
              //           Positioned(
              //             left: 17,
              //             bottom: 17,
              //             child: Container(
              //               height: 10,
              //               width: 10,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(5),
              //                   color: Colors.red),
              //               child: Center(
              //                 child: Text(
              //                   "10",
              //                   style: TextStyle(
              //                       fontSize: 8, color: CustomTheme.white),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Stack(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.all(5.0),
              //             child: Icon(
              //               Icons.notifications,
              //               size: 20,
              //               color: CustomTheme.white,
              //             ),
              //           ),
              //           Positioned(
              //             left: 17,
              //             bottom: 17,
              //             child: Container(
              //               height: 10,
              //               width: 10,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(5),
              //                   color: Colors.red),
              //               child: Center(
              //                 child: Text(
              //                   "10",
              //                   style: TextStyle(
              //                       fontSize: 8, color: CustomTheme.white),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         width: 10,
              //       )
              //     ],
              //   ),
              // ]),
            ),
            body: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // final isPermissionStatusGranted = await _requestPermissions();
                          // if (isPermissionStatusGranted) {
                          _pickImage(context);
                          // }
                        },
                        child: imageFile == null &&
                                imageUrl != null &&
                                imageUrl != ''
                            ? Container(
                                height: 90,
                                width: 90,
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
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: CustomTheme.buttonColor,
                                        width: 2.5),
                                    borderRadius: BorderRadius.circular(50)),
                                child: CircleAvatar(
                                  radius: 48, // Image radius
                                  backgroundImage:
                                      AssetImage("assets/images/default.png"),
                                ),
                              ),
                      ),
                    ]),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 0, bottom: 10),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 0, bottom: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      name.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: CustomTheme.buttonColor),
                                    )
                                  ]),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    language == "hi"
                                        ? HindiLang.profilename
                                        : EngLang.profilename,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: CustomTheme.orengeTextColor),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width - 40,
                                  decoration: BoxDecoration(
                                    color: CustomTheme.greyButtonColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: shadowColor.withOpacity(0.1),
                                        spreadRadius: .5,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            name.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.white),
                                          ),
                                          InkWell(
                                            child: Icon(
                                              Icons.edit,
                                              color: CustomTheme.buttonColor,
                                              size: 18,
                                            ),
                                            onTap: () {
                                              _showNameChangeDialog(context);
                                            },
                                          )
                                        ]),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    language == "hi"
                                        ? HindiLang.registernumber
                                        : EngLang.registernumber,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: CustomTheme.orengeTextColor),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width - 40,
                                  decoration: BoxDecoration(
                                    color: CustomTheme.greyButtonColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: shadowColor.withOpacity(0.1),
                                        spreadRadius: .5,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 3),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              mobileNumber.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: CustomTheme.white),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  _showMobileNumberChangeDialog(
                                                      context);
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color:
                                                      CustomTheme.buttonColor,
                                                  size: 18,
                                                ))
                                          ]))),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    language == "hi"
                                        ? HindiLang.createpassword
                                        : EngLang.createpassword,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: CustomTheme.orengeTextColor),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width - 40,
                                  decoration: BoxDecoration(
                                    color: CustomTheme.greyButtonColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: shadowColor.withOpacity(0.1),
                                        spreadRadius: .5,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 3),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "xxxxxx",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: CustomTheme.white),
                                            ),
                                            InkWell(
                                              child: Icon(
                                                Icons.edit,
                                                color: CustomTheme.buttonColor,
                                                size: 18,
                                              ),
                                              onTap: () {
                                                _showNewPasswordDialog(context);
                                              },
                                            )
                                          ]))),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    language == "hi"
                                        ? HindiLang.address
                                        : EngLang.address,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: CustomTheme.orengeTextColor),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  // height: 45,
                                  width: MediaQuery.of(context).size.width - 40,
                                  decoration: BoxDecoration(
                                    color: CustomTheme.greyButtonColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: shadowColor.withOpacity(0.1),
                                        spreadRadius: .5,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 13, 15, 13),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                // height: 45,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    110,
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 25, 0),
                                                    child: Text(
                                                      addressController!.text
                                                          .toString(),
                                                      textAlign: TextAlign.left,
                                                      maxLines: 10,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: CustomTheme
                                                              .white),
                                                    ))),
                                            InkWell(
                                              child: Icon(
                                                Icons.edit,
                                                color: CustomTheme.buttonColor,
                                                size: 18,
                                              ),
                                              onTap: () {
                                                _showAddressChangeDialog(
                                                    context);
                                              },
                                            )
                                          ]))),
                              SizedBox(
                                height: 15,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Customer Type",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: CustomTheme.orengeTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              masterType == true
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : SelectDropShortList(
                                      this.customerTypeOptionItemSelected,
                                      this.customerTypedropListModel!,
                                      (optionItem) {
                                        customerTypeOptionItemSelected =
                                            optionItem;
                                        String lan =
                                            customerTypeOptionItemSelected
                                                .roomTypeName
                                                .toString();
                                        print('lang ====' + lan);

                                        setState(() {
                                          customerType =
                                              customerTypeOptionItemSelected
                                                  .roomTypeName
                                                  .toString();
                                          // siblingGenderIdList.insert(index,
                                          //     customerTypeOptionItemSelected.roomTypeId);
                                        });
                                      },
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Firm Name",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: CustomTheme.orengeTextColor),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width - 40,
                                  decoration: BoxDecoration(
                                    color: CustomTheme.greyButtonColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: shadowColor.withOpacity(0.1),
                                        spreadRadius: .5,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 3),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            firmName.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.white),
                                          ),
                                          // InkWell(
                                          //   child: Icon(
                                          //     Icons.edit,
                                          //     color: Color(0xff006aab),
                                          //     size: 18,
                                          //   ),
                                          //   onTap: () {
                                          //     _showFirmNameChangeDialog(
                                          //         context);
                                          //   },
                                          // )
                                        ]),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ])))
              ],
            ))));
  }
}

class DialogBuilder {
  DialogBuilder(this.context);

  final BuildContext context;

  void showLoadingIndicator(String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              backgroundColor: Colors.black87,
              content: LoadingIndicator(text: text),
            ));
      },
    );
  }

  void hideOpenDialog() {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
}

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({this.text = ''});

  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
        padding: EdgeInsets.all(16),
        color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(context),
              _getText(displayedText)
            ]));
  }

  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(strokeWidth: 3),
            width: 32,
            height: 32),
        padding: EdgeInsets.only(bottom: 16));
  }

  Widget _getHeading(context) {
    return Padding(
        child: Text(
          'Please wait …',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.only(bottom: 4));
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(color: Colors.white, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
