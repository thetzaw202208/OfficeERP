// ignore_for_file: prefer_const_constructors

import 'package:auth_app_3fac/Home/home_screen.dart';
import 'package:auth_app_3fac/Login/login_screen.dart';
import 'package:auth_app_3fac/utils/color.dart';
import 'package:auth_app_3fac/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

// ignore: camel_case_types, use_key_in_widget_constructors
class ChangeURLPage extends StatefulWidget {
  ChangeURLPage(
      {required this.loginurl, required this.weburl, required this.frompage});

  final String loginurl;
  final String weburl;
  final String frompage;

  @override
  _ChangeURLState createState() => _ChangeURLState();
}

class _ChangeURLState extends State<ChangeURLPage> {
  final TextEditingController _url = TextEditingController();
  final TextEditingController _loginurl = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
  var alert_msg = "";
  var username;
  var userinfo;
  var url;
  var loginurl;
  // final _channel = WebSocketChannel.connect(
  //   Uri.parse('ws://172.16.8.15:2444/api/WebSocketAPi'),
  // );
  @override
  void initState() {
    super.initState();

    getDeviceID();
  }

  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      //print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      //print('Switch Button is OFF');
    }
  }

  getDeviceID() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("deviceID", deviceId ?? "");
    var userName = await pref.getString("userName");
    username = await encrypter.decrypt(encrypt.Encrypted.fromBase64(userName!),
        iv: iv);
    var userInfo = pref.getString("userinfo");
    userinfo = await encrypter.decrypt(encrypt.Encrypted.fromBase64(userInfo!),
        iv: iv);
    loginurl = pref.getString("loginurl");

    url = await pref.getString("url");
    // loginurl =
    //     encrypter.decrypt(encrypt.Encrypted.fromBase64(loginUrl!), iv: iv);
    //  url =
    //       encrypter.decrypt(encrypt.Encrypted.fromBase64(Url!), iv: iv);
    if (url == null) {
      _url.text = webURL;
      //print("Global URL valueeeeeeeeee");
    } else {
      _url.text = url;
      //print("Preference URL valueeeeeeeeee");
    }
    if (loginurl == null) {
      _loginurl.text = loginURL;
    } else {
      _loginurl.text = loginurl;
    }
  }

  @override
  Widget build(BuildContext context) {
    // onBackData() {
    //   Navigator.pop(context);
    // }

    return WillPopScope(
        onWillPop: () async => exitHome(),
        child: MaterialApp(
          scaffoldMessengerKey: snackbarKey,
          home: Scaffold(
              appBar: AppBar(
                toolbarHeight: Device.get().isTablet ? 80 : 70,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      if (widget.frompage == "login") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      }
                    }),
                automaticallyImplyLeading: false,
                backgroundColor: blue,
                title: Text(
                  "Change URL",
                ),
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(143, 148, 251, .2),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(color: grey))),
                                    child: TextField(
                                      controller: _loginurl,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsetsDirectional.only(
                                                  top: 20.0,
                                                  bottom: 20.0,
                                                  start: 5.0,
                                                  end: 5.0),
                                          labelText: "API URL",
                                          labelStyle: TextStyle(
                                              fontSize: fontsizeURL,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          border: InputBorder.none,
                                          hintText: "Enter API URL",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(color: grey))),
                                    child: TextField(
                                      controller: _url,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsetsDirectional.only(
                                                  top: 20.0,
                                                  bottom: 20.0,
                                                  start: 5.0,
                                                  end: 5.0),
                                          labelText: "Websocket URL",
                                          labelStyle: TextStyle(
                                              fontSize: fontsizeURL,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          border: InputBorder.none,
                                          hintText: "Enter Websocket URL",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            InkWell(
                                onTap: () async {
                                  if (_url.text != "" && _loginurl.text != "") {
                                    webURL = _url.text;
                                    loginURL = _loginurl.text;
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    // var web = encrypter.encrypt(webURL, iv: iv);
                                    // var login =
                                    //     encrypter.encrypt(loginURL, iv: iv);
                                    pref.setString("url", webURL);
                                    pref.setString("loginurl", loginURL);
                                    const snackBar = SnackBar(
                                      backgroundColor: blue,
                                      duration: Duration(seconds: 1),
                                      content: Text(
                                        'URL changed Successfully.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );

                                    snackbarKey.currentState
                                        ?.showSnackBar(snackBar);
                                    //showAlertDialog(context);
                                    //print("Hello Click ME url ?" + webURL);
                                  }
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(25),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient:
                                              LinearGradient(colors: const [
                                            blue,
                                            Color.fromRGBO(143, 148, 251, .6),
                                          ])),
                                      child: Center(
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fontsizeLarge,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ))),
                            SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ));
  }

  exitHome() {
    if (widget.frompage == "login") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      color: blue,
      child: Text(
        "OK",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context, true);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("URL changed successfully."),
      // content: Text("You're required to log in to make your changes work!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
