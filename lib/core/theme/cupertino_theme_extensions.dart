import 'package:flutter/cupertino.dart';

extension CupertinoTypography on BuildContext {
  CupertinoThemeData get _theme => CupertinoTheme.of(this);
  CupertinoTextThemeData get _textTheme => _theme.textTheme;

  /// Large Title style (34pt, Bold)
  TextStyle get largeTitle => _textTheme.navLargeTitleTextStyle;

  /// Title 1 style (28pt, Semi-Bold)
  TextStyle get title1 => _textTheme.textStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.34,
      );

  /// Title 2 style (22pt, Medium)
  TextStyle get title2 => _textTheme.textStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.35,
      );

  /// Title 3 style (20pt, Medium)
  TextStyle get title3 => _textTheme.textStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.38,
      );

  /// Headline style (17pt, Semi-Bold)
  TextStyle get headline => _theme.textTheme.navTitleTextStyle;

  /// Body style (17pt, Regular)
  TextStyle get body => _textTheme.textStyle;

  /// Callout style (16pt, Medium)
  TextStyle get callout => _textTheme.textStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.32,
      );

  /// Subhead style (15pt, Regular)
  TextStyle get subhead => _textTheme.textStyle.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.24,
      );

  /// Footnote style (13pt, Regular)
  TextStyle get footnote => _textTheme.textStyle.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.08,
      );

  /// Caption 1 style (12pt, Medium)
  TextStyle get caption1 => _textTheme.textStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
      );

  /// Caption 2 style (11pt, Regular)
  TextStyle get caption2 => _textTheme.textStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.07,
      );
}
