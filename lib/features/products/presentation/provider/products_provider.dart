import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecase/get-all-products.dart';
import '../../domain/usecase/get-product-detail.dart';

class ProductsProvider extends ChangeNotifier {
  final GetAllProducts getAllProducts;
  final GetProductDetail getProductDetail;

  ProductsProvider({
    required this.getAllProducts,
    required this.getProductDetail,
  });

  /// STATE VARIABLES
  List<Product> products = [];
  Product? selectedProduct;
  bool isLoading = false;
  bool isDetailLoading = false;

  /// ✅ FETCH ALL PRODUCTS
  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();

    products = await getAllProducts.call(); // <--- FIXED

    isLoading = false;
    notifyListeners();
  }

  /// ✅ FETCH PRODUCT DETAIL
  Future<void> fetchProductDetail(int id) async {
    isDetailLoading = true;
    notifyListeners();

    selectedProduct = await getProductDetail.call(id); // <--- FIXED

    isDetailLoading = false;
    notifyListeners();
  }

  /// ✅ Helper to get product locally
  Product getProductById(int id) {
    return products.firstWhere((p) => p.id == id);
  }
}
