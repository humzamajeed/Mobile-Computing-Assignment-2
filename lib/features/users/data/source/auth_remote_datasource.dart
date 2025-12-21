// ✅ NO CODE ABOVE THIS LINE

import 'package:dio/dio.dart';
import '../model/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<UserModel> login(String username, String password) async {
    final response = await dio.post(
      "auth/login",
      data: {
        "username": username,
        "password": password,
      },
    );

    return UserModel.fromJson(response.data);
  }
}
