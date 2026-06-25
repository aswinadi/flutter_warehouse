import 'package:flutter/cupertino.dart';
import 'cupertino_glass_container.dart';

class CupertinoGlassLoadingIndicator extends StatelessWidget {
  final String? message;

  const CupertinoGlassLoadingIndicator({
    super.key,
    this.message,
  });

  static void show(BuildContext context, {String? message}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoGlassLoadingIndicator(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoGlassContainer(
        width: 110.0,
        height: 110.0,
        borderRadius: 16.0, // {radius.lg} = 16.0
        blurSigma: 20.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CupertinoActivityIndicator(
              radius: 14.0,
            ),
            if (message != null) ...[
              const SizedBox(height: 12.0),
              Text(
                message!,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: CupertinoColors.secondaryLabel,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
