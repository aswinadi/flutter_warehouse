import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'cupertino_glass_container.dart';

/// A Dynamic Island-inspired capsule notification toast matching modern iOS 25 standards.
class CupertinoGlassToast {
  CupertinoGlassToast._();

  /// Show a success capsule at the top of the screen.
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, CupertinoIcons.checkmark_circle_fill, CupertinoColors.activeGreen);
  }

  /// Show an error/warning capsule at the top of the screen.
  static void showError(BuildContext context, String message) {
    _show(context, message, CupertinoIcons.exclamationmark_circle_fill, CupertinoColors.destructiveRed);
  }

  static void _show(BuildContext context, String message, IconData icon, Color iconColor) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 16,
          right: 16,
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: CupertinoGlassContainer(
                borderRadius: 24.0, // High rounded pill shape
                blurSigma: 25.0,
                // Using dark glass for Dynamic Island style contrast across light/dark modes
                backgroundColor: const Color(0xBB121214),
                borderColor: const Color(0x22FFFFFF),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: iconColor, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          fontFamily: '.SF Pro Text', // Native system fallback
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);

    // Dismiss the overlay after 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      overlayEntry.remove();
    });
  }
}
