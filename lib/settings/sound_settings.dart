// // ignore_for_file: prefer_const_constructors

// import 'package:auth_app_3fac/Home/home_screen.dart';
// import 'package:auth_app_3fac/Login/login_screen.dart';
// import 'package:auth_app_3fac/utils/color.dart';
// import 'package:auth_app_3fac/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_device_type/flutter_device_type.dart';
// import 'package:flutter_vibrate/flutter_vibrate.dart';
// import 'package:platform_device_id/platform_device_id.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;

// // ignore: camel_case_types, use_key_in_widget_constructors
// class SoundSettingsPage extends StatefulWidget {
//   SoundSettingsPage({required this.frompage});

//   final String frompage;

//   @override
//   _SoundSettingsPageState createState() => _SoundSettingsPageState();
// }

// class _SoundSettingsPageState extends State<SoundSettingsPage> {
//   final TextEditingController _url = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   final GlobalKey<ScaffoldMessengerState> snackbarKey =
//       GlobalKey<ScaffoldMessengerState>();
//   var alert_msg = "";
//   var username;
//   bool isSwitchedsound = true;
//   bool isSwitchedvibrate = true;
//   var textValue = 'Switch is OFF';
//   bool _canVibrate = true;

//   final Iterable<Duration> pauses = [
//     const Duration(milliseconds: 500),
//     const Duration(milliseconds: 1000),
//     const Duration(milliseconds: 500),
//   ];
//   var userinfo;
//   var url_bind;

//   @override
//   void initState() {
//     super.initState();
//     _init();
//     getDeviceID();
//   }

//   Future<void> _init() async {
//     bool canVibrate = await Vibrate.canVibrate;
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     pref.setBool("vibrate", true);
//     pref.setBool("sound", true);
//     isSwitchedvibrate = pref.getBool("vibrate") ?? true;
//     var userInfo = pref.getString("userinfo");
//     userinfo =
//         encrypter.decrypt(encrypt.Encrypted.fromBase64(userInfo!), iv: iv);
//     isSwitchedsound = pref.getBool("sound") ?? true;
//     setState(() {
//       _canVibrate = canVibrate;
//       _canVibrate ? vibrateCan() : vibrateCant();
//     });
//   }

//   vibrateCan() {
//     const snackBar = SnackBar(
//       backgroundColor: blue,
//       duration: Duration(milliseconds: 1000),
//       content: Text(
//         'This device can vibrate.',
//         style: TextStyle(color: Colors.white),
//       ),
//     );

//     snackbarKey.currentState?.showSnackBar(snackBar);
//   }

//   vibrateCant() {
//     const snackBar = SnackBar(
//       duration: Duration(milliseconds: 1000),
//       backgroundColor: blue,
//       content: Text(
//         "This device can't vibrate.",
//         style: TextStyle(color: Colors.white),
//       ),
//     );

//     snackbarKey.currentState?.showSnackBar(snackBar);
//   }

//   void toggleSwitchSound(bool value) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     if (isSwitchedsound == false) {
//       setState(() {
//         isSwitchedsound = true;
//         textValue = 'Switch Button is ON';

//         pref.setBool("sound", isSwitchedsound);
//       });
//       const snackBar = SnackBar(
//         backgroundColor: blue,
//         duration: Duration(milliseconds: 200),
//         content: Text(
//           'Sound is ON.',
//           style: TextStyle(color: Colors.white),
//         ),
//       );

//       snackbarKey.currentState?.showSnackBar(snackBar);
//       //print('Switch Button is ON');
//     } else {
//       setState(() {
//         isSwitchedsound = false;
//         textValue = 'Switch Button is OFF';

//         pref.setBool("sound", isSwitchedsound);
//       });
//       const snackBar = SnackBar(
//         duration: Duration(milliseconds: 200),
//         backgroundColor: blue,
//         content: Text(
//           'Sound is OFF.',
//           style: TextStyle(color: Colors.white),
//         ),
//       );

//       snackbarKey.currentState?.showSnackBar(snackBar);
//       //print('Switch Button is OFF');
//     }
//   }

//   void toggleSwitchVibrate(bool value) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     if (isSwitchedvibrate == false) {
//       setState(() {
//         isSwitchedvibrate = true;
//         textValue = 'Switch Button is ON';

//         pref.setBool("vibrate", isSwitchedvibrate);
//         if (_canVibrate) {
//           //Vibrate.vibrateWithPauses(pauses);
//         }
//       });
//       const snackBar = SnackBar(
//         backgroundColor: blue,
//         duration: Duration(milliseconds: 300),
//         content: Text(
//           'Vibrate mode is ON.',
//           style: TextStyle(color: Colors.white),
//         ),
//       );

//       snackbarKey.currentState?.showSnackBar(snackBar);
//       //print('Switch Button is ON');
//     } else {
//       setState(() {
//         isSwitchedvibrate = false;
//         textValue = 'Switch Button is OFF';

