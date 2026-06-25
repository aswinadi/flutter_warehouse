import 'package:flutter/cupertino.dart';

class CupertinoGlassCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CupertinoGlassCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    final bgInactive = isDark ? const Color(0x22FFFFFF) : const Color(0x11000000);
    final borderInactive = isDark ? const Color(0x33FFFFFF) : const Color(0x22000000);
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 22.0,
        height: 22.0,
        decoration: BoxDecoration(
          color: value ? primaryColor : bgInactive,
          borderRadius: BorderRadius.circular(8.0), // Squircle {radius.sm} = 8.0
          border: Border.all(
            color: value ? primaryColor : borderInactive,
            width: 0.8,
          ),
        ),
        child: value
            ? const Icon(
                CupertinoIcons.checkmark,
                size: 14.0,
                color: CupertinoColors.white,
              )
            : null,
      ),
    );
  }
}
