// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../../../core/theme/custom_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgramPublicScreen extends StatelessWidget {
  const ProgramPublicScreen({super.key});

  static const String programDecorationUrl = 'assets/images/background.jpg';

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      showAppBar: true,
      backgroundColor: CustomColors.background,
      title: 'Program',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Image.asset(
              programDecorationUrl,
              width: 250,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),
            
            Text(
              'Bryllupsprogram',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: CustomColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Fredag 27. juni
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fredag 27. juni',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Velkomstaktiviteter:\n\n'
                    '14:00 - 17:00  Bading og badstu ved Moloen\n'
                    '17:30 - 18:30  Guidet byvandring i Bodøs historiske sentrum\n'
                    '19:00 - 21:00  Felles middag på Restaurant Bjørk (valgfritt)\n'
                    '22:00 - 23:00  Kveldstur til Turisthytta for midnattssol\n\n'
                    'Påmelding til aktivitetene er ønskelig for planlegging.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lørdag 28. juni
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lørdag 28. juni - Bryllupsdagen',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dagens program:\n\n'
                    '13:45 - Gjester ankommer Bestemorstua\n'
                    '14:00 - Vielse\n'
                    '14:45 - Fotografering og mingling\n'
                    '15:00 - Festmiddag med taler\n'
                    '17:00 - Kaffe og kake\n'
                    '18:00 - Uteleker og aktiviteter (væravhengig)\n'
                    '20:00 - Dans og festligheter\n'
                    '22:00 - Kveldsmat serveres\n'
                    '23:00 - Midnattssol-fotografering\n'
                    '02:00 - Festen avsluttes\n\n'
                    'Det blir løpende underholdning og taler under middagen.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Praktisk informasjon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Praktisk Informasjon',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Ønsker du å holde tale? Kontakt toastmaster i god tid\n'
                    '• Ta med komfortable sko til utendørsaktivitetene\n'
                    '• Parkering er tilgjengelig ved lokalet\n'
                    '• Transport kan organiseres ved behov\n\n'
                    'For spørsmål om programmet, kontakt brudeparet.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}