import 'dart:ui';
import 'package:flutter/cupertino.dart';

/// A glassmorphic container that mimics iOS translucent materials ("Liquid Glass").
/// It applies a background blur effect and adaptively adjusts opacity based on
/// dark/light mode for optimal legibility.
class CupertinoGlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blurSigma;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CupertinoGlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.blurSigma = 15.0,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    // Default iOS material background opacities (optimized for legibility)
    final defaultBg = isDark
        ? const Color(0x551C1C1E) // Dark translucent material
        : const Color(0xAAFFFFFF); // Light translucent material

    final defaultBorder = isDark
        ? const Color(0x22FFFFFF)
        : const Color(0x1F000000);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? const Color(0x1A000000) 
                : const Color(0x0A000000),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? defaultBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? defaultBorder,
                width: 0.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
