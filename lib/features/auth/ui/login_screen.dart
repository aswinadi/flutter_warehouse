import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../../core/api/token_provider.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_mesh_background.dart';
import '../../../core/widgets/cupertino_glass_switch.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final storage = ref.read(tokenProvider);
    final savedUsername = await storage.getSavedUsername();
    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        _usernameController.text = savedUsername;
        _rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final inputBg = isDark ? const Color(0x22FFFFFF) : const Color(0x11000000);
    final inputBorderColor = isDark ? const Color(0x22FFFFFF) : const Color(0x1F000000);

    return CupertinoMeshBackground(
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.transparent,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              margin: const EdgeInsets.all(CupertinoSpacing.screenMargin),
              child: CupertinoGlassContainer(
                padding: const EdgeInsets.all(CupertinoSpacing.xxl),
                borderRadius: CupertinoSpacing.cardRadius,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'MAXMAR WAREHOUSE',
                      style: context.title1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.activeBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: CupertinoSpacing.xxxl),
                    CupertinoTextField(
                      controller: _usernameController,
                      placeholder: 'Username',
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
                        border: Border.all(
                          color: inputBorderColor,
                          width: 0.5,
                        ),
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(
                          CupertinoIcons.person,
                          color: CupertinoColors.placeholderText,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.l),
                    CupertinoTextField(
                      controller: _passwordController,
                      placeholder: 'Password',
                      obscureText: _obscurePassword,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
                        border: Border.all(
                          color: inputBorderColor,
                          width: 0.5,
                        ),
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(
                          CupertinoIcons.lock,
                          color: CupertinoColors.placeholderText,
                          size: 20,
                        ),
                      ),
                      suffix: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            _obscurePassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                            color: CupertinoColors.placeholderText,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.l),
                    Row(
                      children: [
                        CupertinoGlassSwitch(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Ingat saya',
                          style: context.subhead.copyWith(
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CupertinoSpacing.xxl),
                    SizedBox(
                      height: CupertinoSpacing.primaryButtonHeight,
                      child: CupertinoButton.filled(
                        padding: EdgeInsets.zero,
                        borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                        onPressed: authState.isLoading
                            ? null
                            : () {
                                final username = _usernameController.text;
                                if (_rememberMe) {
                                  ref.read(tokenProvider).saveUsername(username);
                                } else {
                                  ref.read(tokenProvider).clearSavedUsername();
                                }
                                ref.read(authProvider.notifier).login(
                                      username,
                                      _passwordController.text,
                                    );
                               },
                        child: authState.isLoading
                            ? const CupertinoActivityIndicator(
                                color: CupertinoColors.white,
                              )
                            : const Text(
                                'MASUK',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                      ),
                    ),
                    if (authState.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Sesi kadaluarsa, silakan login kembali.',
                          style: context.footnote.copyWith(color: CupertinoColors.destructiveRed),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else if (authState.hasValue)
                      authState.value!.when(
                        authenticated: (user, token) => Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'Berhasil masuk!',
                            style: context.footnote.copyWith(color: CupertinoColors.activeGreen),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        unauthenticated: (message) => message != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  message,
                                  style: context.footnote.copyWith(color: CupertinoColors.destructiveRed),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : const SizedBox.shrink(),
                        initial: () => const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                      ),
                    if (AppConfig.isDev) ...[
                      const SizedBox(height: CupertinoSpacing.xxxl),
                      CupertinoGlassContainer(
                        padding: const EdgeInsets.symmetric(
                          vertical: CupertinoSpacing.m,
                          horizontal: CupertinoSpacing.l,
                        ),
                        borderRadius: CupertinoSpacing.cardRadius,
                        backgroundColor: CupertinoColors.systemOrange.withValues(alpha: 0.08),
                        borderColor: CupertinoColors.systemOrange.withValues(alpha: 0.3),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.exclamationmark_triangle_fill,
                                  color: CupertinoColors.systemOrange,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'DEVELOPMENT ENVIRONMENT',
                                  style: context.footnote.copyWith(
                                    color: CupertinoColors.systemOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              AppConfig.baseUrl,
                              style: context.caption2.copyWith(
                                color: CupertinoColors.secondaryLabel,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
