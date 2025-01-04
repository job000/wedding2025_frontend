import 'package:flutter/material.dart';

class GalleryLikeButton extends StatelessWidget {
  final int likeCount;
  final VoidCallback onLike;
  final bool isLiked;

  const GalleryLikeButton({
    Key? key,
    required this.likeCount,
    required this.onLike,
    this.isLiked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onLike,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 4),
            Text(
              likeCount.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}