import '../../domain/repository/cart_repository.dart';
import '../source/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<dynamic>> getCart() async {
    return await remoteDataSource.getCart();
  }
}
