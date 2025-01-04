import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/custom_colors.dart';
import '../providers/gallery_provider.dart';
import 'gallery_item.dart';

class GalleryGrid extends StatelessWidget {
  const GalleryGrid({super.key});

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: CustomColors.neutral400,
          ),
          const SizedBox(height: 16),
          Text(
            'Ingen bilder ennå',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: CustomColors.neutral600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bli den første til å dele minner fra bryllupet!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: CustomColors.neutral500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: CustomColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: CustomColors.error),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Prøv igjen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context, GalleryProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600
            ? 2
            : constraints.maxWidth < 1200
                ? 3
                : 4;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: provider.mediaList.length,
          itemBuilder: (context, index) {
            final media = provider.mediaList[index];
            return GalleryItem(media: media);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.mediaList.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(CustomColors.primary),
            ),
          );
        }

        if (provider.error != null) {
          return _buildErrorState(
            context, 
            provider.error!,
            () => provider.fetchGalleryMedia(forceRefresh: true),
          );
        }

        if (provider.mediaList.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchGalleryMedia(forceRefresh: true),
          child: _buildGridView(context, provider),
        );
      },
    );
  }
}