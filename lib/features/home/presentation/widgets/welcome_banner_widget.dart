import 'package:flutter/material.dart';
import '../../../../core/theme/custom_colors.dart';
import 'countdown_row_widget.dart'; // Importer den nye nedtellingswidgeten

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColors.champagne,
            CustomColors.blush,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Nedtelling til den store dagen',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.textDark,
                ),
          ),
          const SizedBox(height: 16),
          const CountdownRow(), // Bruk den nye nedtellingswidgeten her
        ],
      ),
    );
  }
}