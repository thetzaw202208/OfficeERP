import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:auth_app_3fac/Login/login_screen.dart';
import 'package:auth_app_3fac/main.dart';
import 'package:auth_app_3fac/meetin_room_request/meeting_room_request.dart';
import 'package:auth_app_3fac/stationary_request/stationary_request.dart';
import 'package:auth_app_3fac/utils/changeURL.dart';
import 'package:auth_app_3fac/utils/color.dart';
import 'package:auth_app_3fac/utils/constants.dart';
import 'package:auth_app_3fac/vehicle_request/vehicle_request.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

var gender;
bool male = false;
var userID;
var userName = "__";
var deptName = "__";

class MyHomePage extends StatefulWidget {
  // MyHomePage(
  //     {Key? key, required this.userinfo, required this.userName, this.msg})
  //     : super(key: key);

  // final String userinfo;

  // final String userName;
  // final String? msg;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  BuildContext? dialogContext;

  late Timer _timer;
  bool isdata = false;
  var webSocketdata;
  var Socketmessage = "d";
  var browser = "a";
  var ip = "b";
  var oSystem = "c";
  var _channel;
  String? email;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isLoading = false;
  bool close = false;
  final spinkit = const SpinKitPouringHourGlass(
      strokeWidth: 2,
      color: maincolor,
      size: 50.0,
      duration: Duration(milliseconds: 1000));
  var _currentTab = 0;

  // var gender;
  @override
  void initState() {
    super.initState();

    final plainText = 'MAPPS';

    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    //_timer = new Timer(Duration(hours: 24), () => removeData());
    Future.delayed(const Duration(seconds: 1), () {
      //print("Executed after waiting seconds");
      _init();
    });
  }

  Future _init() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    userID = await pref.getString("userID");
    userName = pref.getString("userName")!;

