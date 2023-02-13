// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:green_gold_globel/Home/chatModel.dart';

// import 'package:green_gold_globel/main.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Core/custom_color.dart';

// class ChatScreen extends StatefulWidget {
//   String enqID, chatID;

//   ChatScreen({required this.enqID, required this.chatID});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController textSendContoller = TextEditingController();
//   int userId = 0, ind = 0;
//   String yourname = "", name = '';
//   bool chatListLoader = false;
//   List<chatModel> mainChatList = [];
//   String enquiryDate = "";
//   Timer? timer;
//   String lstDateTimeOfItem = "";

//   ScrollController _controller = new ScrollController();

//   Expanded _text({required Color color, required String text}) {
//     return Expanded(
//       child: Text(
//         text,
//         style: TextStyle(color: color),
//       ),
//     );
//   }

//   _chatBubble(chatModel message, bool isMe, bool isSameUser) {
//     yourname = message.messageByName.toString();
//     if (isMe) {
//       return Column(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.topRight,
//             child: Container(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.75,
//               ),
//               padding: EdgeInsets.only(left: 2, right: 2, top: 5),
//               margin: EdgeInsets.symmetric(vertical: 5),
//               decoration: BoxDecoration(
//                 color: CustomTheme.boxColor,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10.0, top: 5, right: 10),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           message.messageByName.toString(),
//                           style: TextStyle(
//                               color: CustomTheme.buttonColor, fontSize: 12),
//                         ),
//                         Text(
//                           message.messageDate.toString(),
//                           style: TextStyle(
//                               color: CustomTheme.orengeTextColor, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         _text(
//                             text: message.message.toString(),
//                             color: Colors.white)
//                       ],
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Column(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.topLeft,
//             child: Container(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.75,
//               ),
//               padding: EdgeInsets.only(left: 2, right: 2, top: 5),
//               margin: EdgeInsets.symmetric(vertical: 5),
//               decoration: BoxDecoration(
//                 color: CustomTheme.boxColor,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10.0, top: 5, right: 10),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           message.messageByName.toString(),
//                           style: TextStyle(
//                               color: CustomTheme.buttonColor, fontSize: 12),
//                         ),
//                         Text(
//                           message.messageDate.toString(),
//                           style: TextStyle(
//                               color: CustomTheme.orengeTextColor, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         _text(
//                             text: message.message.toString(),
//                             color: Colors.white)
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//   }

//   _sendMessageArea() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8),
//       height: 80,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(15), topRight: Radius.circular(15)),
//           color: CustomTheme.black),
//       child: Padding(
//         padding:
//             const EdgeInsets.only(left: 12.0, right: 12, top: 15, bottom: 15),
//         child: Container(
//           height: 35,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               color: CustomTheme.boxColor),
//           child: Row(
//             children: <Widget>[
//               SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: TextFormField(
//                   controller: textSendContoller,
//                   decoration: InputDecoration.collapsed(
//                     hintText: 'Enter Your message..',
//                     hintStyle:
//                         TextStyle(color: CustomTheme.white, fontSize: 14),
//                   ),
//                   style: TextStyle(color: CustomTheme.white, fontSize: 14),
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   // DateTime now = new DateTime.now();
//                   // String formatter = DateFormat('d/M/y hh:mm').format(now);
//                   // print(formatter);
//                   setState(() {
//                     if (textSendContoller.text.toString().trim() != "") {
//                       saveMessage(textSendContoller.text.toString().trim());
//                     }
//                   });
//                   textSendContoller.text = "";
//                 },
//                 child: Container(
//                   height: 25,
//                   width: 25,
//                   decoration: BoxDecoration(
//                       color: CustomTheme.buttonColor,
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 15,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _incrementCounter();
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   //https://www.bbedut.com/bbedut_coalMines/WS/chatData.php?method=saveChatMessagesSeen&enquiryId=3&chatId=4&userId=1
//   Future<String> saveChatMessagesSeen() async {
//     String url = MyApp.appURL +
//         "/WS/chatData.php?method=saveChatMessagesSeen&enquiryId=" +
//         widget.enqID.toString() +
//         "&chatId=" +
//         widget.chatID.toString() +
//         "&userId=" +
//         userId.toString();
//     print("url:" + url);
//     try {
//       var result = await http.get(Uri.parse(url));
//       // return json.decode(result.body)['data'];
//       // print(jsonResponse['data'][0]['Class']);
//       setState(() {});
//     } on Exception catch (exception) {
//       if (exception.toString().contains("HandshakeException")) {}
//       print("hel" + exception.toString());
//       // only executed if error is of type Exception
//     } catch (error) {
//       print("hel1" + error.toString());
//       // executed for errors of all types other than Exception
//     }
//     return "Success";
//   }

//   _incrementCounter() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       name = prefs.getString('name')!;
//       userId = prefs.getInt('userId')!;
//     });

//     getChatList();

//     timer = Timer.periodic(Duration(seconds: 3),
//         (Timer t) => checkForNewMessageLists(lstDateTimeOfItem));
//   }

// //https://www.bbedut.com/bbedut_coalMines/WS/chatData.php?method=getNewChatMessages&enquiryId=1&chatId=1&userId=3&lastMessageDate=2023-02-03%2012:53:53
//   Future<String> checkForNewMessageLists(String newMessageDate) async {
//     String url = MyApp.appURL +
//         "/WS/chatData.php?method=getNewChatMessages&enquiryId=" +
//         widget.enqID.toString() +
//         "&chatId=" +
//         widget.chatID.toString() +
//         "&userId=" +
//         userId.toString() +
//         "&lastMessageDate=" +
//         newMessageDate.toString();
//     print("url:" + url);
//     try {
//       var result = await http.get(Uri.parse(url));
//       // return json.decode(result.body)['data'];
//       // print(jsonResponse['data'][0]['Class']);
//       setState(() {
//         var chatListJsonResponse = json.decode(result.body);

//         var tagObjsJson = chatListJsonResponse['data'] as List;
//         enquiryDate = chatListJsonResponse['enquiryDate'] as String;
//         lstDateTimeOfItem = chatListJsonResponse['newMessageDate'] as String;
//         mainChatList.addAll(
//             tagObjsJson.map((tagJson) => chatModel.fromJson(tagJson)).toList());
//         saveChatMessagesSeen();
//       });
//     } on Exception catch (exception) {
//       if (exception.toString().contains("HandshakeException")) {}
//       print("hel" + exception.toString());
//       // only executed if error is of type Exception
//     } catch (error) {
//       print("hel1" + error.toString());
//       // executed for errors of all types other than Exception
//     }
//     return "Success";
//   }

//   //https://www.bbedut.com/bbedut_coalMines/WS/chatData.php?method=getChatMessages&enquiryId=3&chatId=4&userId=9&lastMessageDate=0000-00-00%2000:00:00
//   Future<String> getChatList() async {
//     chatListLoader = true;
//     mainChatList = [];
//     String url = MyApp.appURL +
//         "/WS/chatData.php?method=getChatMessages&enquiryId=" +
//         widget.enqID.toString() +
//         "&chatId=" +
//         widget.chatID.toString() +
//         "&userId=" +
//         userId.toString() +
//         "&lastMessageDate=0000-00-00%2000:00:00";
//     print("url:" + url);
//     try {
//       var result = await http.get(Uri.parse(url));
//       // return json.decode(result.body)['data'];
//       // print(jsonResponse['data'][0]['Class']);
//       setState(() {
//         var chatListJsonResponse = json.decode(result.body);

//         var tagObjsJson = chatListJsonResponse['data'] as List;
//         enquiryDate = chatListJsonResponse['enquiryDate'] as String;
//         lstDateTimeOfItem = chatListJsonResponse['newMessageDate'] as String;

//         mainChatList =
//             tagObjsJson.map((tagJson) => chatModel.fromJson(tagJson)).toList();

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (_controller.hasClients) {
//             _controller.jumpTo(
//               _controller.position.maxScrollExtent + 200,
//             );
//           }
//         });
//         saveChatMessagesSeen();
//         chatListLoader = false;
//       });
//     } on Exception catch (exception) {
//       if (exception.toString().contains("HandshakeException")) {}
//       print("hel" + exception.toString());
//       // only executed if error is of type Exception
//     } catch (error) {
//       print("hel1" + error.toString());
//       // executed for errors of all types other than Exception
//     }
//     return "Success";
//   }

//   //https://www.bbedut.com/bbedut_coalMines/WS/chatData.php?method=saveChatMessage&enquiryId=1&chatId=1&messageById=2&message=hello
//   Future<String> saveMessage(String textSendController) async {
//     String url = MyApp.appURL +
//         "/WS/chatData.php?method=saveChatMessage&enquiryId=" +
//         widget.enqID.toString() +
//         "&chatId=" +
//         widget.chatID.toString() +
//         "&messageById=" +
//         userId.toString() +
//         "&message=" +
//         textSendController;
//     print("url:" + url);
//     try {
//       var result = await http.get(Uri.parse(url));

//       setState(() {
//         var chatListJsonResponse = json.decode(result.body);

//         checkForNewMessageLists(lstDateTimeOfItem);
//       });
//     } on Exception catch (exception) {
//       if (exception.toString().contains("HandshakeException")) {}
//       print("hel" + exception.toString());
//       // only executed if error is of type Exception
//     } catch (error) {
//       print("hel1" + error.toString());
//       // executed for errors of all types other than Exception
//     }
//     return "Success";
//   }

//   @override
//   Widget build(BuildContext context) {
//     int? prevUserId;
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   if (_controller!.hasClients) {
//     //     _controller!.jumpTo(
//     //       _controller!.position.maxScrollExtent,
//     //     );
//     //   }
//     // });
//     // SchedulerBinding.instance.addPostFrameCallback((_) {
//     //   _controller!.jumpTo(
//     //     _controller!.position.maxScrollExtent,
//     //   );
//     // });
//     return Scaffold(
//       backgroundColor: CustomTheme.bgColor,
//       appBar: AppBar(
//         backgroundColor: CustomTheme.bgColor,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(50),
//               child: Container(
//                 height: 30,
//                 width: 30,
//                 color: CustomTheme.white,
//                 child: Center(
//                     child: Icon(
//                   Icons.arrow_back_ios_rounded,
//                   size: 20,
//                   color: Colors.black,
//                 )),
//               ),
//             ),
//           ),
//         ),
//         elevation: 0,
//         title: Text("Enquiry Chat"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 15.0,
//               right: 15,
//               top: 10,
//             ),
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.9,
//               decoration: BoxDecoration(
//                 color: CustomTheme.boxColor,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0, right: 8),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 "Enquiry ID",
//                                 style: TextStyle(
//                                     color: CustomTheme.orengeTextColor,
//                                     fontSize: 12),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Text(
//                                 widget.enqID,
//                                 style: TextStyle(
//                                     color: CustomTheme.buttonColor,
//                                     fontSize: 12),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "Enquiry Date",
//                                 style: TextStyle(
//                                     color: CustomTheme.orengeTextColor,
//                                     fontSize: 12),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Text(
//                                 enquiryDate,
//                                 style: TextStyle(
//                                     color: CustomTheme.white, fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           chatListLoader == true
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : mainChatList.length == 0
//                   ? Column(children: <Widget>[
//                       Image(
//                         image: AssetImage("assets/images/no_data.png"),
//                         height: MediaQuery.of(context).size.width - 5,
//                         width: MediaQuery.of(context).size.width - 5,
//                         // color: CustomTheme.ButtonBg,
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Currently, there is nothing to show",
//                         style: TextStyle(
//                             fontFamily: "Montserrat",
//                             fontSize: 17,
//                             fontWeight: FontWeight.bold,
//                             color: CustomTheme.white),
//                       ),
//                       SizedBox(
//                         width: 3,
//                       ),
//                     ])
//                   : Expanded(
//                       child: ListView.builder(
//                         controller: _controller,
//                         reverse: false,
//                         padding: EdgeInsets.all(20),
//                         itemCount: mainChatList.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           // SchedulerBinding.instance.addPostFrameCallback((_) {
//                           //   _controller!.jumpTo(
//                           //     _controller!.position.maxScrollExtent,
//                           //   );
//                           // });
//                           final bool isMe =
//                               mainChatList[index].messageById == userId;
//                           final bool isSameUser =
//                               prevUserId == mainChatList[index].messageById;
//                           prevUserId = mainChatList[index].messageById;
//                           return _chatBubble(
//                               mainChatList[index], isMe, isSameUser);
//                         },
//                       ),
//                     ),
//           _sendMessageArea(),
//         ],
//       ),
//     );
//   }
// }
