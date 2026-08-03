import 'package:flutter/cupertino.dart';

enum DeviceFormFactor { mobile, tablet, desktop }

class AdaptiveLayoutBuilder extends StatelessWidget {
  const AdaptiveLayoutBuilder({
    super.key,
    required this.mobileBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
  });

  final Widget Function(BuildContext context, BoxConstraints constraints) mobileBuilder;
  final Widget Function(BuildContext context, BoxConstraints constraints)? tabletBuilder;
  final Widget Function(BuildContext context, BoxConstraints constraints)? desktopBuilder;

  static DeviceFormFactor getFormFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return DeviceFormFactor.desktop;
    } else if (width >= 600) {
      return DeviceFormFactor.tablet;
    } else {
      return DeviceFormFactor.mobile;
    }
  }

  static bool isMobile(BuildContext context) => getFormFactor(context) == DeviceFormFactor.mobile;
  static bool isTablet(BuildContext context) => getFormFactor(context) == DeviceFormFactor.tablet;
  static bool isDesktop(BuildContext context) => getFormFactor(context) == DeviceFormFactor.desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final formFactor = getFormFactor(context);

        if (formFactor == DeviceFormFactor.desktop && desktopBuilder != null) {
          return desktopBuilder!(context, constraints);
        } else if (formFactor == DeviceFormFactor.tablet && tabletBuilder != null) {
          return tabletBuilder!(context, constraints);
        } else {
          return mobileBuilder(context, constraints);
        }
      },
    );
  }
}
