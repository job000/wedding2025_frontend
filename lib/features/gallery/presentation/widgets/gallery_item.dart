import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/constants/api_constants.dart';
import '../../data/models/gallery_media_model.dart';

class GalleryItem extends StatelessWidget {
  final GalleryMediaModel media;

  const GalleryItem({
    Key? key,
    required this.media,
  }) : super(key: key);

  String _getFullImageUrl(String filename) {
    // Check if the filename is already a full URL
    if (filename.startsWith('http')) {
      return filename;
    }
    // If not, construct the full URL
    return '${ApiConstants.baseUrl}/uploads/$filename';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getFullImageUrl(media.filename);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showImageDialog(context, media, imageUrl),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: CustomColors.neutral200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    print('Error loading image: $url - $error');
                    return Container(
                      color: CustomColors.neutral200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 32,
                            color: CustomColors.error,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Kunne ikke laste bildet',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: CustomColors.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.uploadedBy,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    media.formattedUploadTime,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CustomColors.neutral600,
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

  void _showImageDialog(
      BuildContext context, GalleryMediaModel media, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text(
                  media.uploadedBy,
                  style: const TextStyle(fontSize: 16),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Center(
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
                            'Kunne ikke laste bildet',
                            style: TextStyle(color: CustomColors.error),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
