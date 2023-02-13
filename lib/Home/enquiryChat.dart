import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Core/custom_color.dart';

class EnquiryChat extends StatefulWidget {
  const EnquiryChat({super.key});

  @override
  State<EnquiryChat> createState() => _EnquiryChatState();
}

class _EnquiryChatState extends State<EnquiryChat> {
  TextEditingController chatMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.bgColor,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 55, 52, 52),
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
          title: Text("Enquiry Chat"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15,
                      top: 10,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: CustomTheme.boxColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Enquiry ID",
                                        style: TextStyle(
                                            color: CustomTheme.orengeTextColor,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "002",
                                        style: TextStyle(
                                            color: CustomTheme.buttonColor,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Enquiry Date",
                                        style: TextStyle(
                                            color: CustomTheme.orengeTextColor,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "01 Mar 2023",
                                        style: TextStyle(
                                            color: CustomTheme.white,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: CustomTheme.boxColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                child: TextFormField(
                  controller: chatMessageController,
                  // enabled: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "send msg",
                    hintStyle:
                        TextStyle(color: CustomTheme.shadowcolor, fontSize: 16),
                  ),
                  style: TextStyle(color: CustomTheme.white, fontSize: 16),
                  //maxLines: 6,
                  minLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
