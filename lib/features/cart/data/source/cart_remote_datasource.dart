import 'package:dio/dio.dart';

class CartRemoteDataSource {
  final Dio dio;
  CartRemoteDataSource(this.dio);

  /// ✅ GET ALL CARTS
  Future<List<dynamic>> getCart() async {
    final response = await dio.get("https://fakestoreapi.com/carts");
    return response.data;
  }

  /// ✅ ADD NEW CART
  Future<Map<String, dynamic>> addCart(Map<String, dynamic> cartData) async {
    final response = await dio.post(
      "https://fakestoreapi.com/carts",
      data: cartData,
    );

    return response.data;
  }
}
