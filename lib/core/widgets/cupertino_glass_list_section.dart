import 'package:flutter/cupertino.dart';
import 'cupertino_glass_container.dart';

class CupertinoGlassListSection extends StatelessWidget {
  final String? header;
  final List<Widget> children;

  const CupertinoGlassListSection({
    super.key,
    this.header,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? const Color(0x1AFFFFFF) : const Color(0x0A000000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              header!.toUpperCase(),
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ),
        CupertinoGlassContainer(
          padding: EdgeInsets.zero,
          borderRadius: 16.0,
          child: Column(
            children: List.generate(children.length, (index) {
              return Column(
                children: [
                  children[index],
                  if (index < children.length - 1)
                    Container(
                      height: 0.5,
                      margin: const EdgeInsets.only(left: 54.0), // Align with list tile icon offset
                      color: dividerColor,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
