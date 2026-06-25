import 'package:flutter/cupertino.dart';

class CupertinoGlassRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const CupertinoGlassRadioButton({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    final bgInactive = isDark ? const Color(0x22FFFFFF) : const Color(0x11000000);
    final borderInactive = isDark ? const Color(0x33FFFFFF) : const Color(0x22000000);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22.0,
        height: 22.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? primaryColor.withOpacity(0.2) : bgInactive,
          border: Border.all(
            color: isSelected ? primaryColor : borderInactive,
            width: 1.0,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: CupertinoColors.white,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
