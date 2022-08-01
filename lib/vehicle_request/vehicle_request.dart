// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:auth_app_3fac/Home/home_screen.dart';
import 'package:auth_app_3fac/Login/login_screen.dart';
import 'package:auth_app_3fac/main.dart';
import 'package:auth_app_3fac/model/meeting_room_no_model.dart';
import 'package:auth_app_3fac/utils/color.dart';
import 'package:auth_app_3fac/utils/constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>)? onSelectionChanged;
  final Function(List<String>)? onMaxSelected;
  final int? maxSelection;

  MultiSelectChip(this.reportList,
      {this.onSelectionChanged, this.onMaxSelected, this.maxSelection});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

bool isTap = false;

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
        child: Container(
          child: ChoiceChip(
            padding: EdgeInsets.all(10),
            backgroundColor: Colors.white,
            labelPadding: EdgeInsets.only(left: 10, right: 10),
            selectedColor: maincolor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: BorderSide(color: maincolor)),
            label: Container(
              width: Device.get().isPhone ? 100 : 150,
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            selected: selectedChoices.contains(item),
            onSelected: (selected) {
              if (selectedChoices.length == (widget.maxSelection ?? -1) &&
                  !selectedChoices.contains(item)) {
                widget.onMaxSelected?.call(selectedChoices);
              } else {
                setState(() {
                  selectedChoices.contains(item)
                      ? selectedChoices.remove(item)
                      : selectedChoices.add(item);
                  widget.onSelectionChanged?.call(selectedChoices);
                });
              }
            },
          ),
        ),
      ));
    });
    print(choices);
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

class VehicleRequestPage extends StatefulWidget {
  @override
  _VehicleRequestPageState createState() => _VehicleRequestPageState();
}

class _VehicleRequestPageState extends State<VehicleRequestPage> {
  final TextEditingController _noOfpassenger = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _names = TextEditingController();
  final TextEditingController _fromPlace = TextEditingController();
  final TextEditingController _toPlace = TextEditingController();

  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  List<String> rooms = [];
  List<String> roomType = [];
  List<String> facilities = [];
  List<String> meetingrooms2A = [];

  List<String> meetingrooms2B = ['Room 1/2B', 'Room 2/2B'];
  List<String> meetingrooms2C = ['Room 1/2C', 'Room 2/2C', 'Room 3/2C'];
  List<String> meetingrooms3A = ['Room 1', 'Room 2', 'Room 3', 'Room 4'];
  List<String> fromtimebox = [
    '12:00 AM',
    '12:30 AM',
    '01:00 AM',
    '01:30 AM',
    '02:00 AM',
    '02:30 AM',
    '03:00 AM',
    '03:30 AM',
    '04:00 AM',
    '04:30 AM',
    '05:00 AM',
    '05:30 AM',
    '06:00 AM',
    '06:30 AM',
    '07:00 AM',
    '07:30 AM',
    '08:00 AM',
    '08:30 AM',
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
    '06:30 PM',
    '07:00 PM',
    '07:30 PM',
    '08:00 PM',
    '08:30 PM',
    '09:00 PM',
    '09:30 PM',
    '10:00 PM',
    '10:30 PM',
    '11:00 PM',
    '11:30 PM',
  ];
  List<String> timebox = [
    '12:00 AM',
    '12:30 AM',
    '01:00 AM',
    '01:30 AM',
    '02:00 AM',
    '02:30 AM',
    '03:00 AM',
    '03:30 AM',
    '04:00 AM',
    '04:30 AM',
    '05:00 AM',
    '05:30 AM',
    '06:00 AM',
    '06:30 AM',
    '07:00 AM',
    '07:30 AM',
    '08:00 AM',
    '08:30 AM',
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
    '06:30 PM',
    '07:00 PM',
    '07:30 PM',
    '08:00 PM',
    '08:30 PM',
    '09:00 PM',
    '09:30 PM',
    '10:00 PM',
    '10:30 PM',
    '11:00 PM',
    '11:30 PM',
  ];
  List<String> days = [
    "Need Driver",
    "Round Trip",
  ];
  bool isLoading = false;
  String? selectedFromTime;
  String? selectedToTime;
  var _currentTab = 0;
  List<String> selectedDays = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  List<String> meetingrooms = [];
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
  var username;
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

  @override
  void initState() {
    super.initState();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    fromDate = formatter.format(dateNow);
    toDate = formatter.format(dateNow);

    fromTime = DateFormat.jm().format(timeNow);
    toTime = DateFormat.jm().format(timeNow);
    _items = days.map((day) => MultiSelectItem<String>(day, day)).toList();
    getData();
  }

