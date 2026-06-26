import 'dart:ui';
import 'package:flutter/cupertino.dart';

class CupertinoGlassBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const CupertinoGlassBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  static void show(BuildContext context, {required String title, required Widget child}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoGlassBottomSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? const Color(0x991C1C1E) : const Color(0xEEFFFFFF);

    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0), // {radius.xl} = 24.0
          topRight: Radius.circular(24.0),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 16.0,
              top: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            decoration: BoxDecoration(
              color: defaultBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              border: Border.all(
                color: isDark ? const Color(0x22FFFFFF) : const Color(0x1F000000),
                width: 0.5,
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0x44FFFFFF) : const Color(0x22000000),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Flexible(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
