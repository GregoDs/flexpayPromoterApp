import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var token = "".obs; //observing the token

  Future<void> loginUser(String newToken) async {
    token.value = newToken;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', newToken);

    // I want to confirm the token prescence
    final storedToken = prefs.getString('auth_token');
    log('Stored token in Shared Prefernces is: $storedToken');
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('auth_token') ?? "";

    log('Token loaded: ${token.value}');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('auth_token') ?? "";
    await prefs.remove('auth_token');
    token.value = "";

    log('Token removed: ${token.value}');
  }

  bool get isAuthenticated => token.value.isNotEmpty;
}
