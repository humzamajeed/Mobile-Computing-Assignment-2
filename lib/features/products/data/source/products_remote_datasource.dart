import '../../../../core/network/api_service.dart';
import '../model/product_model.dart';

class ProductsRemoteDataSourceImpl {
  final ApiService api;

  ProductsRemoteDataSourceImpl(this.api);

  /// ✅ Get all products
  Future<List<ProductModel>> getAllProducts() async {
    final response = await api.dio.get("https://fakestoreapi.com/products");

    return (response.data as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  /// ✅ Get product detail
  Future<ProductModel> getProductDetail(int id) async {
    final response = await api.dio.get("https://fakestoreapi.com/products/$id");

    return ProductModel.fromJson(response.data);
  }
}
