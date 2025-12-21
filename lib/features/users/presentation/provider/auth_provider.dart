import 'package:flutter/material.dart';
import '../../domain/usecase/login_user.dart';
import '../../domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUser loginUser;
  AuthProvider(this.loginUser);

  bool isLoading = false;
  User? loggedInUser;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      loggedInUser = await loginUser(username, password);
      print("✅ LOGGED IN USER TOKEN: ${loggedInUser?.token}");

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("❌ LOGIN FAILED: $e");

      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
