import 'package:flutter/cupertino.dart';

class CupertinoGlassSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CupertinoGlassSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: CupertinoColors.activeGreen.withOpacity(0.85),
      trackColor: isDark 
          ? const Color(0x33FFFFFF) // Thin glass dark
          : const Color(0x22000000), // Thin glass light
      thumbColor: CupertinoColors.white,
    );
  }
}
