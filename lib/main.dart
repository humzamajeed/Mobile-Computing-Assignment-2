import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_service.dart';

// AUTH
import 'features/users/data/source/auth_remote_datasource.dart';
import 'features/users/data/repositoryImp/auth_repository_impl.dart';
import 'features/users/domain/usecase/login_user.dart';
import 'features/users/presentation/provider/auth_provider.dart';
import 'features/users/presentation/pages/login_page.dart';

// PRODUCTS
import 'features/products/data/source/products_remote_datasource.dart';
import 'features/products/data/repositoryImp/products_repository_impl.dart';
import 'features/products/domain/usecase/get-all-products.dart';
import 'features/products/domain/usecase/get-product-detail.dart';
import 'features/products/presentation/provider/products_provider.dart';
import 'features/products/presentation/pages/products_page.dart';
import 'features/products/presentation/pages/product_detail_page.dart';

// CART
// import 'features/cart/data/source/cart_remote_datasource.dart';
// import 'features/cart/data/repositoryImp/cart_repository_impl.dart';
// import 'features/cart/domain/usecase/get-cart.dart';
import 'features/cart/presentation/provider/cart_provider.dart';
import 'features/cart/presentation/pages/cart_page.dart';

void main() {
  final api = ApiService();        // api.dio is ready

  // AUTH
  final authRemote = AuthRemoteDataSource(api.dio);
  final authRepo = AuthRepositoryImpl(authRemote);
  final loginUserUC = LoginUser(authRepo);


  // PRODUCTS
  final productsRemote = ProductsRemoteDataSourceImpl(api); // ✅ FIXED
  final productsRepo = ProductsRepositoryImpl(productsRemote);
  final getAllProductsUC = GetAllProducts(productsRepo);
  final getProductDetailUC = GetProductDetail(productsRepo);

  // CART
  // final cartRemote = CartRemoteDataSource(api.dio);
  // final cartRepo = CartRepositoryImpl(cartRemote);
  // final getCartUC = GetCart(cartRepo); // Not used yet

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(loginUserUC)),
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(
            getAllProducts: getAllProductsUC,
            getProductDetail: getProductDetailUC,
          ),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        "/login": (_) => LoginPage(),
        "/products": (_) => ProductsPage(),
        "/product-detail": (_) => ProductDetailPage(),
        "/cart": (_) => CartPage(),
      },
    );
  }
}
