import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await context.read<AuthProvider>().register(
            _usernameController.text,
            _passwordController.text,
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConstants.registerSuccess),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
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
          // Registreringsskjema
          Center(
            child: SingleChildScrollView( // Legger til scroll
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: screenWidth > 600 ? 400 : screenWidth * 0.9, // Responsiv bredde
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
                        AppConstants.logoImage,
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
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return AppConstants.requiredField;
                          }
                          if ((value?.length ?? 0) < 3) {
                            return 'Brukernavnet må være minst 3 tegn';
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
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.next,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return AppConstants.requiredField;
                          }
                          if ((value?.length ?? 0) < 6) {
                            return 'Passordet må være minst 6 tegn';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Bekreft passord felt
                      CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: 'Bekreft passord',
                        prefixIcon: Icons.lock,
                        obscureText: !_isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return AppConstants.requiredField;
                          }
                          if (value != _passwordController.text) {
                            return 'Passordene må være like';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Feilmelding
                      if (context.watch<AuthProvider>().error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            context.read<AuthProvider>().error!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      // Registrer knapp
                      AnimatedButton(
                        onPressed: _handleRegister,
                        isLoading: context.watch<AuthProvider>().isLoading,
                        text: 'Registrer',
                        backgroundColor: Colors.blueAccent,
                      ),
                      const SizedBox(height: 16),
                      // Lenke til innlogging
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          'Har du allerede en konto? Logg inn',
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
