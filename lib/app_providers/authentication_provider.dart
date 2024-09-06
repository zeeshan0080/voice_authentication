import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_authentication/constants/app_constants.dart';

enum Status { initial, loading, loaded, error }

class AuthenticationProvider with ChangeNotifier {
  final SharedPreferences sf;

  AuthenticationProvider({required this.sf});

  bool get isLoggedIn {
    return sf.getBool(AppKeys.user) == null ? false : true;
  }

  Future<void> login() async {
    await sf.setBool(AppKeys.user, true);
  }

  Future<void> logout() async {
    await sf.clear();
  }


}