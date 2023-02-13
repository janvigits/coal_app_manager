import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Core/custom_color.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {required this.widthRatio,
      required this.controller,
      required this.TextTitle,
      this.onChange,
      required this.keyboardType,
      this.obscureText = false,
      this.OnTap,
      this.minline,
      this.maxline,
      this.inputfortatter,
      this.redstar = false});
  final double widthRatio;
  final TextEditingController controller;
  final String TextTitle;
  final Function? onChange;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function? OnTap;
  final int? minline;
  final int? maxline;
  final int? inputfortatter;
  final bool? redstar;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                TextTitle,
                style: TextStyle(
                    fontSize: 16,
                    color: CustomTheme.white,
                    fontWeight: FontWeight.bold),
              ),
              redstar == true
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 8.0, left: 5),
                      child: Icon(
                        Icons.star,
                        size: 10,
                        color: Colors.red,
                      ),
                    )
                  : Container()
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: CustomTheme.boxColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black87.withOpacity(0.1),
                  spreadRadius: .5,
                  blurRadius: 3,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Center(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  maxLines: maxline,
                  minLines: minline,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(inputfortatter),
                  ],
                  keyboardType: keyboardType,
                  style: TextStyle(fontSize: 16, color: CustomTheme.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
