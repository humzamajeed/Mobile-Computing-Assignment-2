import 'package:dio/dio.dart';

class DioClient {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://fakestoreapi.com",
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      headers: {
        "Accept": "application/json",
      },
    ),
  );
}
