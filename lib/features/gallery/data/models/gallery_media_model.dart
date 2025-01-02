// lib/features/gallery/data/models/gallery_media_model.dart

import 'package:intl/intl.dart';

class GalleryMediaModel {
  final int id;
  final String title;
  final String filename;
  final String mediaType;
  final String uploadedBy;
  final DateTime uploadTime;
  final String? description;
  final List<String> tags;
  final String visibility;
  final int likes;

  GalleryMediaModel({
    required this.id,
    required this.title,
    required this.filename,
    required this.mediaType,
    required this.uploadedBy,
    required this.uploadTime,
    this.description,
    required this.tags,
    required this.visibility,
    required this.likes,
  });

  // Formatert dato for visning
  String get formattedUploadTime {
    return DateFormat('dd.MM.yyyy HH:mm').format(uploadTime);
  }

  factory GalleryMediaModel.fromJson(Map<String, dynamic> json) {
    return GalleryMediaModel(
      id: json['id'] as int,
      title: json['title'] as String,
      filename: json['filename'] as String,
      mediaType: json['media_type'] as String,
      uploadedBy: json['uploaded_by'] as String,
      uploadTime: DateTime.parse(json['upload_time'] as String),
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      visibility: json['visibility'] as String,
      likes: json['likes'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'filename': filename,
        'media_type': mediaType,
        'uploaded_by': uploadedBy,
        'upload_time': uploadTime.toIso8601String(),
        'description': description,
        'tags': tags,
        'visibility': visibility,
        'likes': likes,
      };
}