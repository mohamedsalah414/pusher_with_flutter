import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_url.dart';
import '../view/auth/log_in/log_in_screen.dart';
import '../viewModel/authVm.dart';

class AuthApi {
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  static Future<void> newToken( BuildContext context) async {
    const storage = FlutterSecureStorage();
    print('hi from new tokeenn');
    var refreshToken = await storage.read(
        key: 'refresh_token', aOptions: _getAndroidOptions());

    var request = http.Request(
        'GET', Uri.parse('${ApiUrl.baseURL}/auth/getNewToken/customer'));
    var headers = {'Authorization': refreshToken.toString()};

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String resposnee = await response.stream.bytesToString();
    Map<String, dynamic> resposne = jsonDecode(resposnee);
    if (response.statusCode == 200) {
      //  debugPrint(refreshToken);

      Provider.of<AuthVM>(context, listen: false)
          .setAccessToken('Bearer ${resposne['data']['response']}');
      debugPrint(
          'access provider ${Provider.of<AuthVM>(context, listen: false).accessToken}');

      debugPrint('successss');
      // print(resposne);
    } else if (response.statusCode == 401) {
      // debugPrint(refreshToken);

      logOut(context);
      debugPrint('error');
      debugPrint(response.statusCode.toString());
      // print(response.reasonPhrase);
    } else {
      debugPrint('error');
      debugPrint(response.statusCode.toString());
    }
  }

  static Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const storage = FlutterSecureStorage();

    String refreshToken = await storage.read(key: 'refresh_token').toString();
    String accessToken =
    Provider.of<AuthVM>(context, listen: false).accessToken.toString();
    var device_token = prefs.getString('device_token').toString();
    var type = prefs.getString('type').toString();
    var headers = {'type': type, 'Authorization': accessToken};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiUrl.baseURL}/auth/logout'));
    request.headers.addAll(headers);
    request.fields.addAll({'device_token': device_token});

    http.StreamedResponse response = await request.send();
    var responsee = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LogInPage()),
              (Route<dynamic> route) => false);
      debugPrint(responsee);
      await prefs.clear();
      await storage.deleteAll();

      PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
      pusher.disconnect();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LogInPage()),
              (Route<dynamic> route) => false);
      debugPrint('${responsee} from logout');
      await prefs.clear();
      await storage.deleteAll();
      PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
      pusher.disconnect();
    }
  }
}