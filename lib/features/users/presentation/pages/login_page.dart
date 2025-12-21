import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// Assuming MyColors definition is here
import '../../../../core/constant/colors.dart';
// ✅ Scaling utility import
import '../../../../core/extension/size-extension.dart';

import '../provider/auth_provider.dart';
import '../../../products/presentation/pages/products_page.dart';

class CurvedBackgroundPainter extends CustomPainter {
  final Color color;

  CurvedBackgroundPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    // The shape itself is relative to size, so scaling is not needed here
    path.moveTo(0, size.height * 0.45);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.35,
      size.width,
      size.height * 0.55,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LoginPage extends StatefulWidget {
  static const routeName = "/login";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _usernameCtrl = TextEditingController(text: "mor_2314");
  final _passwordCtrl = TextEditingController(text: "83r5^_");

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final String _lottieUrl =
      "https://assets10.lottiefiles.com/packages/lf20_touohxv0.json";

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _slideAnimation = Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  /// ✅ Login Button - Scaled
  Widget _buildLoginButton(AuthProvider auth) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: BoxConstraints(
        // Scaled min width
        minWidth: context.w(auth.isLoading ? 60 : 200),
        // Scaled min height
        minHeight: context.h(50),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.w(30)),
        gradient: const LinearGradient(
          colors: [MyColors.brandPrimary, MyColors.brandAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.brandPrimary.withOpacity(0.4),
            // Scaled blur radius
            blurRadius: context.w(12),
            // Scaled offset
            offset: Offset(0, context.h(6)),
          ),
        ],
      ),
      child: InkWell(
        onTap: auth.isLoading
            ? null
            : () async {
          final success =
          await auth.login(_usernameCtrl.text.trim(), _passwordCtrl.text.trim());

          if (!mounted) return;

          if (success) {
            Navigator.pushReplacementNamed(context, ProductsPage.routeName);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Invalid username or password",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: MyColors.textLight,
                        // Scaled font size
                        fontSize: context.sp(14)
                    )),
                backgroundColor: MyColors.error,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(context.w(30)),
        child: Center(
          child: auth.isLoading
              ? SizedBox(
            // Scaled size for indicator
              width: context.w(24),
              height: context.h(24),
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: context.w(2))
          )
              : Text(
            "Sign In",
            style: TextStyle(
              // Scaled font size
              fontSize: context.sp(18),
              color: MyColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Input Field - Scaled
  Widget _buildInputField(
      {required TextEditingController controller,
        required String label,
        required IconData icon,
        bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.backgroundGray.withOpacity(0.2),
        borderRadius: BorderRadius.circular(context.w(15)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: MyColors.textLight, fontSize: context.sp(16)),
        cursorColor: MyColors.textLight,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70, fontSize: context.sp(14)),
          prefixIcon: Icon(icon, color: MyColors.textMuted, size: context.sp(22)),
          border: InputBorder.none,
          // Scaled padding
          contentPadding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [MyColors.backgroundDarkest, MyColors.brandPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          CustomPaint(
            size: size,
            painter: CurvedBackgroundPainter(MyColors.brandPrimary.withOpacity(0.6)),
          ),

          Center(
            child: SingleChildScrollView(
              // Scaled padding around the card might be helpful here if needed,
              // but SingleChildScrollView handles overflow.
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _glassCard(auth),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Glass Card - Scaled
  Widget _glassCard(AuthProvider auth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.w(25)),
      child: BackdropFilter(
        // Blur value is generally not scaled
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          // Scaled width
          width: context.w(340),
          // Scaled padding
          padding: EdgeInsets.all(context.w(28)),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(context.w(25)),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                "PRODUCT HUB",
                style: TextStyle(
                  // Scaled font size
                  fontSize: context.sp(26),
                  color: MyColors.textLight,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: context.h(12)),

              // Scaled height for Lottie animation
              Lottie.network(_lottieUrl, height: context.h(120)),

              SizedBox(height: context.h(20)),
              _buildInputField(controller: _usernameCtrl, label: "Username", icon: Icons.person_outline),
              SizedBox(height: context.h(16)),
              _buildInputField(controller: _passwordCtrl, label: "Password", icon: Icons.lock_outline, obscure: true),

              SizedBox(height: context.h(35)),
              _buildLoginButton(auth),
            ],
          ),
        ),
      ),
    );
  }
}