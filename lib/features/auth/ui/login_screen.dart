import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../../core/api/token_provider.dart';
import '../../../core/config/app_config.dart';

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

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'MAXMAR WAREHOUSE',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                CupertinoTextField(
                  controller: _usernameController,
                  placeholder: 'Username',
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemGroupedBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: CupertinoColors.separator,
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
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _passwordController,
                  placeholder: 'Password',
                  obscureText: _obscurePassword,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemGroupedBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: CupertinoColors.separator,
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    CupertinoSwitch(
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
                      style: TextStyle(
                        color: CupertinoColors.label.resolveFrom(context),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  borderRadius: BorderRadius.circular(10),
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
                if (authState.hasError)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Sesi kadaluarsa, silakan login kembali.',
                      style: TextStyle(color: CupertinoColors.destructiveRed),
                      textAlign: TextAlign.center,
                    ),
                  )
                else if (authState.hasValue)
                  authState.value!.when(
                    authenticated: (user, token) => const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Berhasil masuk!',
                        style: TextStyle(color: CupertinoColors.activeGreen),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    unauthenticated: (message) => message != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              message,
                              style: const TextStyle(color: CupertinoColors.destructiveRed),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const SizedBox.shrink(),
                    initial: () => const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                  ),
                if (AppConfig.isDev) ...[
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemOrange.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: CupertinoColors.systemOrange.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
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
                            const Text(
                              'DEVELOPMENT ENVIRONMENT',
                              style: TextStyle(
                                color: CupertinoColors.systemOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppConfig.baseUrl,
                          style: const TextStyle(
                            color: CupertinoColors.secondaryLabel,
                            fontSize: 11,
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
    );
  }
}
