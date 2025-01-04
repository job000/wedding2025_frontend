import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 1) Importer emoji_picker_flutter
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import '../../data/models/gallery_media_model.dart';
import '../providers/gallery_provider.dart';
import '../../../../core/theme/custom_colors.dart';

class GalleryMediaDetails extends StatefulWidget {
  final GalleryMediaModel media;

  const GalleryMediaDetails({
    Key? key,
    required this.media,
  }) : super(key: key);

  @override
  State<GalleryMediaDetails> createState() => _GalleryMediaDetailsState();
}

class _GalleryMediaDetailsState extends State<GalleryMediaDetails> {
  final _commentController = TextEditingController();
  bool _isSubmittingComment = false;

  // Variabel for å styre om emoji-picker er synlig
  bool _showEmojiPicker = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// Lik handler
  Future<void> _handleLike(int mediaId) async {
    try {
      await context.read<GalleryProvider>().likeMedia(mediaId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kunne ikke like bildet: $e')),
        );
      }
    }
  }

  /// Kommentar handler
  Future<void> _handleComment(int mediaId) async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => _isSubmittingComment = true);
    try {
      await context.read<GalleryProvider>().addComment(
        mediaId,
        _commentController.text.trim(),
      );
      _commentController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kunne ikke legge til kommentar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmittingComment = false);
      }
    }
  }

  /// Legger valgt emoji inn i kommentar-feltet
  void _onEmojiSelected(Emoji emoji) {
    _commentController.text += emoji.emoji;
    // Flytt markøren til slutten
    _commentController.selection = TextSelection.fromPosition(
      TextPosition(offset: _commentController.text.length),
    );
  }

  /// Bygger kommentarliste basert på oppdatert medie-objekt
  Widget _buildCommentList(GalleryMediaModel media) {
    final comments = media.comments;
    if (comments == null || comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text('Ingen kommentarer ennå')),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Kommentarer (${comments.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return ListTile(
                dense: true,
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    comment.user[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(comment.comment),
                subtitle: Text(
                  '${comment.user} • ${comment.formattedTime}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1) Lytt på Provider for å få med oppdateringer
    final galleryProvider = context.watch<GalleryProvider>();

    // 2) Finn oppdatert media fra provider.mediaList
    final updatedMedia = galleryProvider.mediaList.firstWhere(
      (m) => m.id == widget.media.id,
      orElse: () => widget.media, // fallback om ikke funnet
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                updatedMedia.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: CachedNetworkImage(
                imageUrl: updatedMedia.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: CustomColors.error),
                      const SizedBox(height: 8),
                      const Text('Kunne ikke laste bildet'),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Like-rad
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _handleLike(updatedMedia.id),
                        child: Row(
                          children: [
                            Icon(
                              updatedMedia.isLikedByCurrentUser
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: updatedMedia.isLikedByCurrentUser
                                  ? Colors.red
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(updatedMedia.likeCountText),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Lastet opp av ${updatedMedia.uploadedBy}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Kommentarliste
                  _buildCommentList(updatedMedia),
                  const SizedBox(height: 16),

                  // Kommentar-tekstfelt + send-knapp + emoji-knapp
                  Row(
                    children: [
                      // Tekstfelt med suffixIcon for emoji
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Legg til en kommentar...',
                            border: const OutlineInputBorder(),
                            // Suffix-ikon for å vise/skjule emoji-picker
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showEmojiPicker
                                    ? Icons.keyboard
                                    : Icons.emoji_emotions_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showEmojiPicker = !_showEmojiPicker;
                                });
                              },
                            ),
                          ),
                          maxLines: null,
                          onSubmitted: (_) => _handleComment(updatedMedia.id),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _isSubmittingComment
                            ? null
                            : () => _handleComment(updatedMedia.id),
                        icon: _isSubmittingComment
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send),
                      ),
                    ],
                  ),

                  // 3) EmojiPicker (vises kun når _showEmojiPicker == true)
                  if (_showEmojiPicker)
                    SizedBox(
                      height: 250,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          _onEmojiSelected(emoji);
                        },
                        config: Config(
                          emojiViewConfig: EmojiViewConfig(
                            columns: 7,
                            emojiSizeMax: 32.0,
                          ),
                          // Om emojier ikke vises i web, slå av:
                          checkPlatformCompatibility: false,
                        ),
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
