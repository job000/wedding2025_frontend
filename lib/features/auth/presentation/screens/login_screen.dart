import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            _usernameController.text.trim(),
            _passwordController.text.trim(),
          );

      if (mounted) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  context.read<AuthProvider>().error ?? 'Innlogging feilet.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Bakgrunnsgradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF101317), // Mørk grå
                    Color(0xFF1A1F26), // Nesten svart
                  ],
                ),
              ),
            ),
          ),
          // Login form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: screenWidth > 600 ? 400 : screenWidth * 0.9, // Dynamisk bredde
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.favorite,
                            size: 80,
                            color: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(height: 32),
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
                      // Login knapp
                      AnimatedButton(
                        onPressed: _handleLogin,
                        isLoading: context.watch<AuthProvider>().isLoading,
                        text: 'Logg inn',
                        backgroundColor: Colors.blueAccent,
                      ),
                      const SizedBox(height: 16),
                      // Registrer lenke
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
          ),
        ],
      ),
    );
  }
}
