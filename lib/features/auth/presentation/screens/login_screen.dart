import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/custom_colors.dart';
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
                context.read<AuthProvider>().error ?? 'Innlogging feilet.',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: CustomColors.error.withOpacity(0.9),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
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
            top: -screenHeight * 0.2,
            right: -screenWidth * 0.2,
            child: Container(
              width: screenWidth * 0.8,
              height: screenWidth * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.primary.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -screenHeight * 0.15,
            left: -screenWidth * 0.15,
            child: Container(
              width: screenWidth * 0.6,
              height: screenWidth * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.secondary.withOpacity(0.05),
              ),
            ),
          ),
          // Login Form
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
                                Icons.favorite,
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
                                    'Velkommen tilbake',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: CustomColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Logg inn for å fortsette',
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
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password field
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Passord',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleLogin(),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return AppConstants.requiredField;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      // Login button
                      AnimatedButton(
                        onPressed: _handleLogin,
                        isLoading: context.watch<AuthProvider>().isLoading,
                        text: 'Logg inn',
                        backgroundColor: CustomColors.primary,
                      ),
                      const SizedBox(height: 24),
                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Har du ikke konto? ',
                            style: TextStyle(
                              color: CustomColors.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/register'),
                            style: TextButton.styleFrom(
                              foregroundColor: CustomColors.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                            child: const Text(
                              'Registrer deg',
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