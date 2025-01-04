import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../../../core/theme/custom_colors.dart';
import '../providers/faq_provider.dart';
import 'package:provider/provider.dart';

class FAQPublicScreen extends StatelessWidget {
  const FAQPublicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      showAppBar: true,
      backgroundColor: CustomColors.background,
      title: 'Ofte stilte spørsmål',
      child: Consumer<FAQProvider>(
        builder: (context, faqProvider, child) {
          if (faqProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (faqProvider.error != null) {
            return Center(
              child: Text(
                faqProvider.error ?? 'En feil oppstod',
                style: TextStyle(color: CustomColors.error),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  'Vanlige Spørsmål',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: CustomColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Her finner du svar på de vanligste spørsmålene om bryllupet vårt.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: CustomColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: faqProvider.faqs.length,
                  itemBuilder: (context, index) {
                    final faq = faqProvider.faqs[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          faq.question,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: CustomColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              faq.answer,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: CustomColors.textSecondary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}