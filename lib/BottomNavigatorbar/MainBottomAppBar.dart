import 'dart:ui';
import 'package:flutter/material.dart';

import '../Core/custom_color.dart';
import '../Home/accout_screen.dart';
import '../Home/homePage.dart';
import '../Home/liveProduct.dart';
import '../Home/myEnquiry.dart';
import '../Home/upcomingVesselPage.dart';

class MainBottomAppBar extends StatefulWidget {
  final int currentIndex;
  final String? title;

  const MainBottomAppBar({
    this.currentIndex = 0,
    this.title,
  });
  static String bottomAppBar = 'bottomAppBar';

  @override
  _MainBottomAppBarState createState() => _MainBottomAppBarState();
}

class _MainBottomAppBarState extends State<MainBottomAppBar> {
  int _currentIndex = 0;
  String language = '';

  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
  };
  List<Widget> _bodyScreens = [
    HomePage(),
    upcomingVesselPage(),
    liveProduct(),
    Container(),
    Setting()
  ];

  void _Ontap(int index) {
    setState(
      () {
        _currentIndex = index;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.bgColor,

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
        // backgroundColor: Color.fromARGB(255, 55, 52, 52),
        // appBar: AppBar(
        //     backgroundColor: Color.fromARGB(255, 55, 52, 52),
        //     elevation: 0,
        //     title: Text(""),
        //     centerTitle: true,
        //     actions: [
        //       Row(
        //         children: [
        //           Stack(
        //             children: [
        //               Icon(
        //                 Icons.message,
        //                 size: 20,
        //               ),
        //               Positioned(
        //                 left: 11,
        //                 bottom: 12,
        //                 child: Container(
        //                   height: 10,
        //                   width: 10,
        //                   decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(5),
        //                       color: Colors.red),
        //                   child: Center(
        //                     child: Text(
        //                       "10",
        //                       style: TextStyle(
        //                           fontSize: 8, color: CustomTheme.white),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           SizedBox(
        //             width: 10,
        //           ),
        //           Icon(
        //             Icons.notifications,
        //             size: 20,
        //             color: CustomTheme.white,
        //           ),
        //           SizedBox(
        //             width: 10,
        //           )
        //         ],
        //       ),
        //     ]),
        // body: buildNavigator(),
        body: SafeArea(child: _bodyScreens[_currentIndex]),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 2),
          child: Container(
            height: 80,
            child: BottomNavigationBar(
              showSelectedLabels: true,
              selectedItemColor: CustomTheme.white,
              unselectedItemColor: Colors.white,
              currentIndex: _currentIndex,
              backgroundColor: Color.fromARGB(255, 55, 52, 52),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              iconSize: 20,
              onTap: _Ontap,
              items: [
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _currentIndex == 0
                            ? CustomTheme.buttonColor
                            : CustomTheme.boxColor),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.home,
                        color: _currentIndex == 0
                            ? CustomTheme.boxColor
                            : Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Upcoming",
                  icon: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _currentIndex == 1
                            ? CustomTheme.buttonColor
                            : CustomTheme.boxColor),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.keyboard_double_arrow_down_outlined,
                        color: _currentIndex == 1
                            ? CustomTheme.boxColor
                            : Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Live",
                  icon: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _currentIndex == 2
                            ? CustomTheme.buttonColor
                            : CustomTheme.boxColor),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        "assets/images/live.png",
                        height: 25,
                        color: _currentIndex == 2
                            ? CustomTheme.boxColor
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Enquiry",
                  icon: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _currentIndex == 3
                            ? CustomTheme.buttonColor
                            : CustomTheme.boxColor),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.headphones_rounded,
                        color: _currentIndex == 3
                            ? CustomTheme.boxColor
                            : Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Profile",
                  icon: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _currentIndex == 4
                            ? CustomTheme.buttonColor
                            : CustomTheme.boxColor),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.person,
                        color: _currentIndex == 4
                            ? CustomTheme.boxColor
                            : Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildNavigator() {
    return Navigator(
      key: navigatorKeys[_currentIndex],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (_) => _bodyScreens.elementAt(_currentIndex));
      },
    );
  }
}

class BlurryDialog extends StatelessWidget {
  String title;
  String content;
  VoidCallback continueCallBack;

  BlurryDialog(this.title, this.content, this.continueCallBack);
  TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: new Text(
            title,
            style: textStyle,
          ),
          content: new Text(
            content,
            style: textStyle,
          ),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("Continue"),
              onPressed: () {
                continueCallBack();
              },
            ),
            new ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
