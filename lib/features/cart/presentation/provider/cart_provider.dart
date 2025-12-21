import 'package:flutter/material.dart';
import '../../../products/domain/entities/product.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {

  int get itemCount => items.length;

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void increaseQuantity(int productId) {
    final item = _items.firstWhere((i) => i.product.id == productId);
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    final item = _items.firstWhere((i) => i.product.id == productId);
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(int productId) =>
      _items.any((item) => item.product.id == productId);
}
