import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../../cart/presentation/provider/cart_provider.dart';
import '../../domain/entities/product.dart';
import '../provider/products_provider.dart';
// ✅ Import the centralized colors and size extension
import '../../../../core/constant/colors.dart';
import '../../../../core/extension/size-extension.dart';

class ProductDetailPage extends StatefulWidget {
  static const routeName = '/product-detail';

  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely retrieve the product ID and fetch the product
    final id = ModalRoute.of(context)?.settings.arguments as int?;
    if (id != null) {
      final provider = Provider.of<ProductsProvider>(context, listen: false);
      product = provider.getProductById(id);
    }
  }

  /// ✅ Add To Cart Button — Uses theme text + MyColors gradient + Scaling
  Widget _buildAddToCartButton(CartProvider cart) {
    if (product == null) return const SizedBox.shrink();

    final bool isAdded = cart.isInCart(product!.id);
    final String buttonText = isAdded ? 'Added to Cart' : 'Add to Cart';

    return Container(
      height: context.h(50),
      width: double.infinity,
      margin: EdgeInsets.only(top: context.h(20)),
      child: isAdded
          ? ElevatedButton.icon(
        onPressed: null,
        icon: Icon(Icons.check_circle_rounded, color: MyColors.backgroundMuted, size: context.sp(24)),
        label: Text(
          buttonText,
          style: TextStyle(
            fontSize: context.sp(16),
            color: MyColors.backgroundMuted,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.backgroundGray, // Muted background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.w(15)),
          ),
          elevation: 0,
        ),
      )
          : InkWell(
        onTap: () => cart.addItem(product!),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.w(15)),
            gradient: const LinearGradient(
              // Using brandPrimary for the CTA
              colors: [MyColors.brandPrimary, MyColors.brandPrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: MyColors.brandPrimary.withOpacity(0.3),
                blurRadius: context.w(10),
                offset: Offset(0, context.h(5)),
              ),
            ],
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: MyColors.textLight, // White text
                fontWeight: FontWeight.bold,
                fontSize: context.sp(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Cart Badge updated to MyColors and Scaling
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
                color: MyColors.brandAccent, // Red accent color for notification
                borderRadius: BorderRadius.circular(context.w(10)),
                border: Border.all(color: MyColors.textLight, width: context.w(1.5)),
              ),
              child: Text(
                cart.itemCount.toString(), // Use itemCount for total items
                style: TextStyle(
                  color: MyColors.textLight, // White text
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
    final cart = Provider.of<CartProvider>(context);

    if (product == null) {
      return Scaffold(
        // Used black background for loading screen
        backgroundColor: MyColors.scaffoldBackground,
        appBar: AppBar(
          title: Text("Loading...", style: TextStyle(color: MyColors.textLight, fontSize: context.sp(18))),
          backgroundColor: MyColors.backgroundGray,
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(MyColors.brandAccent),
          ),
        ),
      );
    }

    return Scaffold(
      // Using light beige background for product details
      backgroundColor: MyColors.backgroundWhite,
      appBar: AppBar(
        title: Text(
          product!.title,
          style: TextStyle(
            color: MyColors.textLight,
            fontWeight: FontWeight.bold,
            fontSize: context.sp(18),
          ),
        ),
        backgroundColor: MyColors.brandPrimary, // Coffee brown App Bar
        elevation: 8,
        shadowColor: MyColors.scaffoldBackground.withOpacity(0.5),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          _buildCartBadge(),
          SizedBox(width: context.w(8)),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ Product Image
            Center(
              child: Container(
                constraints: BoxConstraints(maxHeight: context.h(300), maxWidth: context.w(400)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.w(25)),
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.scaffoldBackground.withOpacity(0.25),
                      blurRadius: context.w(20),
                      offset: Offset(0, context.h(10)),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.w(25)),
                  child: Image.network(
                    product!.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: context.h(300),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(MyColors.brandAccent),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: context.h(30)),

            /// ✅ Title
            Text(
              product!.title,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: MyColors.textDark,
                fontSize: context.sp(22), // Scaled font size
              ),
            ),
            SizedBox(height: context.h(10)),

            /// ✅ Price
            Text(
              '\$${product!.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: MyColors.brandAccent, // Red accent for price
                fontSize: context.sp(28), // Scaled font size
              ),
            ),
            Divider(height: context.h(40), color: MyColors.dividerColor),

            /// ✅ Description Title
            Text(
              "Product Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.textDark,
                fontSize: context.sp(18), // Scaled font size
              ),
            ),
            SizedBox(height: context.h(10)),

            /// ✅ Description Body
            Text(
              product!.description,
              style: TextStyle(
                height: 1.5,
                color: MyColors.textSecondary,
                fontSize: context.sp(14), // Scaled font size
              ),
              textAlign: TextAlign.justify,
            ),

            _buildAddToCartButton(cart),
            SizedBox(height: context.h(25)),
          ],
        ),
      ),
    );
  }
}