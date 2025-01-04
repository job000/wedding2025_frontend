import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/responsive_layout.dart';
import '../../../../core/theme/custom_colors.dart';
import '../providers/rsvp_provider.dart';

class FloatingHeart extends StatefulWidget {
  const FloatingHeart({super.key});

  @override
  State<FloatingHeart> createState() => _FloatingHeartState();
}

class _FloatingHeartState extends State<FloatingHeart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _positionAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            20 * math.cos(_positionAnimation.value),
            10 * math.sin(_positionAnimation.value),
          ),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: const Icon(
              Icons.favorite,
              color: Colors.pink,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}

class RsvpPublicScreen extends StatefulWidget {
  const RsvpPublicScreen({super.key});

  @override
  State<RsvpPublicScreen> createState() => _RsvpPublicScreenState();
}

class _RsvpPublicScreenState extends State<RsvpPublicScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _allergiesCtrl = TextEditingController();

  bool _attending = true;
  bool _isSubmitted = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const String weddingDecorationUrl =
      'https://png.pngtree.com/background/20230401/original/pngtree-wedding-romantic-pink-background-picture-image_2249455.jpg';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _allergiesCtrl.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _submitRsvp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final rsvpProvider = context.read<RsvpProvider>();
    await rsvpProvider.createRsvp(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      attending: _attending,
      allergies: _allergiesCtrl.text.trim(),
    );

    if (rsvpProvider.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Feil ved innsending: ${rsvpProvider.error}'),
            backgroundColor: CustomColors.error,
          ),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          _isSubmitted = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('RSVP sendt inn! Takk skal du ha.'),
            backgroundColor: Colors.green,
          ),
        );

        _formKey.currentState?.reset();
        _attending = true;

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rsvpProvider = context.watch<RsvpProvider>();

    return AppLayout(
      showAppBar: true,
      backgroundColor: CustomColors.background,
      title: 'RSVP',
      child: SingleChildScrollView(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSubmitted
              ? _buildThankYouView(context)
              : _buildForm(context, rsvpProvider),
        ),
      ),
    );
  }

  Widget _buildThankYouView(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        key: const ValueKey('thankYouView'),
        children: [
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                weddingDecorationUrl,
                width: 250,
                height: 180,
                fit: BoxFit.cover,
              ),
              const Positioned(
                top: 20,
                left: 20,
                child: FloatingHeart(),
              ),
              const Positioned(
                bottom: 20,
                right: 20,
                child: FloatingHeart(),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Icon(
            Icons.favorite,
            color: Colors.pink,
            size: 80,
          ),
          const SizedBox(height: 24),
          Text(
            'Tusen takk for din RSVP!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: CustomColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Du blir nå sendt tilbake til startsiden...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: CustomColors.textSecondary,
                  letterSpacing: 0.2,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, RsvpProvider rsvpProvider) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.3),
        width: 1.5,
      ),
    );

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        key: const ValueKey('formView'),
        children: [
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                weddingDecorationUrl,
                width: 250,
                height: 180,
                fit: BoxFit.cover,
              ),
              const Positioned(
                top: 20,
                left: 20,
                child: FloatingHeart(),
              ),
              const Positioned(
                bottom: 20,
                right: 20,
                child: FloatingHeart(),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Velkommen til vårt bryllup',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: CustomColors.textPrimary,
                  letterSpacing: -0.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Vennligst bekreft din deltakelse og eventuelle allergier.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: CustomColors.textSecondary,
                  letterSpacing: 0.2,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: CustomColors.textPrimary,
                          letterSpacing: 0.2,
                        ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.greenAccent.withOpacity(0.1),
                      labelText: 'Fullt navn',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Skriv inn ditt fulle navn',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder.copyWith(
                        borderSide: BorderSide(
                          color: Colors.green.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vennligst skriv inn navnet ditt';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _emailCtrl,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: CustomColors.textPrimary,
                          letterSpacing: 0.2,
                        ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.greenAccent.withOpacity(0.1),
                      labelText: 'E-postadresse',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Skriv inn din e-postadresse',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder.copyWith(
                        borderSide: BorderSide(
                          color: Colors.green.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vennligst skriv inn din e-postadresse';
                      }
                      if (!RegExp(r".+@.+\..+").hasMatch(value.trim())) {
                        return 'Vennligst skriv inn en gyldig e-postadresse';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: SwitchListTile(
                      title: const Text(
                        'Jeg kommer',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                      value: _attending,
                      onChanged: (val) => setState(() => _attending = val),
                      activeColor: Colors.green,
                      activeTrackColor: Colors.greenAccent.withOpacity(0.5),
                      inactiveTrackColor: Colors.grey.withOpacity(0.3),
                      inactiveThumbColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _allergiesCtrl,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: CustomColors.textPrimary,
                          letterSpacing: 0.2,
                        ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.greenAccent.withOpacity(0.1),
                      labelText: 'Allergier',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Skriv inn eventuelle allergier eller matrestriksjoner...',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder.copyWith(
                        borderSide: BorderSide(
                          color: Colors.green.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: rsvpProvider.isLoading ? null : _submitRsvp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: rsvpProvider.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Send RSVP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}