import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'AuthScreens/login_page.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future<void> _iosFirebaseForeground() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async {
  var initializationSettingsAndroid = new AndroidInitializationSettings('icon');
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

  await Firebase.initializeApp();
  print('Handling a background message ${event.messageId}');
  print("message recieved");
  print(event.notification.toString());
  print(event.notification!.body.toString());
  print(event.notification!.title.toString());
  // FlutterAppBadger.updateBadgeCount(1);
  final dynamic data = event.notification;
  final String jsonArray = event.notification!.body
      .toString()
      .replaceAll("{", "")
      .replaceAll("}", "");
  print(jsonArray);
  int notificationId = DateTime.now().millisecondsSinceEpoch;
  String currentTime = DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.now());
  String description = "", boardImage = "";
}

Future onSelectNotification(String? payload) async {
  // showDialog(
  //   context: context,
  //   builder: (_) {
  //     return new AlertDialog(
  //       title: Text("PayLoad"),
  //       content: Text("Payload : $payload"),
  //     );
  //   },
  // );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static String deviceToken = "";
  static String appURL = "https://www.bbedut.com/bbedut_coalMines";
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
