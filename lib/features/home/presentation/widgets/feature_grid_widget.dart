// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weddingapp_frontend_v2/features/home/presentation/widgets/countdown_row_widget.dart';
import '../../../../core/theme/custom_colors.dart';

class FeatureGrid extends StatelessWidget {
  final Function(int) onFeatureSelected;
  final bool isPublic;

  const FeatureGrid({
    super.key,
    required this.onFeatureSelected,
    this.isPublic = false,
  });

  List<Map<String, dynamic>> _getFeatures(bool isPublic) {
    if (isPublic) {
      return [
        {
          'title': 'RSVP',
          'subtitle': 'Registrer din deltakelse',
          'icon': Icons.check_circle_outline,
          'color': CustomColors.primary,
          'index': 0,
        },
        {
          'title': 'Program',
          'subtitle': 'Se program og praktisk informasjon',
          'icon': Icons.event,
          'color': CustomColors.secondary,
          'index': 1,
        },
        {
          'title': 'Logg inn',
          'subtitle': 'For inviterte gjester',
          'icon': Icons.login,
          'color': CustomColors.tertiary,
          'index': 2,
        },
      ];
    } else {
      return [
        {
          'title': 'RSVP Admin',
          'subtitle': 'Administrer gjestenes deltakelse',
          'icon': Icons.people_alt,
          'color': CustomColors.primary,
          'index': 0,
        },
        {
          'title': 'Bildegalleri',
          'subtitle': 'Del og se bilder fra bryllupet',
          'icon': Icons.photo_library,
          'color': CustomColors.secondary,
          'index': 1,
        },
        {
          'title': 'Informasjon',
          'subtitle': 'Administrer bryllupsinformasjon',
          'icon': Icons.edit_document,
          'color': CustomColors.tertiary,
          'index': 2,
        },
        {
          'title': 'FAQ',
          'subtitle': 'Vanlige spørsmål og svar',
          'icon': Icons.help_outline,
          'color': CustomColors.romantic,
          'index': 3,
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final features = _getFeatures(isPublic);

    return SingleChildScrollView(
      // Gjør hele siden scrollbar
      child: Column(
        children: [
          // Hero-seksjon
          Container(
            height: 600,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/couple_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Subtle gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),

                // Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated heart icon
                      Icon(
                        Icons.favorite,
                        color: CustomColors.burgundy,
                        size: 48,
                      )
                          .animate()
                          .scale(duration: 1.5.seconds)
                          .then(delay: 500.milliseconds)
                          .fade(),
                      const SizedBox(height: 32),

                      // Names
                      Text(
                        'Frida & John Michael',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1.2,
                                ),
                      )
                          .animate()
                          .fadeIn()
                          .slideY(begin: 0.3, end: 0),
                      const SizedBox(height: 16),

                      // Date and location
                      Text(
                        '28. juni 2025 • Bodø',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.5,
                            ),
                      )
                          .animate()
                          .fadeIn()
                          .slideY(begin: 0.3, end: 0),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Countdown section
          Container(
            color: CustomColors.neutral100,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: const CountdownRow(),
          ),

          // Features grid
          Container(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPublic ? 'Velkommen' : 'Ditt Dashboard',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: CustomColors.textPrimary,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.2,
                      ),
                ),
                const SizedBox(height: 32),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // 1) Endret fra 1.5 til 1.2
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    final feature = features[index];
                    return _buildFeatureCard(
                      context,
                      feature['title'] as String,
                      feature['subtitle'] as String,
                      feature['icon'] as IconData,
                      feature['color'] as Color,
                      () => onFeatureSelected(feature['index'] as int),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      color: CustomColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: CustomColors.neutral300),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: color),
              // 2) Fjern Spacer og bruk en liten avstand
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: CustomColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CustomColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn()
        .scale(begin: const Offset(0.95, 0.95));
  }

  // UENDRET KODE VIDERE:

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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
    )
        .animate()
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
    )
        .animate()
        .fadeIn(duration: 800.milliseconds)
        .slideY(begin: 0.3, end: 0);
  }
}
