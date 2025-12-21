import '../repository/cart_repository.dart';

class GetCart {
  final CartRepository repository;

  GetCart(this.repository);

  Future<List<dynamic>> call() async {
    return await repository.getCart();
  }
}