  getData() async {
    SharedPreferences getData = await SharedPreferences.getInstance();
    userID = getData.getString("userID");
  }

  @override
  Widget build(BuildContext context) {
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    }),
                automaticallyImplyLeading: false,
                backgroundColor: blue,
                title: Text(
                  "Vehicle Request",
                ),
              ),
              backgroundColor: Colors.white,
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
                                width: Device.get().isPhone ? 180 : 220,
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
                            children: [
                              Container(
                                width: Device.get().isPhone ? 180 : 220,
                                padding: EdgeInsets.only(left: 10),
                                child: TextField(
                                  style: TextStyle(color: maincolor),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.deny(
                                        RegExp("[\\.|\\,|\\-]")),
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: _noOfpassenger,
                                  decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      contentPadding:
                                          EdgeInsetsDirectional.only(
                                              top: 5.0,
                                              bottom: 5.0,
                                              start: 10.0,
                                              end: 10.0),
                                      labelText: "Passenger ",
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
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Device.get().isPhone ? 180 : 220,
                            padding: EdgeInsets.only(left: 10),
                            height: 60,
                            child: DropdownButtonFormField2(
                              style: TextStyle(
                                  color: maincolor, fontSize: fontsizeLarge),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "From Time",
                                labelStyle: TextStyle(
                                    fontSize: fontsizeLarge,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                //Add isDense true and zero Padding.
                                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                isDense: true,
                                contentPadding: EdgeInsetsDirectional.only(
                                    top: .0, bottom: .0, start: 5.0, end: 10.0),
                                // border: OutlineInputBorder(
                                //   borderRadius:
                                //       BorderRadius.circular(25),
                                // ),
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
                                //Add more decoration as you want here
                                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                              ),
                              //isExpanded: true,
                              // hint: const Text(
                              //   'Room No.',
                              //   style: TextStyle(fontSize: 14),
                              // ),

                              icon: const Icon(
                                Icons.watch_later_outlined,
                                color: Colors.black45,
                              ),
                              iconSize: 30,
                              buttonHeight: 60,
                              buttonPadding:
                                  const EdgeInsets.only(left: 5, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              value: selectedFromTime,
                              items: timebox
                                  .map((item) => DropdownMenuItem<String>(
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
                              onChanged: (value) {
                                selectedFromTime = value.toString();
                                // if (value == "ExternalMeeting") {
                                //   setState(() {
                                //     show = true;
                                //   });
                                // } else {
                                //   setState(() {
                                //     show = false;
                                //   });
                                // }
                                //change()
                              },
                              onSaved: (value) {
                                //selectedTypeValue = value.toString();
                              },
                            ),
                          ),
                          Container(
                            width: Device.get().isPhone ? 180 : 220,
                            padding: EdgeInsets.only(left: 10),
                            height: 60,
                            // decoration: BoxDecoration(
                            //     borderRadius:
                            //         BorderRadius.circular(5),
                            //     color: Colors.white,
                            //     border: Border.all(
                            //         width: 2, color: grey)),
                            child: DropdownButtonFormField2(
                              style: TextStyle(
                                  color: maincolor, fontSize: fontsizeLarge),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "To Time",
                                labelStyle: TextStyle(
                                    fontSize: fontsizeLarge,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                //Add isDense true and zero Padding.
                                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                isDense: true,
                                contentPadding: EdgeInsetsDirectional.only(
                                    top: .0, bottom: .0, start: 5.0, end: 10.0),
                                // border: OutlineInputBorder(
                                //   borderRadius:
                                //       BorderRadius.circular(25),
                                // ),
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
                                //Add more decoration as you want here
                                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                              ),
                              //isExpanded: true,
                              // hint: const Text(
                              //   'Room No.',
                              //   style: TextStyle(fontSize: 14),
                              // ),

                              icon: const Icon(
                                Icons.watch_later_outlined,
                                color: Colors.black45,
                              ),
                              iconSize: 30,
                              buttonHeight: 60,
                              buttonPadding:
                                  const EdgeInsets.only(left: 5, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              value: selectedToTime,
                              items: timebox
                                  .map((item) => DropdownMenuItem<String>(
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
                                  return 'Please select time.';
                                }
                              },
                              onChanged: (value) {
                                selectedToTime = value.toString();
                                // if (value == "ExternalMeeting") {
                                //   setState(() {
                                //     show = true;
                                //   });
                                // } else {
                                //   setState(() {
                                //     show = false;
                                //   });
                                // }
                                //change()
                              },
                              onSaved: (value) {
                                //selectedTypeValue = value.toString();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        style: TextStyle(color: maincolor),
                        maxLines: 3,
                        //expands: true,
                        controller: _names,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsetsDirectional.only(
                                top: 10.0, bottom: 5.0, start: 10.0, end: 10.0),
                            labelText: "Name of Persons",
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
                    RadioGroup<String>.builder(
                      direction: Axis.horizontal,
                      groupValue: _verticalGroupValue,
                      horizontalAlignment: MainAxisAlignment.spaceAround,
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
                    SizedBox(
                      height: 10,
                    ),
                    MultiSelectChip(
                      days,
                      onSelectionChanged: (selectedList) {
                        setState(() {
                          isTap = true;
                          changecolor = maincolor;
                          selectedDays = selectedList;
                        });
                      },
                      // maxSelection: 2,
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
                            labelText: "  Route Detail Form  ",
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    style: TextStyle(color: maincolor),
                                    //maxLines: 3,
                                    //expands: true,
                                    controller: _fromPlace,
                                    decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        contentPadding:
                                            EdgeInsetsDirectional.only(
                                                top: 10.0,
                                                bottom: 5.0,
                                                start: 10.0,
                                                end: 10.0),
                                        labelText: "From Place",
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
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    style: TextStyle(color: maincolor),
                                    //maxLines: 3,
                                    //expands: true,
                                    controller: _toPlace,
                                    decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        contentPadding:
                                            EdgeInsetsDirectional.only(
                                                top: 10.0,
                                                bottom: 5.0,
                                                start: 10.0,
                                                end: 10.0),
                                        labelText: "To Place",
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
                                  ),
                                ),
                              ],
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
    setState(() {
      isLoading = true;
    });
    String toTimeRequest;
    String fromTimeRequest;
    var fromtimeReq = selectedFromTime.toString().split(" ");
    if (fromtimeReq[1] == "PM") {
      print("Hello");
      print(fromtimeReq[0]);
      var a = fromtimeReq[0].toString().split(":");
      print("hererererrer");
      print(a);
      var b = a[0];
      print(b);
      var f = int.parse(b) + int.parse("12");
      print(f);
      fromTimeRequest = "$f:${a[1]}";
      print(fromTimeRequest);
    } else {
      fromTimeRequest = fromtimeReq[0];
    }

    var totimeReq = selectedToTime.toString().split(" ");

    if (totimeReq[1] == "PM") {
      print("Hello");
      print(totimeReq[0]);
      var a = totimeReq[0].toString().split(":");
      print("hererererrer");
      print(a);
      var b = a[0];
      print(b);
      var f = int.parse(b) + int.parse("12");
      print(f);
      toTimeRequest = "$f:${a[1]}";
      print(toTimeRequest);
    } else {
      toTimeRequest = totimeReq[0];
    }
    try {
      var saverequest = {
        "createdby": userID,
        "RequestId": userID,
        "RequestMeetingID": "",
        //"RequestBy": userName,
        "roomName": selectedValue,
        "meetingRoomName": selectedTypeValue,
        "MeetingDate": fromDate.toString(),
        "StartTime": fromTimeRequest,
        "EndTime": toTimeRequest,
        "qty": _noOfpassenger.text,
        "isUrgent": _verticalGroupValue == "Normal" ? false : true,
        "Description": _desc.text,
        "Remark": "",
        "MeetingType": selectedRoomTypeValue,
        "ParticipantCompany": "",
        "Facility": "",

        "ScheduleStartDate": fromDate.toString(),
        "ScheduleEndDate": toDate.toString(),
      };
      //print(LoginURL);
      print(jsonEncode(saverequest));
      http.Response response;
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
      print(respond);
      // var res = jsonDecode(respond['d']);
      // print(res);
      facilities.clear();
      // for (var i = 0; i < res.length; i++) {
      //   facilities.add(res[i]['CODEDESP']);
      //   // roomType.add(res[i]['']);
      //   //roomType[i] = res[i];
      // }
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
          isLoading = false;
          //print("Login Sucess");
          // prefs.setString("logout", "0");
          AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            showCloseIcon: true,
            title: 'Success',
            desc: 'Saved Successfully',
            btnOkOnPress: () {
              debugPrint('OnClcik');
            },
            btnOkIcon: Icons.check_circle,
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
          ).show();
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
          isLoading = false;
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
          isLoading = false;
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
        isLoading = false;
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
        isLoading = false;
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
  }

  exitHome() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }
}
