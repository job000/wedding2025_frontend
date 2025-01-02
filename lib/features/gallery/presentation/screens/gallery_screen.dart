// lib/features/gallery/presentation/screens/gallery_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../providers/gallery_provider.dart';
import '../widgets/gallery_grid.dart';
import '../widgets/upload_media_dialog.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadGallery();
      }
    });
  }

  Future<void> _loadGallery() async {
    if (!mounted) return;
    try {
      await context.read<GalleryProvider>().fetchGalleryMedia();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kunne ikke laste galleriet: $e'),
            backgroundColor: CustomColors.error,
          ),
        );
      }
    }
  }

  void _showUploadDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => const UploadMediaDialog(),
    ).then((_) {
      if (mounted) {
        _loadGallery(); // Oppdater galleriet etter opplasting
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      showAppBar: true,
      title: 'Bildegalleri',
      actions: [
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: _showUploadDialog,
          tooltip: 'Last opp bilde',
        ),
        const SizedBox(width: 8),
      ],
      child: Consumer<GalleryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: CustomColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! ${provider.error}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: CustomColors.error,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loadGallery,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Prøv igjen'),
                  ),
                ],
              ),
            );
          }

          if (provider.mediaList.isEmpty) {
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
                    'Bli den første til å dele et minne!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: CustomColors.neutral500,
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showUploadDialog,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Last opp bilde'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              const GalleryGrid(),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: _showUploadDialog,
                  backgroundColor: CustomColors.primary,
                  child: const Icon(Icons.add_photo_alternate),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Cleanup hvis nødvendig
    super.dispose();
  }
}