//         pref.setBool("vibrate", isSwitchedsound);
//       });
//       const snackBar = SnackBar(
//         duration: Duration(milliseconds: 300),
//         backgroundColor: blue,
//         content: Text(
//           'Vibrate mode is OFF.',
//           style: TextStyle(color: Colors.white),
//         ),
//       );

//       snackbarKey.currentState?.showSnackBar(snackBar);
//       //print('Switch Button is OFF');
//     }
//   }

//   getDeviceID() async {
//     String? deviceId = await PlatformDeviceId.getDeviceId;
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     pref.setString("deviceID", deviceId ?? "");
//     var userName = pref.getString("userName");
//     username =
//         encrypter.decrypt(encrypt.Encrypted.fromBase64(userName!), iv: iv);
//     var urlBind = pref.getString("url");
//     url_bind =
//         encrypter.decrypt(encrypt.Encrypted.fromBase64(urlBind!), iv: iv);
//     if (url_bind == null) {
//       _url.text = webURL;
//       //print("Global URL valueeeeeeeeee");
//     } else {
//       _url.text = url_bind;
//       //print("Preference URL valueeeeeeeeee");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async => exitHome(),
//         child: MaterialApp(
//           scaffoldMessengerKey: snackbarKey,
//           home: Scaffold(
//               appBar: AppBar(
//                 toolbarHeight: Device.get().isTablet ? 80 : 70,
//                 automaticallyImplyLeading: false,
//                 leading: IconButton(
//                     icon: Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () {
//                       if (widget.frompage == "login") {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LoginPage()));
//                       } else {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => MyHomePage(
//                                       userinfo: userinfo ?? "",
//                                       userName: username,
//                                     )));
//                       }
//                     }),
//                 backgroundColor: blue,
//                 title: Text(
//                   "Settings",
//                 ),
//               ),
//               backgroundColor: Colors.white,
//               body: SingleChildScrollView(
//                 child: Container(
//                   child: Column(
//                     children: <Widget>[
//                       Padding(
//                           padding: Device.get().isTablet
//                               ? EdgeInsets.all(30.0)
//                               : EdgeInsets.all(20.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Container(
//                                     padding: Device.get().isTablet
//                                         ? EdgeInsets.only(left: 50, right: 50)
//                                         : EdgeInsets.only(
//                                             left: 20,
//                                           ),
//                                     child: Text(
//                                       "Notifications",
//                                       style: TextStyle(
//                                           color: blue, fontSize: fontsizeLarge),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 30,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Padding(
//                                       padding: Device.get().isTablet
//                                           ? EdgeInsets.only(
//                                               left: 50,
//                                             )
//                                           : EdgeInsets.only(
//                                               left: 20,
//                                             ),
//                                       child: Icon(
//                                         Icons.volume_up,
//                                         size: 25,
//                                       )),
//                                   Container(
//                                     padding: Device.get().isTablet
//                                         ? EdgeInsets.only(left: 5, right: 55)
//                                         : EdgeInsets.only(left: 5, right: 85),
//                                     child: Text(
//                                       "Sound",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: fontsizeSmall),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: Device.get().isTablet
//                                         ? MediaQuery.of(context).size.width *
//                                             0.46
//                                         : MediaQuery.of(context).size.width *
//                                             0.26,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Transform.scale(
//                                           scale: 1.0,
//                                           child: Switch(
//                                             onChanged: toggleSwitchSound,
//                                             value: isSwitchedsound,
//                                             activeColor: Colors.blue,
//                                           )),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   Padding(
//                                       padding: Device.get().isTablet
//                                           ? EdgeInsets.only(
//                                               left: 50,
//                                             )
//                                           : EdgeInsets.only(
//                                               left: 20,
//                                             ),
//                                       child: Icon(
//                                         Icons.vibration,
//                                         size: 25,
//                                       )),
//                                   Container(
//                                     padding: Device.get().isTablet
//                                         ? EdgeInsets.only(left: 5, right: 50)
//                                         : EdgeInsets.only(left: 5, right: 80),
//                                     child: Text(
//                                       "Vibrate",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: fontsizeSmall),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: Device.get().isTablet
//                                         ? MediaQuery.of(context).size.width *
//                                             0.46
//                                         : MediaQuery.of(context).size.width *
//                                             0.26,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Transform.scale(
//                                           scale: 1.0,
//                                           child: Switch(
//                                             onChanged: toggleSwitchVibrate,
//                                             value: isSwitchedvibrate,
//                                             activeColor: Colors.blue,
//                                           )),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ))
//                     ],
//                   ),
//                 ),
//               )),
//         ));
//   }

//   exitHome() {
//     if (widget.frompage == "login") {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => LoginPage()));
//     } else {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => MyHomePage(
//                     userinfo: userinfo ?? "",
//                     userName: username,
//                   )));
//     }
//   }

//   showAlertDialog(BuildContext context) {
//     Widget okButton = FlatButton(
//       child: Text("OK"),
//       onPressed: () {
//         Navigator.pop(context, true);
//       },
//     );

//     // Create AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("URL change Successful"),
//       actions: [
//         okButton,
//       ],
//     );

//     // show the dialog
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
