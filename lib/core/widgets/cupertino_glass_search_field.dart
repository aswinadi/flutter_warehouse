import 'dart:ui';
import 'package:flutter/cupertino.dart';

class CupertinoGlassSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const CupertinoGlassSearchField({
    super.key,
    required this.controller,
    this.placeholder = 'Cari...',
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    
    final defaultBg = isDark ? const Color(0x331C1C1E) : const Color(0x77FFFFFF);
    final defaultBorder = isDark ? const Color(0x22FFFFFF) : const Color(0x1F000000);

    return ClipRRect(
      borderRadius: BorderRadius.circular(9999.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: CupertinoSearchTextField(
          controller: controller,
          placeholder: placeholder,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          placeholderStyle: TextStyle(
            color: isDark ? const Color(0x99FFFFFF) : const Color(0x993C3C43),
            fontSize: 15.0,
          ),
          style: TextStyle(
            color: isDark ? CupertinoColors.white : CupertinoColors.black,
            fontSize: 15.0,
          ),
          decoration: BoxDecoration(
            color: defaultBg,
            borderRadius: BorderRadius.circular(9999.0),
            border: Border.all(
              color: defaultBorder,
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
