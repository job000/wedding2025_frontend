import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Husk å importere AuthProvider hvis du har en slik
import '../../../auth/presentation/providers/auth_provider.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 1) Kjør _initializeGallery etter at første build er ferdig
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      // 2) Sjekk om brukeren er innlogget (isAuthenticated)
      //    Hvis ja, hent galleri; hvis nei, kan du vise en feilmelding eller lignende
      if (authProvider.isAuthenticated) {
        _initializeGallery();
      } else {
        // Hvis ønskelig, håndter scenarioet "ikke innlogget" her
        // For eksempel: Navigator.pushNamed(context, '/login');
      }
    });
  }

  Future<void> _initializeGallery() async {
    if (!mounted) return;
    
    final galleryProvider = context.read<GalleryProvider>();
    if (!galleryProvider.isInitialized && !_isLoading) {
      setState(() => _isLoading = true);
      
      try {
        await galleryProvider.fetchGalleryMedia();
      } catch (e) {
        if (mounted) {
          _showErrorSnackbar('Kunne ikke laste galleriet: $e');
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _loadGallery() async {
    if (!mounted || _isLoading) return;
    
    setState(() => _isLoading = true);
    try {
      await context.read<GalleryProvider>().fetchGalleryMedia();
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Kunne ikke laste galleriet: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CustomColors.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Prøv igjen',
          textColor: Colors.white,
          onPressed: _loadGallery,
        ),
      ),
    );
  }

  Future<void> _showUploadDialog() async {
    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const UploadMediaDialog(),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bildet ble lastet opp!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      await _loadGallery();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              'Ingen bilder i galleriet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: CustomColors.neutral600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Del dine minner fra bryllupet!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: CustomColors.neutral500,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showUploadDialog,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Last opp bilde'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
              'Oops! Noe gikk galt',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: CustomColors.error,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: CustomColors.neutral600,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadGallery,
              icon: const Icon(Icons.refresh),
              label: const Text('Prøv igjen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      showAppBar: true,
      title: 'Bildegalleri',
      actions: [
        IconButton(
          icon: const Icon(Icons.add_photo_alternate),
          onPressed: _showUploadDialog,
          tooltip: 'Last opp bilde',
        ),
        const SizedBox(width: 8),
      ],
      child: Consumer<GalleryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading || _isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return _buildErrorState(provider.error!);
          }

          if (provider.mediaList.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _loadGallery,
            child: Stack(
              children: [
                const GalleryGrid(),
                if (!provider.isLoading)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      onPressed: _showUploadDialog,
                      backgroundColor: CustomColors.primary,
                      heroTag: 'uploadFab',
                      child: const Icon(Icons.add_photo_alternate),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
