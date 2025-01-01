import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weddingapp_frontend_v2/shared/widgets/responsive_layout.dart';
import '../providers/auth_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/animated_button.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await context.read<AuthProvider>().login(
            _usernameController.text,
            _passwordController.text,
          );

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          // Bakgrunnsbilde med gradient overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.purple.withOpacity(0.8),
                        Colors.pink.withOpacity(0.8),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          // Login form
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo med fallback
                          Image.asset(
                            'assets/images/logo.png',
                            height: 120,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.favorite,
                                size: 80,
                                color: Colors.white,
                              );
                            },
                          ),
                          const SizedBox(height: 48),
                          // Brukernavn felt
                          CustomTextField(
                            controller: _usernameController,
                            labelText: 'Brukernavn',
                            prefixIcon: Icons.person,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return AppConstants.requiredField;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Passord felt
                          CustomTextField(
                            controller: _passwordController,
                            labelText: 'Passord',
                            prefixIcon: Icons.lock,
                            obscureText: true,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return AppConstants.requiredField;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          // Feilmelding
                          if (authProvider.error != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                authProvider.error!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(height: 24),
                          // Login knapp
                          AnimatedButton(
                            onPressed: _handleLogin,
                            isLoading: authProvider.isLoading,
                            text: 'Logg inn',
                          ),
                          const SizedBox(height: 16),
                          // Registrer link
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Har du ikke konto? Registrer deg',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}