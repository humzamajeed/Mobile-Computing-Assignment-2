import '../../domain/entities/product.dart';
import '../../domain/repository/products_repository.dart';
import '../model/product_model.dart';
import '../source/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSourceImpl remoteDataSource;

  ProductsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getAllProducts() async {
    final List<ProductModel> productModels =
    await remoteDataSource.getAllProducts();

    return productModels
        .map(
          (model) => Product(
        id: model.id,
        title: model.title,
        price: model.price,
        description: model.description,
        category: model.category,
        image: model.image,
      ),
    )
        .toList();
  }

  @override
  Future<Product> getProductDetail(int id) async {
    final ProductModel model = await remoteDataSource.getProductDetail(id);

    return Product(
      id: model.id,
      title: model.title,
      price: model.price,
      description: model.description,
      category: model.category,
      image: model.image,
    );
  }
}
