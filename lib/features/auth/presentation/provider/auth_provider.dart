import 'package:flutter/material.dart';
import '../../domain/usecase/login_user.dart';
import '../../domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUser loginUser;

  AuthProvider(this.loginUser);

  bool loading = false;
  User? loggedInUser;
  String? errorMessage;

  Future<bool> login(String username, String password) async {
    loading = true;
    notifyListeners();

    try {
      loggedInUser = await loginUser(username, password);

      loading = false;
      notifyListeners();

      return true; // ✅ successfully logged in

    } catch (e) {
      loading = false;
      errorMessage = "Invalid username or password";
      notifyListeners();
      return false;
    }
  }
}
