// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/custom_colors.dart';
import '../providers/gallery_provider.dart';
import 'gallery_item.dart';

class GalleryGrid extends StatelessWidget {
  const GalleryGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryProvider>(
      builder: (context, provider, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Calculate the optimal number of columns based on screen width
            final crossAxisCount = constraints.maxWidth < 600 ? 2 : 
                                 constraints.maxWidth < 1200 ? 3 : 4;
            
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.8,  // Adjust this for desired item height
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
      },
    );
  }
}