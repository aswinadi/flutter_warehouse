import 'package:flutter/cupertino.dart';

/// A widget that provides an organic, multi-stop gradient background ("Mesh Gradient").
/// It dynamically adapts to light and dark modes, creating a colorful canvas
/// under translucent glass containers.
class CupertinoMeshBackground extends StatelessWidget {
  final Widget child;

  const CupertinoMeshBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    // Define mesh gradient colors based on DESIGNS.md
    final mesh1 = isDark ? const Color(0xFF0B1528) : const Color(0xFFE8F0FE);
    final mesh2 = isDark ? const Color(0xFF1A0B2E) : const Color(0xFFF3E8FF);
    final mesh3 = isDark ? const Color(0xFF2A0815) : const Color(0xFFFFF1F2);

    return Stack(
      children: [
        // Base mesh gradient background
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D0E12) : const Color(0xFFF8F9FC),
            ),
          ),
        ),
        // Overlay blobs to simulate organic mesh gradients
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  mesh1,
                  mesh2,
                  mesh3,
                ],
                stops: const [0.1, 0.55, 0.9],
              ),
            ),
          ),
        ),
        // Additional soft radial highlights for depth
        Positioned(
          top: -150,
          left: -150,
          width: 500,
          height: 500,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isDark ? const Color(0xFF162A4E) : const Color(0xFFD2E3FC)).withOpacity(0.35),
                    CupertinoColors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -200,
          right: -100,
          width: 600,
          height: 600,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isDark ? const Color(0xFF3B0B2E) : const Color(0xFFFCE8E6)).withOpacity(0.3),
                    CupertinoColors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        // Content child
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}
