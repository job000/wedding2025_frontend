import 'dart:async'; // for Future.delayed
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/responsive_layout.dart';
import '../../../../core/theme/custom_colors.dart';
import '../providers/rsvp_provider.dart';

class RsvpPublicScreen extends StatefulWidget {
  const RsvpPublicScreen({super.key});

  @override
  State<RsvpPublicScreen> createState() => _RsvpPublicScreenState();
}

class _RsvpPublicScreenState extends State<RsvpPublicScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _allergiesCtrl = TextEditingController();

  bool _attending = true;
  bool _isSubmitted = false;

  // Pyntebilde for bryllup
  static const String weddingDecorationUrl =
      'https://png.pngtree.com/background/20230401/original/pngtree-wedding-romantic-pink-background-picture-image_2249455.jpg';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _allergiesCtrl.dispose();
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
      // Feilmelding
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Feil ved innsending: ${rsvpProvider.error}'),
            backgroundColor: CustomColors.error,
          ),
        );
      }
    } else {
      // Suksess
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

        // Resett skjema
        _formKey.currentState?.reset();
        _attending = true;

        // Naviger hjem etter 3 sek
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
      backgroundColor: CustomColors.background, // Samme bakgrunn som HomeScreen
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
    return Column(
      key: const ValueKey('thankYouView'),
      children: [
        const SizedBox(height: 24),
        // Pyntebilde øverst
        Image.network(
          weddingDecorationUrl,
          width: 250,
          height: 180,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 24),
        const Icon(
          Icons.favorite_border,
          color: Colors.pink,
          size: 80,
        ),
        const SizedBox(height: 16),
        Text(
          'Takk for din RSVP!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: CustomColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Du blir straks sendt tilbake til startsiden...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CustomColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildForm(BuildContext context, RsvpProvider rsvpProvider) {
    return Column(
      key: const ValueKey('formView'),
      children: [
        const SizedBox(height: 24),

        // Bryllupsdekor øverst
        Image.network(
          weddingDecorationUrl,
          width: 250,
          height: 180,
          fit: BoxFit.cover,
        ),

        const SizedBox(height: 24),
        Text(
          'Velkommen! Fyll inn RSVP-informasjon',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CustomColors.textPrimary,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Gi oss beskjed om du kommer, og eventuelle allergier.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: CustomColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Navn
                TextFormField(
                  controller: _nameCtrl,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: CustomColors.textPrimary,
                      ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.greenAccent,       // <-- GJØR DET LYST
                    labelText: 'Navn',
                    labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vennligst skriv inn navnet ditt.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // E-post
                TextFormField(
                  controller: _emailCtrl,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: CustomColors.textPrimary,
                      ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.greenAccent,       // <-- GJØR DET LYST
                    labelText: 'E-post',
                    labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vennligst skriv inn e-post.';
                    }
                    if (!RegExp(r".+@.+\..+").hasMatch(value.trim())) {
                      return 'Ugyldig e-postadresse.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Kommer / Kommer ikke
                SwitchListTile(
                  title: Text(
                    'Jeg kommer',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                  value: _attending,
                  onChanged: (val) => setState(() => _attending = val),
                    activeColor: Colors.green,     // Bryter-knapp
                    activeTrackColor: Colors.greenAccent,   // Sporet rundt knappen
                ),
                const SizedBox(height: 16),

                // Allergier
                TextFormField(
                  controller: _allergiesCtrl,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: CustomColors.textPrimary,
                      ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.greenAccent,        // <-- GJØR DET LYST
                    labelText: 'Allergier (valgfritt)',
                    labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                    hintText: 'Skriv inn allergier om du har noen...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.neutral400,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 24),

                // Send-knapp
                ElevatedButton(
                  onPressed: rsvpProvider.isLoading ? null : _submitRsvp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: rsvpProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Send inn', style: TextStyle(color: Colors.black54)),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
