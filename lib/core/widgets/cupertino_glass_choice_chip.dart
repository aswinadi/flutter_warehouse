import 'dart:ui';
import 'package:flutter/cupertino.dart';

class CupertinoGlassChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const CupertinoGlassChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    // Define glass color tokens from DESIGNS.md
    final bgInactive = isDark 
        ? const Color(0x22FFFFFF) // White 13% opacity
        : const Color(0x11000000); // Black 6% opacity
    
    final bgActive = CupertinoTheme.of(context).primaryColor.withOpacity(0.85);

    final borderInactive = isDark ? const Color(0x1FFFFFFF) : const Color(0x0F000000);
    final borderActive = CupertinoTheme.of(context).primaryColor.withOpacity(0.3);

    final textColor = isSelected
        ? CupertinoColors.white
        : (isDark ? CupertinoColors.lightBackgroundGray : CupertinoColors.darkBackgroundGray);

    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9999.0), // {radius.full}
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: isSelected ? bgActive : bgInactive,
              borderRadius: BorderRadius.circular(9999.0),
              border: Border.all(
                color: isSelected ? borderActive : borderInactive,
                width: 0.5,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13.0, // {typography.footnote}
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
