import 'package:flutter/cupertino.dart';
import 'cupertino_glass_container.dart';
import '../theme/cupertino_spacing.dart';
import '../theme/cupertino_theme_extensions.dart';

/// A custom glassmorphic alert dialog matching the iOS 25 "Liquid Glass" standard.
class CupertinoGlassDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget> actions;

  const CupertinoGlassDialog({
    super.key,
    this.title,
    this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return Center(
      child: Container(
        width: 270, // Standard iOS alert width
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: CupertinoGlassContainer(
          borderRadius: CupertinoSpacing.dialogRadius,
          blurSigma: 20.0,
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      DefaultTextStyle(
                        style: context.headline.copyWith(
                          fontWeight: FontWeight.w600,
                          color: labelColor,
                        ),
                        textAlign: TextAlign.center,
                        child: title!,
                      ),
                      const SizedBox(height: 6),
                    ],
                    if (content != null)
                      DefaultTextStyle(
                        style: context.footnote.copyWith(
                          color: labelColor,
                        ),
                        textAlign: TextAlign.center,
                        child: content!,
                      ),
                  ],
                ),
              ),
              // Border line separating content from action buttons
              Container(
                height: 0.5,
                color: CupertinoColors.separator.resolveFrom(context),
              ),
              // Horizontal or vertical button layout
              if (actions.length == 2)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: CupertinoSpacing.minTouchTarget,
                        child: actions[0],
                      ),
                    ),
                    Container(
                      width: 0.5,
                      height: CupertinoSpacing.minTouchTarget,
                      color: CupertinoColors.separator.resolveFrom(context),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: CupertinoSpacing.minTouchTarget,
                        child: actions[1],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: List.generate(actions.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: CupertinoSpacing.minTouchTarget,
                          child: actions[index],
                        ),
                        if (index < actions.length - 1)
                          Container(
                            height: 0.5,
                            color: CupertinoColors.separator.resolveFrom(context),
                          ),
                      ],
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A standard dialog action button matching iOS 25 style for CupertinoGlassDialog.
class CupertinoGlassDialogAction extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool isDestructive;
  final bool isDefaultAction;

  const CupertinoGlassDialogAction({
    super.key,
    required this.child,
    required this.onPressed,
    this.isDestructive = false,
    this.isDefaultAction = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    Color textColor = theme.primaryColor;
    if (isDestructive) {
      textColor = CupertinoColors.destructiveRed;
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: 17,
            fontWeight: isDefaultAction ? FontWeight.w600 : FontWeight.w400,
            color: textColor,
          ),
          child: child,
        ),
      ),
    );
  }
}
