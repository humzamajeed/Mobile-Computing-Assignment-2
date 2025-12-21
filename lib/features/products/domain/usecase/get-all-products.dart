import '../repository/products_repository.dart';
import '../entities/product.dart';

class GetAllProducts {
  final ProductsRepository repository;
  GetAllProducts(this.repository);

  Future<List<Product>> call() async {
    return await repository.getAllProducts();
  }
}
