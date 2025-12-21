import '../entities/product.dart';
import '../repository/products_repository.dart';

class GetProductDetail {
  final ProductsRepository repository;
  GetProductDetail(this.repository);

  Future<Product> call(int id) async {
    return await repository.getProductDetail(id);
  }
}
