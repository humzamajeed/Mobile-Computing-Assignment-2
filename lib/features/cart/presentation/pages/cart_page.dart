import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ✅ New imports for theme and scaling utilities
import '../../../../core/constant/colors.dart';
import '../../../../core/extension/size-extension.dart';
import '../provider/cart_provider.dart';

class CartPage extends StatelessWidget {
  static const routeName = "/cart";

  const CartPage({Key? key}) : super(key: key);

  // --- Reusable Quantity Button Style ---
  Widget _qtyButton(
      {required IconData icon, required VoidCallback onPressed, required BuildContext context}) {
    return Container(
      width: context.w(30),
      height: context.h(30),
      decoration: BoxDecoration(
        // Used a light gray for the button background
        color: MyColors.backgroundLightGray,
        borderRadius: BorderRadius.circular(context.w(8)),
        border: Border.all(color: MyColors.borderColor, width: 1), // Using light border color
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(context.w(8)),
        child: Icon(icon, size: context.sp(18), color: MyColors.brandPrimary),
      ),
    );
  }

  // --- Custom Cart Item Tile Widget ---
  Widget _cartItemTile(BuildContext context, CartItem item, CartProvider cart) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(8),
      ),
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: MyColors.textLight, // White card background
        borderRadius: BorderRadius.circular(context.w(20)),
        boxShadow: [
          BoxShadow(
            // Using a dark text color base for the shadow
            color: MyColors.textDark.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: context.w(10),
            offset: Offset(0, context.h(5)),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Image
          ClipRRect(
            borderRadius: BorderRadius.circular(context.w(10)),
            child: Image.network(
              item.product.image,
              width: context.w(70),
              height: context.w(70),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: context.w(40), color: MyColors.textSecondary),
            ),
          ),
          SizedBox(width: context.w(15)),

          // 2. Title and Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: context.sp(15),
                      fontWeight: FontWeight.bold,
                      color: MyColors.textDark), // Primary text color
                ),
                SizedBox(height: context.h(4)),
                Text(
                  "\$${(item.product.price * item.quantity).toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: context.sp(16),
                      // Using brandPrimary as the accent for price
                      color: MyColors.brandPrimary,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),

          // 3. Quantity Controls & Delete
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _qtyButton(
                  icon: Icons.remove,
                  onPressed: () => cart.decreaseQuantity(item.product.id),
                  context: context),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(4)),
                child: Text(
                  item.quantity.toString(),
                  style: TextStyle(
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.bold,
                      color: MyColors.textDark),
                ),
              ),
              _qtyButton(
                  icon: Icons.add,
                  onPressed: () => cart.increaseQuantity(item.product.id),
                  context: context),
              SizedBox(width: context.w(8)),
              IconButton(
                // Using error color for the delete icon
                icon: Icon(Icons.delete_outline,
                    color: MyColors.error, size: context.sp(22)),
                onPressed: () => cart.removeItem(item.product.id),
                tooltip: 'Remove Item',
              )
            ],
          ),
        ],
      ),
    );
  }

  // --- Custom Checkout Confirmation Modal ---
  void _checkoutModal(BuildContext context, CartProvider cart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(context.w(30)),
          decoration: BoxDecoration(
            color: MyColors.textLight,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(context.w(30))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.done_all,
                  size: context.w(80), color: MyColors.brandPrimary),
              SizedBox(height: context.h(20)),
              Text("Order Placed Successfully!",
                  style: TextStyle(
                      fontSize: context.sp(24),
                      color: MyColors.textDark,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: context.h(10)),
              Text(
                "Your items are now being processed. You will receive a confirmation email shortly.",
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: context.sp(16), color: MyColors.textSecondary),
              ),
              SizedBox(height: context.h(30)),
              Container(
                width: double.infinity,
                height: context.h(50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.w(15)),
                  // Using a gradient with brandPrimary color
                  gradient: LinearGradient(
                    colors: [MyColors.brandPrimary, MyColors.brandPrimary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.brandPrimary.withOpacity(0.3),
                      blurRadius: context.w(10),
                      offset: Offset(0, context.h(5)),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    cart.clear();
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(context.w(15)),
                  child: Center(
                    child: Text("Awesome!",
                        style: TextStyle(
                            color: MyColors.textLight, // White text
                            fontSize: context.sp(18),
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      // Using light gray background for contrast
      backgroundColor: MyColors.backgroundDarkWhite,
      appBar: AppBar(
        title: Text("Your Shopping Cart",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: context.sp(18),
                color: MyColors.textLight)), // White text on AppBar
        // Using dark gray for the app bar background
        backgroundColor: MyColors.brandPrimary,
        elevation: 8,
        shadowColor: MyColors.scaffoldBackground.withOpacity(0.4),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      body: cart.items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: context.w(90), color: MyColors.textSecondary.withOpacity(0.5)),
            SizedBox(height: context.h(16)),
            Text("Your cart is looking a little empty!",
                style: TextStyle(
                    fontSize: context.sp(18), color: MyColors.textSecondary))
          ],
        ),
      )
          : Column(
        children: [
          // 1. Cart Items List
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (_, index) =>
                  _cartItemTile(context, cart.items[index], cart),
            ),
          ),

          // 2. Checkout Summary Footer
          Container(
            padding: EdgeInsets.all(context.w(20)),
            decoration: BoxDecoration(
              color: MyColors.textLight,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(context.w(20))),
              boxShadow: [
                BoxShadow(
                  color: MyColors.scaffoldBackground.withOpacity(0.1),
                  blurRadius: context.w(15),
                  offset: Offset(0, context.h(-5)),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Total Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Order Total:",
                        style: TextStyle(
                            fontSize: context.sp(20),
                            fontWeight: FontWeight.bold,
                            color: MyColors.textDark)),
                    Text("\$${cart.totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: context.sp(24),
                            fontWeight: FontWeight.w900,
                            color: MyColors.brandPrimary)),
                  ],
                ),
                SizedBox(height: context.h(20)),
                // Checkout Button
                Container(
                  width: double.infinity,
                  height: context.h(55),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [MyColors.brandPrimary, MyColors.brandPrimary]),
                    borderRadius: BorderRadius.circular(context.w(15)),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.brandPrimary.withOpacity(0.4),
                        blurRadius: context.w(12),
                        offset: Offset(0, context.h(6)),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: cart.items.isEmpty ? null : () => _checkoutModal(context, cart),
                    borderRadius: BorderRadius.circular(context.w(15)),
                    child: Center(
                        child: Text(
                            cart.items.isEmpty ? "Cart is Empty" : "Checkout (\$${cart.totalPrice.toStringAsFixed(2)})",
                            style: TextStyle(
                                fontSize: context.sp(18),
                                color: MyColors.textLight,
                                fontWeight: FontWeight.bold))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}