    gender = pref.getString("gender");
    deptName = pref.getString("DeptName")!;
    print("Gender is");
    if (gender == "Male") {
      setState(() {
        isLoading = false;
      });
      male = true;
      print("Gender is male $male");
    } else {
      setState(() {
        isLoading = false;
      });
      male = false;
      print("Gender is male $male");
    }
  }

  @override
  Widget build(BuildContext context) {
    //dialogContext = context;
    final double shortestSide = MediaQuery.of(context)
        .size
        .shortestSide; // get the shortest side of device
    final bool useMobileLayout = shortestSide < 600.0;
    return WillPopScope(
        onWillPop: () async => exit(1),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            key: _scaffoldkey,
            builder: (context, child) => ResponsiveWrapper.builder(
                  BouncingScrollWrapper.builder(context, child!),
                  maxWidth: 1200,
                  minWidth: 450,
                  defaultScale: true,
                  breakpoints: [
                    const ResponsiveBreakpoint.resize(450, name: MOBILE),
                    const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                    const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                    const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                    const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
                  ],
                  //background: Container(color: const Color(0xFFF5F5F5))
                ),
            home: isLoading
                ? spinkit
                : Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: true,
                      toolbarHeight: Device.get().isTablet ? 80 : 70,
                      elevation: 0,
                      toolbarOpacity: 1,
                      // actions: [
                      //   IconButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           isLoading = true;
                      //         });
                      //         //_channel.sink.close();
                      //         Future.delayed(const Duration(seconds: 2), () {
                      //           //print("Refresh after waiting seconds");
                      //           //
                      //           // _init();
                      //         });
                      //         //print("Click refresh");
                      //       },
                      //       tooltip: '',
                      //       icon: Icon(
                      //         Icons.refresh_rounded,
                      //         size: 25,
                      //         color: Colors.white,
                      //       ))
                      // ],
                      backgroundColor: maincolor,
                      title: Text(
                        "Office ERP",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // bottomNavigationBar: BottomNavigationBar(
                    //   currentIndex: _currentTab,
                    //   type: BottomNavigationBarType.fixed,
                    //   onTap: (value) {
                    //     if (value == 0) {
                    //       _currentTab = value;
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => MyHomePage()));
                    //     }
                    //     if (value == 1) {
                    //       _currentTab = value;
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => ChangeURLPage(
                    //                   weburl: webURL,
                    //                   loginurl: loginURL,
                    //                   frompage: "home")));
                    //     }

                    //     if (value == 2) {
                    //       _currentTab = value;
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => LoginPage()));
                    //     }
                    //   },
                    //   items: const <BottomNavigationBarItem>[
                    //     BottomNavigationBarItem(
                    //       icon: Icon(Icons.home),
                    //       label: '',
                    //     ),
                    //     BottomNavigationBarItem(
                    //       icon: Icon(Icons.edit),
                    //       label: '',
                    //     ),
                    //     BottomNavigationBarItem(
                    //       icon: Icon(Icons.logout),
                    //       label: '',
                    //     ),
                    //   ],
                    // ),
                    body:
                        Device.get().isPhone ? androidLayout() : tabletLayout(),

                    drawer: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Drawer(
                        backgroundColor: Colors.white,
                        child: ListView(
                          padding: EdgeInsets.all(5),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.27,
                              child: DrawerHeader(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white,
                                        style: BorderStyle.solid),
                                    color: Colors.white,
                                  ),
                                  // margin: useMobileLayout
                                  //     ? EdgeInsets.only(top: 80,bottom: 20)
                                  //     : EdgeInsets.only(top: 50,bottom: 20),
                                  child: Column(
                                    children: [
                                      //Text("MAPPS Authenticator"),
                                      Image.asset(
                                        'assets/images/ERP.png',
                                        width: Device.get().isPhone
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.30
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.26,
                                        height: Device.get().isPhone
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20,
                                        // fit: BoxFit.fitHeight,
                                      ),
                                    ],
                                  )),
                            ),
                            ListTile(
                              leading: Icon(Icons.home),
                              title: Text(
                                'Home',
                                style: TextStyle(
                                    color: blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsizeSmall),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()));
                              },
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Divider(
                                  height: 1,
                                  thickness: 0.5,
                                )),
                            ListTile(
                              leading: Icon(Icons.meeting_room),
                              title: Text(
                                'Request Meeting Room',
                                style: TextStyle(
                                    color: blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: fontsizeSmall),
                              ),
                              onTap: () {
                                // if (!mounted) {
                                //   dispose();
                                // }
                                //_channel.sink.close();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MeetingRoomrequestPage()));
                              },
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Divider(
                                  height: 1,
                                  thickness: 0.5,
                                )),
                            ListTile(
                              leading: Icon(Icons.local_taxi),
                              title: Text(
                                'Vehicle Request',
                                style: TextStyle(
                                    color: blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: fontsizeSmall),
                              ),
                              onTap: () {
                                // if (!mounted) {
                                //   dispose();
                                // }
                                //_channel.sink.close();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VehicleRequestPage()));
                              },
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Divider(
                                  height: 1,
                                  thickness: 0.5,
                                )),
                            ListTile(
                              leading: Icon(Icons.add_shopping_cart_rounded),
                              title: Text(
                                'Stationary Request',
                                style: TextStyle(
                                    color: blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: fontsizeSmall),
                              ),
                              onTap: () {
                                // if (!mounted) {
                                //   dispose();
                                // }
                                //_channel.sink.close();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StationaryRequestPage()));
                              },
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Divider(
                                  height: 1,
                                  thickness: 0.5,
                                )),
                            ListTile(
                              leading: Icon(Icons.logout),
                              title: Text(
                                'Log Out',
                                style: TextStyle(
                                    color: blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: fontsizeSmall),
                              ),
                              onTap: () async {
                                // if (!mounted) {
                                //   dispose();
                                // }
                                //_channel.sink.close();
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.setString("logout", "1");
                                pref.remove("userName");
                                pref.remove("userinfo");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Divider(
                                  height: 1,
                                  thickness: 0.5,
                                )),
                          ],
                        ),
                      ),
                    ),
                  )));
  }
}

class androidLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: Device.get().isPhone
          ? const EdgeInsets.all(10.0)
          : const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: male
                        ? AssetImage('assets/images/boy.png')
                        : AssetImage('assets/images/girl.png'),
                    fit: BoxFit.fitHeight)),
            child: Stack(
              children: <Widget>[],
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              userName,
              style: TextStyle(
                  color: maincolor,
                  fontSize: fontsizeLarge,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              deptName,
              style: TextStyle(
                  color: maincolor,
                  fontSize: fontsizeLarge,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30), //DeptName
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide.none,
                        bottom: BorderSide.none,
                        left: BorderSide.none,
                        right: BorderSide.none),
                    color: Colors.white,
                  ),
                  height: Device.get().isPhone ? 100 : 200,
                  width: Device.get().isPhone ? 200 : 300,
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MeetingRoomrequestPage())),
                      print("Click Request room")
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 10,
                        child: Container(
                            child: Column(
                          children: [
                            Image.asset(
                              "assets/images/meeting-room-icon.png",
                              fit: BoxFit.cover,
                              height: 50,
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Text(
                                "Request Room",
                                style: TextStyle(
                                    color: maincolor,
                                    fontSize: fontsizeSmall,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ))),
                  )),
              Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide.none,
                        bottom: BorderSide.none,
                        left: BorderSide.none,
                        right: BorderSide.none),
                    color: Colors.white,
                  ),
                  height: Device.get().isPhone ? 100 : 200,
                  width: Device.get().isPhone ? 200 : 300,
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StationaryRequestPage())),
                      print("Click Request room")
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 10,
                        child: Container(
                            child: Column(
                          children: [
                            Image.asset(
                              "assets/images/stationery.png",
                              fit: BoxFit.fill,
                              height: 50,
                              width: 70,
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Text(
                                "Stationary Request",
                                style: TextStyle(
                                    color: maincolor,
                                    fontSize: fontsizeSmall,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ))),
                  )),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide.none,
                        bottom: BorderSide.none,
                        left: BorderSide.none,
                        right: BorderSide.none),
                    color: Colors.white,
                  ),
                  height: Device.get().isPhone ? 100 : 200,
                  width: Device.get().isPhone ? 200 : 300,
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VehicleRequestPage())),
                      print("Click Request room")
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 10,
                        child: Container(
                            child: Column(
                          children: [
                            Image.asset(
                              "assets/images/vehicle.png",
                              fit: BoxFit.cover,
                              height: 50,
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Text(
                                "Vehicle Request",
                                style: TextStyle(
                                    color: maincolor,
                                    fontSize: fontsizeSmall,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ))),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class tabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: Device.get().isPhone
          ? const EdgeInsets.all(10.0)
          : const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: male
                        ? AssetImage('assets/images/boy.png')
                        : AssetImage('assets/images/girl.png'),
                    fit: BoxFit.fitHeight)),
            child: Stack(
              children: <Widget>[],
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              userName,
              style: TextStyle(
                  color: maincolor,
                  fontSize: fontsizeLarge,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              deptName,
              style: TextStyle(
                  color: maincolor,
                  fontSize: fontsizeLarge,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MeetingRoomrequestPage()));
                  print("Click Request room ");
                },
                child: Container(
                  width: 200,
                  height: 160,
                  child: Card(
                      clipBehavior: Clip.none,
                      elevation: 20,
                      child: Container(
                          child: Column(
                        children: [
                          Image.asset(
                            "assets/images/meeting-room-icon.png",
                            fit: BoxFit.cover,
                            height: 100,
                          ),
                          SizedBox(height: 5),
                          Expanded(
                              child: Text("Request Room",
                                  style: TextStyle(
                                      color: maincolor,
                                      fontSize: fontsizeSmall,
                                      fontWeight: FontWeight.w600)))
                        ],
                      ))),
                ),
              ),
              Container(
                  height: 160,
                  width: 200,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StationaryRequestPage())),
                      print("Click Request Stationary")
                    },
                    child: Card(
                        elevation: 20,
                        child: Container(
                            child: Column(
                          children: [
                            Image.asset(
                              "assets/images/stationery.png",
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                            SizedBox(height: 5),
                            Expanded(
                                child: Text("Stationary Request",
                                    style: TextStyle(
                                        color: maincolor,
                                        fontSize: fontsizeSmall,
                                        fontWeight: FontWeight.w600)))
                          ],
                        ))),
                  )),
              Container(
                  height: 160,
                  width: 200,
                  color: Colors.white,
                  child: GestureDetector(
                    onTapUp: (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VehicleRequestPage()));
                      print("Click Request room");
                    },
                    child: Card(
                        elevation: 20,
                        child: Container(
                            child: Column(
                          children: [
                            Image.asset(
                              "assets/images/vehicle.png",
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                            SizedBox(height: 5),
                            Expanded(
                                child: Text("Vehicle Request",
                                    style: TextStyle(
                                        color: maincolor,
                                        fontSize: fontsizeSmall,
                                        fontWeight: FontWeight.w600)))
                          ],
                        ))),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
