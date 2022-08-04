// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:auth_app_3fac/Home/home_screen.dart';
import 'package:auth_app_3fac/utils/color.dart';
import 'package:auth_app_3fac/utils/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types, use_key_in_widget_constructors
class StationaryRequestPage extends StatefulWidget {
  // MeetingRoomrequestPage(
  //     {required this.loginurl, required this.weburl, required this.frompage});

  // final String loginurl;
  // final String weburl;
  // final String frompage;

  @override
  _StationaryRequestPageState createState() => _StationaryRequestPageState();
}

// class MultiSelectChip extends StatefulWidget {
//   final List<String> reportList;
//   final Function(List<String>)? onSelectionChanged;
//   final Function(List<String>)? onMaxSelected;
//   final int? maxSelection;

//   MultiSelectChip(this.reportList,
//       {this.onSelectionChanged, this.onMaxSelected, this.maxSelection});

//   @override
//   _MultiSelectChipState createState() => _MultiSelectChipState();
// }

// bool isTap = false;

// class _MultiSelectChipState extends State<MultiSelectChip> {
//   // String selectedChoice = "";
//   List<String> selectedChoices = [];

//   _buildChoiceList() {
//     List<Widget> choices = [];

//     widget.reportList.forEach((item) {
//       choices.add(Container(
//         padding: const EdgeInsets.all(2.0),
//         child: Container(
//           child: ChoiceChip(
//             backgroundColor: grey,
//             labelPadding: EdgeInsets.only(left: 10, right: 10),
//             selectedColor: maincolor,
//             label: Container(
//               width: Device.get().isPhone ? 40 : 50,
//               child: Center(
//                 child: Text(
//                   item,
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             selected: selectedChoices.contains(item),
//             onSelected: (selected) {
//               if (selectedChoices.length == (widget.maxSelection ?? -1) &&
//                   !selectedChoices.contains(item)) {
//                 widget.onMaxSelected?.call(selectedChoices);
//               } else {
//                 setState(() {
//                   selectedChoices.contains(item)
//                       ? selectedChoices.remove(item)
//                       : selectedChoices.add(item);
//                   widget.onSelectionChanged?.call(selectedChoices);
//                 });
//               }
//             },
//           ),
//         ),
//       ));
//     });
//     print(choices);
//     return choices;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: _buildChoiceList(),
//     );
//   }
// }

class _StationaryRequestPageState extends State<StationaryRequestPage> {
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _appRemark = TextEditingController();
  final TextEditingController _reqRemark = TextEditingController();

  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  List<String> rooms = [];
  List<String> roomType = [];
  List<String> facilities = [];
  List<String> meetingrooms2A = [];

  List<String> meetingrooms2B = ['Room 1/2B', 'Room 2/2B'];
  List<String> meetingrooms2C = ['Room 1/2C', 'Room 2/2C', 'Room 3/2C'];
  List<String> meetingrooms3A = ['Room 1', 'Room 2', 'Room 3', 'Room 4'];

  String? selectedFromTime;
  String? selectedToTime;
  var _currentTab = 0;
  List<String> selectedDays = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  List<String> stationaryNames = [];
  int _stackIndex = 0;
  var changecolor;
  bool onTapped = false;
  // String _singleValue = "Text alignment right";
  String _verticalGroupValue = "Normal";

  List<String> _status = ["Normal", " Urgent"];
  String? selectedValue;
  String? selectedTypeValue;
  String? selectedRoomTypeValue;
  String? selectedfacility;
  var alert_msg = "";
  var userName;
  var userID;
  var url;
  var fromDate = "From Date";
  var toDate = "To Date";
  var fromTime = "From Time";
  var toTime = "To Time";
  final timeNow = DateTime.now();
  final dateNow = DateTime.now();
  late var _items;
  bool show = false;
  List<String> _selectedAnimals = [];
  var timeType;
  // final _channel = WebSocketChannel.connect(
  //   Uri.parse('ws://172.16.8.15:2444/api/WebSocketAPi'),
  // );
  @override
  void initState() {
    super.initState();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    fromDate = formatter.format(dateNow);
    toDate = formatter.format(dateNow);
    // fromDate = DateFormat.yMd().format(dateNow);
    // toDate = DateFormat.yMd().format(dateNow);
    fromTime = DateFormat.jm().format(timeNow);
    toTime = DateFormat.jm().format(timeNow);
    _init();

    //getMeetingTypeRooms();
  }

