import 'package:intl/intl.dart';
import '../../../../core/constants/api_constants.dart';  // Legg til denne importen

// Ny klasse for kommentarer med utvidet funksjonalitet
class Comment {
  final String user;
  final String comment;
  final DateTime createdAt;  // Legger til tidsstempel

  Comment({
    required this.user,
    required this.comment,
    required this.createdAt,  // Krever tidsstempel
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'] ?? json['username'] ?? 'Anonymous',  // Håndterer ulike API-formater
      comment: json['comment'] as String,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Formattert tidspunkt for visning
  String get formattedTime {
    return DateFormat('dd.MM.yyyy HH:mm').format(createdAt);
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
  final List<Comment>? comments;
  final bool isLikedByCurrentUser;  // Ny: holder styr på om innlogget bruker har likt

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
    this.comments,
    this.isLikedByCurrentUser = false,  // Default til false
  });

  // URL til bildet
  String get imageUrl => '${ApiConstants.baseUrl}/uploads/$filename';
  
  // URL til miniatyrbilde (hvis tilgjengelig)
  String? get thumbnailUrl => 
      '${ApiConstants.baseUrl}/uploads/thumbnails/$filename';

  // Formatert dato for visning
  String get formattedUploadTime {
    return DateFormat('dd.MM.yyyy HH:mm').format(uploadTime);
  }

  // Helper metode for å kopiere modellen med oppdaterte verdier
  GalleryMediaModel copyWith({
    int? id,
    String? title,
    String? filename,
    String? mediaType,
    String? uploadedBy,
    DateTime? uploadTime,
    String? description,
    List<String>? tags,
    String? visibility,
    int? likes,
    List<Comment>? comments,
    bool? isLikedByCurrentUser,
  }) {
    return GalleryMediaModel(
      id: id ?? this.id,
      title: title ?? this.title,
      filename: filename ?? this.filename,
      mediaType: mediaType ?? this.mediaType,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadTime: uploadTime ?? this.uploadTime,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      visibility: visibility ?? this.visibility,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
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
          .toList(),
      isLikedByCurrentUser: json['is_liked_by_current_user'] as bool? ?? false,
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
        'is_liked_by_current_user': isLikedByCurrentUser,
      };

  // Helper metoder for kommentarer
  bool get hasComments => comments?.isNotEmpty ?? false;
  int get commentCount => comments?.length ?? 0;
  List<Comment> get sortedComments => 
      (comments ?? [])..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  // Helper metoder for likes
  bool get hasLikes => likes > 0;
  String get likeCountText => likes == 1 ? '1 like' : '$likes likes';
}