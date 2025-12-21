// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../core/extension/size-extension.dart';
import '../provider/auth_provider.dart';
import '../../../products/presentation/pages/products_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/login";

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameCtrl = TextEditingController(text: "mor_2314");
  final TextEditingController _passwordCtrl = TextEditingController(text: "83r5^_");

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final String _lottieUrl =
      'https://lottie.host/80c651e7-8b09-41e9-9069-1229606d15b2/b4b32bBv62.json';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool obscure = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.w(12)),
      height: context.h(55),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(context.w(15)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: Colors.white, fontSize: context.sp(16)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70, fontSize: context.sp(14)),
          prefixIcon: Icon(icon, color: Colors.white70, size: context.sp(22)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _animatedLoginButton(AuthProvider auth) => AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    width: auth.loading ? context.w(65) : context.w(225),
    height: context.h(50),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(context.w(30)),
      gradient: const LinearGradient(
        colors: [Color(0xFF6A1B9A), Color(0xFFC56AFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: InkWell(
      onTap: auth.loading
          ? null
          : () async {
        final success = await auth.login(
          _usernameCtrl.text.trim(),
          _passwordCtrl.text.trim(),
        );

        if (success) {
          Navigator.pushReplacementNamed(context, ProductsPage.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login Failed", style: TextStyle(fontSize: context.sp(14))),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(context.w(30)),
      child: Center(
        child: auth.loading
            ? SizedBox(width: context.w(22), height: context.w(22), child: const CircularProgressIndicator(color: Colors.white))
            : Text("Sign In", style: TextStyle(color: Colors.white, fontSize: context.sp(18), fontWeight: FontWeight.bold)),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.w(24)),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    padding: EdgeInsets.all(context.w(30)),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(context.w(20)),
                    ),
                    child: Column(
                      children: [
                        Text("PRODUCT HUB",
                            style: TextStyle(color: Colors.white, fontSize: context.sp(32), fontWeight: FontWeight.bold)),
                        SizedBox(height: context.h(20)),
                        SizedBox(
                          height: context.h(120),
                          child: Lottie.network(_lottieUrl),
                        ),
                        SizedBox(height: context.h(20)),

                        _buildTextField(controller: _usernameCtrl, label: "Username", icon: Icons.person_outline),
                        SizedBox(height: context.h(20)),
                        _buildTextField(controller: _passwordCtrl, label: "Password", icon: Icons.lock_outline, obscure: true),

                        SizedBox(height: context.h(35)),
                        _animatedLoginButton(auth),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
