import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/custom_colors.dart';
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
          SnackBar(
            content: const Text(
              AppConstants.registerSuccess,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: CustomColors.success.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        // Login after successful registration
        final loginSuccess = await context.read<AuthProvider>().login(
              _usernameController.text,
              _passwordController.text,
            );
        if (loginSuccess && mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: CustomColors.background,
      body: Stack(
        children: [
          // Background Design
          Positioned(
            top: -screenHeight * 0.15,
            left: -screenWidth * 0.15,
            child: Container(
              width: screenWidth * 0.7,
              height: screenWidth * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.primary.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -screenHeight * 0.2,
            right: -screenWidth * 0.2,
            child: Container(
              width: screenWidth * 0.8,
              height: screenWidth * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.secondary.withOpacity(0.05),
              ),
            ),
          ),
          // Registration Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: screenWidth > 600 ? 480 : screenWidth * 0.9,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.primary.withOpacity(0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CustomColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: CustomColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.person_add_outlined,
                                color: CustomColors.primary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Opprett konto',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: CustomColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Registrer deg for å få tilgang',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: CustomColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Username field
                      CustomTextField(
                        controller: _usernameController,
                        labelText: 'Brukernavn',
                        prefixIcon: Icons.person_outline,
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
                      // Password field
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Passord',
                        prefixIcon: Icons.lock_outline,
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.next,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: CustomColors.primary,
                          ),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
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
                      // Confirm Password field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: 'Bekreft passord',
                        prefixIcon: Icons.lock_outline,
                        obscureText: !_isConfirmPasswordVisible,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleRegister(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: CustomColors.primary,
                          ),
                          onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
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
                      const SizedBox(height: 16),
                      // Error message
                      if (context.watch<AuthProvider>().error != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: CustomColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: CustomColors.error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  context.read<AuthProvider>().error!,
                                  style: TextStyle(
                                    color: CustomColors.error,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32),
                      // Register button
                      AnimatedButton(
                        onPressed: _handleRegister,
                        isLoading: context.watch<AuthProvider>().isLoading,
                        text: 'Registrer',
                        backgroundColor: CustomColors.primary,
                      ),
                      const SizedBox(height: 24),
                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Har du allerede en konto? ',
                            style: TextStyle(
                              color: CustomColors.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                            style: TextButton.styleFrom(
                              foregroundColor: CustomColors.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                            child: const Text(
                              'Logg inn',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
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