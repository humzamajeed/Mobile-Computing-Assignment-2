import 'package:flutter/material.dart';

extension SizeExtention on BuildContext{

  /// 📏 Set these to your Figma artboard size
  static const double figmaWidth = 375;  // Example: iPhone 12 width
  static const double figmaHeight = 812; // Example: iPhone 12 height

  /// 🔹 Get screen width & height
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  /// 🔹 Scale width and height relative to Figma design
  double w(double value) => (value / figmaWidth) * screenWidth;
  double h(double value) => (value / figmaHeight) * screenHeight;

  /// 🔹 Scale text size
  double sp(double value) => (value / figmaWidth) * screenWidth;


}