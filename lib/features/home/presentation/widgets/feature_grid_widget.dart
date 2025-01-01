import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/custom_colors.dart';


class FeatureGrid extends StatelessWidget {
  final Function(int) onFeatureSelected;

  const FeatureGrid({
    super.key,
    required this.onFeatureSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Velkommen-seksjon med bakgrunnsbilde og overlappende elementer
        Stack(
          children: [
            // Bakgrunnsbilde med gradient overlay
            Container(
              height: 500,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/couple_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
            
            // Animert innhold over bildet
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animert romantisk symbol
                  const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 48,
                  )
                  .animate()
                  .scale(duration: 1.5.seconds, curve: Curves.easeInOut)
                  .then(delay: 500.milliseconds)
                  .fade(duration: 500.milliseconds),

                  const SizedBox(height: 24),

                  // Animert tekst
                  Text(
                    'Frida & John Michael',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                  .animate()
                  .fadeIn(duration: 1.seconds)
                  .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 16),

                  Text(
                    '28. juni 2025 • Bodø',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  )
                  .animate()
                  .fadeIn(delay: 500.milliseconds, duration: 1.seconds)
                  .slideY(begin: 0.3, end: 0),
                ],
              ),
            ),
          ],
        ),

        // Praktisk informasjon med animerte kort
        Container(
          padding: const EdgeInsets.symmetric(vertical: 32),
          color: Colors.black,
          child: Column(
            children: [
              Text(
                'Praktisk Informasjon',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              )
              .animate()
              .fadeIn()
              .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 8),

              Text(
                'Vi gleder oss til å feire vår store dag med dere!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Informasjonskort med hover-effekter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildAnimatedInfoCard(
                      context,
                      'Om Seremonien',
                      'Rådhuset i Bodø kl. 14:00',
                      Icons.church,
                      onTap: () => onFeatureSelected(2),
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedInfoCard(
                      context,
                      'Festlokale',
                      'Middag og fest på bestemors hytte',
                      Icons.celebration,
                      onTap: () => onFeatureSelected(2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Handlingsknapper med pulserende effekt
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                CustomColors.primary.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            children: [
              _buildAnimatedActionButton(
                context,
                'RSVP',
                'Vennligst svar innen 1. mai 2025',
                Icons.check_circle_outline,
                CustomColors.primary,
                onTap: () => onFeatureSelected(0),
              ),
              const SizedBox(height: 16),
              _buildAnimatedActionButton(
                context,
                'Bildegalleri',
                'Del dine øyeblikk fra bryllupet',
                Icons.photo_library,
                CustomColors.secondary,
                onTap: () => onFeatureSelected(1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedInfoCard(
    BuildContext context,
    String title,
    String description,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 32, color: CustomColors.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    ).animate()
    .fadeIn(duration: 600.milliseconds)
    .slideX(begin: 0.3, end: 0);
  }

  Widget _buildAnimatedActionButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.white)
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2.seconds, delay: 2.seconds),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    ).animate()
    .fadeIn(duration: 800.milliseconds)
    .slideY(begin: 0.3, end: 0);
  }
}