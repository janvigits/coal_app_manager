// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:naksha_ghar/Core/lang_transaction.dart';

// import '../Core/custom_color.dart';

// class CustomHeader extends StatefulWidget {
//   const CustomHeader({super.key, required this.headerTitle});
//   final String headerTitle;

//   @override
//   State<CustomHeader> createState() => _CustomHeaderState();
// }

// class _CustomHeaderState extends State<CustomHeader> {
//   String title = "";
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     title = widget.headerTitle;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width,
//           height: 290,
//           decoration: BoxDecoration(
//               color: CustomTheme.white,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                     offset: Offset(0, 1),
//                     color: Color.fromARGB(255, 182, 178, 192), //edited
//                     spreadRadius: 0.2,
//                     blurRadius: 5 //edited
//                     )
//               ]),
//           child: Column(
//             children: [
//               Image.asset(
//                 'assets/images/nakshaLogo.png',
//                 height: 180,
//                 width: MediaQuery.of(context).size.width,
//                 fit: BoxFit.cover,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 "Naksha Ghar",
//                 style: TextStyle(
//                     color: CustomTheme.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 24),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 title,
//                 style: TextStyle(
//                     color: CustomTheme.fontcolor,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: CustomFontFamily.robotoRegular),
//               ),
//               SizedBox(
//                 height: 2,
//               ),
//               Container(
//                 color: CustomTheme.smalllinecolor,
//                 width: 30,
//                 height: 3,
//               )
//             ],
//           ),
//         ),
//         Positioned(
//           bottom: 110,
//           left: 170,
//           child: Image.asset(
//             'assets/images/logo.png',
//             height: 50,
//           ),
//         )
//       ],
//     );
//   }
// }
