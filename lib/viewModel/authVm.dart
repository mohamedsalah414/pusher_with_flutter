import 'package:flutter/material.dart';

class AuthVM extends ChangeNotifier {
  String? _accessToken;

  String? get accessToken => _accessToken;

  setAccessToken(String access) {
    _accessToken = access;
    notifyListeners();
  }
}