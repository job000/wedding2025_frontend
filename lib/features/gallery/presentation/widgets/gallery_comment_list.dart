import 'package:flutter/material.dart';
import '../../data/models/gallery_comment_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class GalleryCommentList extends StatelessWidget {
  final List<GalleryCommentModel> comments;

  const GalleryCommentList({
    super.key,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              comment.username[0].toUpperCase(),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          title: Text(comment.comment),
          subtitle: Text(
            '${comment.username} • ${timeago.format(comment.createdAt, locale: 'no')}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }
}