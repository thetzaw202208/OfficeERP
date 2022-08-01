import 'dart:async';
import 'package:auth_app_3fac/Home/home_screen.dart';
import 'package:auth_app_3fac/Login/login_screen.dart';
import 'package:auth_app_3fac/meetin_room_request/meeting_room_request.dart';
import 'package:auth_app_3fac/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({
    Key? key,
    required this.msg,
  }) : super(key: key);

  final String msg;
  // ignore: non_constant_identifier_names

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  late Timer _timer;

  @override
  void initState() {
    //Hide StatusBar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    // SystemChrome.setEnabledSystemUIOverlays([]);
    loginhome();

    super.initState();
  }

  loginhome() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var logout = pref.getString("logout");
    var userinfo = pref.getString("userinfo");
    var username = pref.getString("userName");
    pref.setBool("vibrate", true);
    pref.setBool("sound", true);
    var userName;
    var userInfo;
    // if (userinfo != null) {
    //   userInfo =
    //       encrypter.decrypt(encrypt.Encrypted.fromBase64(userinfo), iv: iv);
    // }
    // if (username != null) {
    //   userName =
    //       encrypter.decrypt(encrypt.Encrypted.fromBase64(username), iv: iv);
    // }

    if (logout == "0") {
      _timer = Timer(
          const Duration(seconds: 2),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyHomePage())));
    } else {
      _timer = Timer(
          const Duration(seconds: 2),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage())));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //Hide StatusBar
    SystemChrome.setEnabledSystemUIOverlays([]);
    //Show Status bar
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Colors.white),
          child: _buildBody(context)),
    );
  }
}

Widget _buildBody(BuildContext context) {
  return Stack(
    children: [
      const Padding(
        padding: EdgeInsets.all(0.0),
        child: Align(
          alignment: Alignment.center,
          child: Image(
            height: 250,
            width: 200,
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/ERP.png',
            ),
          ),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                    color: Colors.green.withOpacity(1),
                    width: 4,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ],
  );
}