  _init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userID = await pref.getString("userID");
    print("UserID is $userID");
    getCombo();
  }

  getCombo() async {
    try {
      var roomTyperequest = {"RequestID": userID};
      //print(LoginURL);
      print(roomTyperequest);
      var response;
      response = await http
          .post(
              Uri.parse(
                  "http://localhost:3474/WebServices/WebService_Stationary.asmx/GetStationaryNameJSONCombo"), //GetMeetingRoomNoJSON
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(roomTyperequest))
          .timeout(Duration(seconds: 60));
      var respond = jsonDecode(response.body);
      print(respond);
      var res = jsonDecode(respond['d']);
      print(res);
      stationaryNames.clear();
      for (var i = 0; i < res.length; i++) {
        stationaryNames.add(res[i]['StationaryName']);
        // roomType.add(res[i]['']);
        //roomType[i] = res[i];
      }
      print(stationaryNames);
      //print(roomType);
      //selectedRoomTypeValue = meetingrooms[0];
      //selectedTypeValue = roomType[0]['CODEDESP'];
      print("Respond Stationary value");
      // print(res);
      // List<MeetingRoomNo> tagObjs =
      //     res.map((tagJson) => MeetingRoomNo.fromJson(tagJson)).toList();
      // print(tagObjs);
      if (respond['d'] != "") {
        //saveInfo(res['data']['userData']['userId']);

        setState(() {
          //print("Login Sucess");
          // prefs.setString("logout", "0");

          //userinfo = res['d'][0]['Email'];
        });
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => MyHomePage()));
        // const snackBar = SnackBar(
        //   backgroundColor: blue,
        //   content: Text(
        //     'Get Data Room Type Successfully',
        //     style: TextStyle(color: Colors.white),
        //   ),
        // );

        // snackbarKey.currentState?.showSnackBar(snackBar);
      } else if (respond['d'] == "") {
        setState(() {
          //isLoading = false;
        });
        // const snackBar = SnackBar(
        //   backgroundColor: Colors.red,
        //   content: Text(
        //     'UserID or password is incorrect',
        //     style: TextStyle(color: Colors.white),
        //   ),
        // );

        // snackbarKey.currentState?.showSnackBar(snackBar);
      } else {
        setState(() {
          //isLoading = false;
        });
        // const snackBar = SnackBar(
        //   backgroundColor: Colors.red,
        //   content: Text(
        //     'Server respond error',
        //     style: TextStyle(color: Colors.white),
        //   ),
        // );
        // snackbarKey.currentState?.showSnackBar(snackBar);
      }
    } on TimeoutException catch (_) {
      // A timeout occurred.
      setState(() {
        //isLoading = false;
      });
      const snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Server timeout !!',
          style: TextStyle(color: Colors.white),
        ),
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    } catch (e) {
      setState(() {
        //isLoading = false;
      });
      // const snackBar = SnackBar(
      //   backgroundColor: Colors.red,
      //   content: Text(
      //     'Server error !!',
      //     style: TextStyle(color: Colors.white),
      //   ),
      // );
      // snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    // onBackData() {
    //   Navigator.pop(context);
    // }
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
        onWillPop: () async => exitHome(),
        child: MaterialApp(
            scaffoldMessengerKey: snackbarKey,
            home: Scaffold(
              appBar: AppBar(
                // actions: [
                //   Padding(
                //     padding: const EdgeInsets.only(right: 10.0),
                //     child: Icon(Icons.save),
                //   ),
                // ],
                toolbarHeight: Device.get().isTablet ? 80 : 70,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    }),
                automaticallyImplyLeading: false,
                backgroundColor: blue,
                title: Text(
                  "Stationary Request",
                ),
              ),
              backgroundColor: Colors.white,
              // bottomNavigationBar: Container(
              //   height: 60,
              //   color: maincolor,
              //   child: InkWell(
              //     onTap: () {
              //       const snackBar = SnackBar(
              //         backgroundColor: Colors.green,
              //         content: Text(
              //           'Saved Successfully !',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       );
              //       snackbarKey.currentState?.showSnackBar(snackBar);
              //     },
              //     child: Padding(
              //       padding: EdgeInsets.only(top: 8.0),
              //       child: Column(
              //         children: <Widget>[
              //           Icon(
              //             Icons.save,
              //             color: Colors.white,
              //           ),
              //           Text('Save', style: TextStyle(color: Colors.white)),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // bottomNavigationBar: BottomNavigationBar(
              //   currentIndex: _currentTab,
              //   fixedColor: Colors.white,
              //   backgroundColor: maincolor,
              //   unselectedItemColor: Colors.white,
              //   type: BottomNavigationBarType.fixed,
              //   onTap: (value) {
              //     if (value == 0) {
              //       setState(() {
              //         onTapped = true;
              //         _currentTab = value;
              //       });

              //       const snackBar = SnackBar(
              //         backgroundColor: Colors.green,
              //         content: Text(
              //           'Saved Successfully !',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       );
              //       snackbarKey.currentState?.showSnackBar(snackBar);
              //     }
              //     if (value == 1) {
              //       setState(() {
              //         _currentTab = value;
              //       });
              //       const snackBar = SnackBar(
              //         backgroundColor: Colors.green,
              //         content: Text(
              //           'Clear Data Successfully !',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       );
              //       snackbarKey.currentState?.showSnackBar(snackBar);
              //     }
              //   },
              //   items: const <BottomNavigationBarItem>[
              //     BottomNavigationBarItem(
              //       icon: Icon(Icons.save),
              //       label: 'Save',
              //     ),
              //     BottomNavigationBarItem(
              //       icon: Icon(Icons.cancel_outlined),
              //       label: 'Cancel',
              //     ),
              //   ],
              // ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: maincolor),
                        maxLines: 3,
                        //expands: true,
                        controller: _desc,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsetsDirectional.only(
                                top: 10.0, bottom: 5.0, start: 10.0, end: 10.0),
                            labelText: "Description",
                            labelStyle: TextStyle(
                                fontSize: fontsizeLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: grey, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: maincolor, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: Device.get().isPhone ? 170 : 220,
                                padding: EdgeInsets.only(left: 10),
                                //height: 70,
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      contentPadding:
                                          EdgeInsetsDirectional.only(
                                              top: 5.0,
                                              bottom: 5.0,
                                              start: 10.0,
                                              end: 10.0),
                                      labelText: "Required Date",
                                      labelStyle: TextStyle(
                                          fontSize: fontsizeLarge,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: grey, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: maincolor, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText: "",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  child: GestureDetector(
                                    onTap: () async {
                                      DateTime? newDateTime =
                                          await showRoundedDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate:
                                            DateTime(DateTime.now().year),
                                        lastDate:
                                            DateTime(DateTime.now().year + 5),
                                        borderRadius: 16,
                                      );
                                      print("Rounded Date");
                                      print(newDateTime);
                                      setState(() {
                                        final DateFormat formatter =
                                            DateFormat('yyyy-MM-dd');
                                        final String formatted =
                                            formatter.format(newDateTime!);
                                        fromDate = formatted;
                                        print(fromDate);
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$fromDate',
                                          style: TextStyle(
                                              fontSize: fontsizeSmall,
                                              fontWeight: FontWeight.w400,
                                              color: maincolor),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.calendar_month)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RadioGroup<String>.builder(
                                direction: Axis.horizontal,
                                groupValue: _verticalGroupValue,
                                horizontalAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                onChanged: (value) => setState(() {
                                  _verticalGroupValue = value!;
                                }),
                                items: _status,
                                textStyle: TextStyle(
                                    fontSize: fontsizeSmallest,
                                    fontWeight: FontWeight.w400,
                                    color: maincolor),
                                itemBuilder: (item) => RadioButtonBuilder(
                                  item,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: maincolor),
                        maxLines: 3,
                        readOnly: true,
                        //expands: true,
                        controller: _appRemark,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsetsDirectional.only(
                                top: 10.0, bottom: 5.0, start: 10.0, end: 10.0),
                            labelText: "Approver's remark",
                            labelStyle: TextStyle(
                                fontSize: fontsizeLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: grey, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: maincolor, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      //height: 250,
                      // decoration: BoxDecoration(
                      //     borderRadius:
                      //         BorderRadius.circular(5),
                      //     color: Colors.white,
                      //     border: Border.all(
                      //         width: 2, color: grey)),
                      child: InputDecorator(
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsetsDirectional.only(
                                top: 35.0, bottom: 5.0, start: 40.0, end: 40.0),
                            labelText: "  User Request Form  ",
                            labelStyle: TextStyle(
                                //backgroundColor: maincolor,
                                fontSize: fontsizeLarge,
                                fontWeight: FontWeight.bold,
                                color: maincolor),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: grey, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: maincolor, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {},
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: DropdownButtonFormField2(
                                      value: selectedValue,
                                      style: TextStyle(color: maincolor),
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: "Stationary Name",
                                        labelStyle: TextStyle(
                                            fontSize: fontsizeLarge,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                        //Add isDense true and zero Padding.
                                        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsetsDirectional.only(
                                                top: .0,
                                                bottom: .0,
                                                start: 5.0,
                                                end: 10.0),
                                        // border: OutlineInputBorder(
                                        //   borderRadius:
                                        //       BorderRadius.circular(25),
                                        // ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: grey, width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: maincolor, width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        //Add more decoration as you want here
                                        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                      ),
                                      //isExpanded: true,
                                      // hint: const Text(
                                      //   'Room No.',
                                      //   style: TextStyle(fontSize: 14),
                                      // ),

                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                        color: Colors.black45,
                                      ),
                                      iconSize: 30,
                                      buttonHeight: 60,
                                      buttonPadding: const EdgeInsets.only(
                                          left: 5, right: 10),
                                      dropdownDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),

                                      items: stationaryNames
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select room.';
                                        }
                                      },
                                      onChanged: (value) => {
                                        selectedValue = value.toString(),
                                        //change()
                                      },
                                      onSaved: (value) {
                                        //selectedValue = value.toString();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextField(
                                      style: TextStyle(color: maincolor),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.deny(
                                            RegExp("[\\.|\\,|\\-]")),
                                      ],
                                      keyboardType: TextInputType.number,
                                      controller: _qty,
                                      decoration: InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          contentPadding:
                                              EdgeInsetsDirectional.only(
                                                  top: 5.0,
                                                  bottom: 5.0,
                                                  start: 10.0,
                                                  end: 10.0),
                                          labelText: "Qty ",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: grey, width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: maincolor, width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          labelStyle: TextStyle(
                                              fontSize: fontsizeLarge,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                          border: InputBorder.none,
                                          hintText: "",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextField(
                                      style: TextStyle(color: maincolor),
                                      maxLines: 3,
                                      //expands: true,
                                      controller: _reqRemark,
                                      decoration: InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          contentPadding:
                                              EdgeInsetsDirectional.only(
                                                  top: 10.0,
                                                  bottom: 5.0,
                                                  start: 10.0,
                                                  end: 10.0),
                                          labelText: "Requester's remark",
                                          labelStyle: TextStyle(
                                              fontSize: fontsizeLarge,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: grey, width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: maincolor, width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          hintText: "",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                        focusColor: maincolor,
                        onTap: () async {
                          // setState(() {
                          //   isTap = true;
                          //   changecolor = maincolor;
                          //   print("Tappppppppppp");
                          // });
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: EdgeInsets.all(25),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(colors: [
                                      maincolor,
                                      maincolor,
                                    ])),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.save,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Save",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontsizeLarge,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              )),
                        )),
                  ],
                ),
              ),
            )));
  }

  goSave() async {
    try {
      var saverequest = {
        "createdby": "",
        "RequestId": "",
        "RequestMeetingID": "",
        "RequestBy": "",
        "roomName": "",
        "meetingRoomName": "",
        "MeetingDate": maincolor,
        "StartTime": maincolor,
        "EndTime": maincolor,
        "qty": maincolor,
        "isUrgent": maincolor,
        "Description": maincolor,
        "Remark": maincolor,
        "MeetingType": maincolor,
        "ParticipantCompany": maincolor,
        "Facility": maincolor,
        "NameOfAttendees": maincolor,
        "ScheduleStartDate": maincolor,
        "ScheduleEndDate": maincolor,
        "Monday": maincolor,
        "Tusday": maincolor,
        "Wednesday": maincolor,
        "Thursday": maincolor,
        "Friday": maincolor,
        "Saturday": maincolor,
        "Sunday": maincolor
      };
      //print(LoginURL);
      //print(loginrequest);
      var response;
      response = await http
          .post(
              Uri.parse(
                  "http://172.16.8.15:7373/WebServices/WebService_Meeting.asmx/RequestMeetingRoom"), //GetMeetingRoomNoJSON
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(saverequest))
          .timeout(Duration(seconds: 60));
      var respond = jsonDecode(response.body);
      var res = jsonDecode(respond['d']);
      print(res);
      facilities.clear();
      for (var i = 0; i < res.length; i++) {
        facilities.add(res[i]['CODEDESP']);
        // roomType.add(res[i]['']);
        //roomType[i] = res[i];
      }
      print(facilities);
      //print(roomType);
      //selectedfacility = facilities[0];
      //selectedTypeValue = roomType[0]['CODEDESP'];
      print("Respond Room Type value");
      // print(res);
      // List<MeetingRoomNo> tagObjs =
      //     res.map((tagJson) => MeetingRoomNo.fromJson(tagJson)).toList();
      // print(tagObjs);
      if (respond['d'] != "") {
        //saveInfo(res['data']['userData']['userId']);

        setState(() {
          //print("Login Sucess");
          // prefs.setString("logout", "0");

          //userinfo = res['d'][0]['Email'];
        });
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => MyHomePage()));
        const snackBar = SnackBar(
          backgroundColor: blue,
          content: Text(
            'Get Data Room Type Successfully',
            style: TextStyle(color: Colors.white),
          ),
        );

        snackbarKey.currentState?.showSnackBar(snackBar);
      } else if (respond['d'] == "") {
        setState(() {
          //isLoading = false;
        });
        const snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'UserID or password is incorrect',
            style: TextStyle(color: Colors.white),
          ),
        );

        snackbarKey.currentState?.showSnackBar(snackBar);
      } else {
        setState(() {
          //isLoading = false;
        });
        const snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Server respond error',
            style: TextStyle(color: Colors.white),
          ),
        );
        snackbarKey.currentState?.showSnackBar(snackBar);
      }
    } on TimeoutException catch (_) {
      // A timeout occurred.
      setState(() {
        //isLoading = false;
      });
      const snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Server timeout !!',
          style: TextStyle(color: Colors.white),
        ),
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    } catch (e) {
      setState(() {
        //isLoading = false;
      });
      const snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Server error !!',
          style: TextStyle(color: Colors.white),
        ),
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }

    setState(() {});

    const snackBar = SnackBar(
      backgroundColor: blue,
      content: Text(
        'Get Data Room  Successfully',
        style: TextStyle(color: Colors.white),
      ),
    );

    snackbarKey.currentState?.showSnackBar(snackBar);
  }
  // change() {
  //   setState(() {
  //     if (selectedValue == rooms[0]) {
  //       meetingrooms = meetingrooms2A;
  //     }
  //     if (selectedValue == "2B") {
  //       meetingrooms = meetingrooms2B;
  //     }
  //     if (selectedValue == "2C") {
  //       meetingrooms = meetingrooms2C;
  //     }
  //     if (selectedValue == "3A") {
  //       meetingrooms = meetingrooms3A;
  //     }
  //     if (selectedValue == "3B") {
  //       meetingrooms = meetingrooms3B;
  //     }
  //   });
  // }

  exitHome() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
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
