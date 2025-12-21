import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import 'product_detail_page.dart';
import '../../domain/entities/product.dart';
import '../../../../core/constant/colors.dart'; // ✅ centralized color palette
import '../../../../core/extension/size-extension.dart'; // ✅ Scaling utility

class ProductsPage extends StatefulWidget {
  static const routeName = '/products';

  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => Provider.of<ProductsProvider>(context, listen: false).fetchProducts(),
    );
  }

  /// ✅ Product Tile - Refactored for Scaling
  Widget _buildProductTile(
      BuildContext context, Product product, bool isAdded, CartProvider cart) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(10)),
      decoration: BoxDecoration(
        color: MyColors.backgroundWhite,
        borderRadius: BorderRadius.circular(context.w(20)),
        boxShadow: [
          BoxShadow(
            color: MyColors.shadow.withOpacity(0.12),
            blurRadius: context.w(10),
            offset: Offset(0, context.h(6)),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetailPage.routeName,
            arguments: product.id,
          );
        },
        borderRadius: BorderRadius.circular(context.w(20)),
        child: Padding(
          padding: EdgeInsets.all(context.w(12.0)),
          child: Row(
            children: [
              /// ✅ Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(context.w(15)),
                child: Image.network(
                  product.image,
                  width: context.w(90),
                  height: context.w(90),
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, loadingProgress) =>
                  loadingProgress == null
                      ? child
                      : SizedBox(
                    width: context.w(90),
                    height: context.w(90),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: context.w(2),
                        valueColor:
                        const AlwaysStoppedAnimation(MyColors.brandAccent),
                      ),
                    ),
                  ),
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.broken_image, size: context.w(40), color: Colors.grey),
                ),
              ),

              SizedBox(width: context.w(16)),

              /// ✅ title & price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: context.sp(16),
                        fontWeight: FontWeight.bold,
                        color: MyColors.textDark,
                      ),
                    ),
                    SizedBox(height: context.h(6)),
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: context.sp(18),
                        fontWeight: FontWeight.w700,
                        color: MyColors.brandAccent,
                      ),
                    ),
                  ],
                ),
              ),

              /// ✅ Add / Check icon
              IconButton(
                icon: Icon(
                  isAdded ? Icons.check_circle_rounded : Icons.add_shopping_cart,
                  size: context.sp(28),
                  color: isAdded ? MyColors.success : MyColors.brandPrimary,
                ),
                onPressed: isAdded
                    ? null
                    : () {
                  cart.addItem(product);
                  // We need setState here to trigger the icon change immediately
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Cart Badge (App Bar) - Refactored for Scaling
  Widget _buildCartBadge() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined, color: MyColors.textLight, size: context.sp(26)),
          onPressed: () => Navigator.pushNamed(context, "/cart"),
        ),
        Positioned(
          right: context.w(6),
          top: context.h(6),
          child: Consumer<CartProvider>(
            builder: (_, cart, __) => cart.items.isEmpty
                ? const SizedBox.shrink()
                : Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(6), vertical: context.h(2)),
              decoration: BoxDecoration(
                color: MyColors.brandAccent,
                borderRadius: BorderRadius.circular(context.w(10)),
                border: Border.all(color: MyColors.textLight, width: context.w(1.5)),
              ),
              child: Text(
                cart.itemCount.toString(),
                style: TextStyle(
                  color: MyColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: context.sp(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: MyColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          "Product Catalog",
          style: TextStyle(
            fontSize: context.sp(20),
            color: MyColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: MyColors.brandPrimary,
        elevation: context.w(6),
        actions: [
          _buildCartBadge(),
          SizedBox(width: context.w(8)), // Added a small spacing for edge
        ],
      ),

      /// ✅ Loading state with theme color and scaled size
      body: productsProvider.isLoading
          ? Center(
        child: CircularProgressIndicator(
          strokeWidth: context.w(4),
          valueColor: const AlwaysStoppedAnimation(MyColors.brandAccent),
        ),
      )
          : ListView.builder(
        itemCount: productsProvider.products.length,
        itemBuilder: (_, index) {
          final product = productsProvider.products[index];
          return _buildProductTile(
            context,
            product,
            cart.isInCart(product.id),
            cart,
          );
        },
      ),
    );
  }
}