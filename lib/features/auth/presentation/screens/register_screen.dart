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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<AuthProvider>(
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
                        Image.asset(
                          AppConstants.logoImage,
                          height: 120,
                        ),
                        const SizedBox(height: 48),
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
                        if (authProvider.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              authProvider.error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        AnimatedButton(
                          onPressed: _handleRegister,
                          isLoading: authProvider.isLoading,
                          text: 'Registrer',
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text('Har du allerede en konto? Logg inn'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}