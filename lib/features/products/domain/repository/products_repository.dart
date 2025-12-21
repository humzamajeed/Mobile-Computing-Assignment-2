import '../entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getAllProducts();
  Future<Product> getProductDetail(int id);
}
