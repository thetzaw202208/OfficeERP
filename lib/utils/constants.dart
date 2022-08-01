import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_device_type/flutter_device_type.dart';

const version = "Version 1.0.0"; //fixed
String webURL = "ws://172.16.8.15:2444/api";
String loginURL =
    "http://172.16.8.15:7474/WebServices/WebService_System.asmx/do_login"; //http://172.16.8.15:3535/api/SystemLogIn/Login
String loginSuffix = "/SystemLogIn/Login";
String webURLSuffix = "/WebSocket/";
String saveDeviceInfoURL = "http://172.16.8.15:3838/api/WebUser/SaveAuthInfo";
double fontsizeLarge = 20;
double fontsizeSmall = 18;
double fontsizeSmallest = 16;
double fontSizeAlert = 14;
double fontsizeLoginTitle = 30;
double fontsizeURL = 25;
double iconsize = Device.get().isTablet ? 80 : 40;
const appname = "MAPPS Authenticator";
final Iterable<Duration> pauses = [
  const Duration(milliseconds: 500),
  const Duration(milliseconds: 500),
];
final key = encrypt.Key.fromUtf8('8080808080808080');
final iv = encrypt.IV.fromUtf8("8080808080808080");
final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
