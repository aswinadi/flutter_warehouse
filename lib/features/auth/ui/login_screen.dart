import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../../core/api/token_provider.dart';

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

    return Scaffold(
      body: Center(
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text('Ingat saya'),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('MASUK'),
                ),
                if (authState.hasValue)
                  authState.value!.when(
                    authenticated: (user, token) => const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Berhasil masuk!',
                        style: TextStyle(color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    unauthenticated: (message) => message != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              message,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const SizedBox.shrink(),
                    initial: () => const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
