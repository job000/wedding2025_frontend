import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../../../core/theme/custom_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPublicScreen extends StatelessWidget {
  const InfoPublicScreen({super.key});

  static const String infoDecorationUrl = 'assets/images/background.jpg';
  
  void _openMap() async {
    const url = 'https://maps.google.com/?q=Bestemorstua+Bodø';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      showAppBar: true,
      backgroundColor: CustomColors.background,
      title: 'Informasjon',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Image.asset(
              infoDecorationUrl,
              width: 250,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),
            
            Text(
              'Velkommen til Vår Spesielle Dag i Bodø!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: CustomColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Vi gleder oss til å feire med dere i vakre Bodø. Her finner du praktisk informasjon om bryllupet.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: CustomColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Lokasjon
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
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
                    'Lokasjon',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bestemorstua i Bodø\n\n'
                    'En historisk perle med utsikt over Bodøs vakre kystlinje. '
                    'Lokalet har både inne- og uteområder som vil bli brukt under feiringen.\n\n'
                    'Parkering er tilgjengelig ved lokalet, og det er god tilgang med offentlig transport.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _openMap,
                    icon: const Icon(Icons.map),
                    label: const Text('Vis i Google Maps'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Mat og Drikke
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
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
                    'Mat og Drikke',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vi serverer en nøye utvalgt vegetarmeny med fokus på lokale råvarer:\n\n'
                    '• Treretters festmiddag med sesongens beste\n'
                    '• Kveldsmat senere på kvelden\n'
                    '• Lokalproduserte drikkevarer er inkludert\n'
                    '• Gjester står fritt til å ta med egen drikke\n\n'
                    'Vi tar hensyn til alle allergier og diettbehov - vennligst meld fra om dette i RSVP-skjemaet.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),

            // Overnatting
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
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
                    'Overnatting',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vi har forhåndsreservert rom på følgende hoteller:\n\n'
                    '• Scandic Havet (bruk bookingkode "FJ2025")\n'
                    '• Thon Hotel Nordlys\n'
                    '• Radisson Blu\n\n'
                    'Alle hotellene ligger i gangavstand til Bestemorstua. Vi anbefaler å bestille rom i god tid da det er høysesong i Bodø på denne tiden.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),

            // Transport
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
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
                    'Transport',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For tilreisende:\n\n'
                    '• Bodø Lufthavn er 15 minutter fra sentrum\n'
                    '• Tog ankommer Bodø stasjon i sentrum\n'
                    '• Hurtigruten har daglige anløp\n\n'
                    'Vi kan hjelpe med å organisere felles transport fra flyplassen/stasjonen ved behov. Gi beskjed om dette i RSVP-skjemaet.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),

            // Praktiske Opplysninger
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
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
                    'Praktiske Opplysninger',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Kleskode: Sommerlig pent\n'
                    '• Ta gjerne med komfortable sko til utendørsaktiviteter\n'
                    '• Husk badetøy til fredagsaktivitetene\n'
                    '• Det blir fotografering utendørs\n'
                    '• Vi ønsker ikke bruk av konfetti eller riskasting\n\n'
                    'For spørsmål eller spesielle behov, ikke nøl med å ta kontakt.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),

            // Kontaktinformasjon
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 40),
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
                    'Kontakt',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For spørsmål om:\n\n'
                    '• Generelle henvendelser: kontakt@fridaogjohnmichael.no\n'
                    '• Taler og underholdning: toastmaster@fridaogjohnmichael.no\n'
                    '• Transport og logistikk: logistikk@fridaogjohnmichael.no\n\n'
                    'Vi svarer så fort vi kan på alle henvendelser.',
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
    );
  }
}