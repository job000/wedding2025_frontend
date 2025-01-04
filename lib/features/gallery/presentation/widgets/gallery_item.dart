import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/constants/api_constants.dart';
import '../../data/models/gallery_media_model.dart';
import '../providers/gallery_provider.dart';
import 'gallery_media_details.dart';

class GalleryItem extends StatelessWidget {
  final GalleryMediaModel media;

  const GalleryItem({
    super.key,
    required this.media,
  });

  String _getFullImageUrl(String filename) {
    if (filename.startsWith('http')) {
      return filename;
    }
    return '${ApiConstants.baseUrl}/uploads/$filename';
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => GalleryMediaDetails(media: media),
    );
  }

  Future<void> _handleLike(BuildContext context) async {
    try {
      await context.read<GalleryProvider>().likeMedia(media.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kunne ikke like bildet: $e')),
        );
      }
    }
  }

  Future<void> _handleComment(BuildContext context) async {
    final textController = TextEditingController();
    
    final comment = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Legg til kommentar'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Skriv din kommentar her...',
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Avbryt'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                Navigator.of(context).pop(textController.text);
              }
            },
            child: const Text('Legg til'),
          ),
        ],
      ),
    );

    if (comment != null && comment.trim().isNotEmpty && context.mounted) {
      try {
        await context.read<GalleryProvider>().addComment(media.id, comment);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kunne ikke legge til kommentar: $e')),
          );
        }
      }
    }
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
        onTap: () => _showImageDialog(context, imageUrl),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
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
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: CustomColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (media.likes > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red[400],
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${media.likes}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (media.commentCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${media.commentCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _handleLike(context),
                        icon: Icon(
                          media.isLikedByCurrentUser ? Icons.favorite : Icons.favorite_border,
                          color: media.isLikedByCurrentUser ? Colors.red[400] : null,
                        ),
                        tooltip: 'Lik bilde',
                      ),
                      IconButton(
                        onPressed: () => _handleComment(context),
                        icon: const Icon(Icons.chat_bubble_outline),
                        tooltip: 'Kommenter',
                      ),
                    ],
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