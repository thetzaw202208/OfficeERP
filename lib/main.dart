import 'package:auth_app_3fac/Login/login_screen.dart';
import 'package:auth_app_3fac/splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

String? mssg;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();
//await AwesomeNotifications().createNotificationFromJsonData(message.data);
  //AwesomeNotifications().actionStream.listen((event) {});
  //  await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //         //simgple notification
  //         id: 124,
  //         channelKey: 'basic_channel', //set configuration wuth key "basic"
  //         title: message.data['body'].toString(),
  //         body: message.data['body'].toString(),
  //         payload: {"name": "FlutterCampus"},
  //         autoDismissible: false,
  //       ),
  //       actionButtons: [
  //         NotificationActionButton(
  //           key: "approve",
  //           label: "Approve",
  //         ),
  //         NotificationActionButton(
  //           key: "deny",
  //           label: "Deny",
  //         )
  //       ]);
  if (message.messageId != null) {
    mssg = message.messageId;
  }

  print("Handling Main a background message: ${message.messageId}");
}

// @override
// void dispose() {
//   AwesomeNotifications().actionSink.close();
//   AwesomeNotifications().createdSink.close();
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // AwesomeNotifications().initialize(
  //   null,
  //   [
  //     NotificationChannel(

  //         channelKey: 'basic_channel',
  //         channelName: 'Basic notifications',
  //         channelDescription: 'Notification channel for basic tests',
  //         defaultColor: Color(0xFF9D50DD),
  //         ledColor: Colors.white,
  //         importance: NotificationImportance.High,
  //         enableVibration: true,
  //         playSound: true,
  //         //icon: '@mipmap/launcher_icon'
  //     ),

  //   ],

  // );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // AwesomeNotifications().actionStream.listen((event) {
  //     if (event.buttonKeyInput == 'deny') {
  //       print("deny");
  //     } else {
  //       print("approve click");
  //     }
  //   });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldkey =
        new GlobalKey<ScaffoldState>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      key: _scaffoldkey,
      builder: (context, child) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child!),
          maxWidth: 1200,
          minWidth: 350,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(350, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: const Color(0xFFF5F5F5))),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenPage(msg: mssg ?? ""),
    );
  }
}
