import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/api/router.dart';
import 'core/providers/theme_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Resolve system brightness
    final systemBrightness = MediaQuery.platformBrightnessOf(context);
    final isDark = themeMode == ThemeModeState.dark ||
        (themeMode == ThemeModeState.system && systemBrightness == Brightness.dark);
    final brightness = isDark ? Brightness.dark : Brightness.light;

    return CupertinoApp.router(
      title: 'Warehouse App',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('id'), // Default to Indonesian
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      theme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: CupertinoColors.activeBlue,
        primaryContrastingColor: CupertinoColors.white,
        barBackgroundColor: isDark
            ? const Color(0xFF1C1C1E)
            : CupertinoColors.systemBackground,
        scaffoldBackgroundColor: isDark
            ? const Color(0xFF000000)
            : CupertinoColors.systemGroupedBackground,
        textTheme: CupertinoTextThemeData(
          primaryColor: isDark
              ? CupertinoColors.white
              : CupertinoColors.label,
          textStyle: TextStyle(
            color: isDark
                ? CupertinoColors.white
                : CupertinoColors.label,
          ),
        ),
      ),
    );
  }
}
