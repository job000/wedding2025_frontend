import 'package:intl/intl.dart';

// Ny klasse for kommentarer
class Comment {
  final String user;
  final String comment;

  Comment({
    required this.user,
    required this.comment,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'] as String,
      comment: json['comment'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'comment': comment,
    };
  }
}

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
  final List<Comment>? comments; // Nytt felt for kommentarer

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
    this.comments, // Legger til kommentarer
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
      comments: (json['comments'] as List<dynamic>?)
          ?.map((comment) => Comment.fromJson(comment as Map<String, dynamic>))
          .toList(), // Parser kommentarer
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
        'comments': comments?.map((comment) => comment.toJson()).toList(),
      };
}
