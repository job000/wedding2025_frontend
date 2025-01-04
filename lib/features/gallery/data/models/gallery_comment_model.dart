class GalleryCommentModel {
  final int id;
  final int mediaId;
  final String comment;
  final String username;
  final DateTime createdAt;

  GalleryCommentModel({
    required this.id,
    required this.mediaId,
    required this.comment,
    required this.username,
    required this.createdAt,
  });

  factory GalleryCommentModel.fromJson(Map<String, dynamic> json) {
    return GalleryCommentModel(
      id: json['id'],
      mediaId: json['media_id'],
      comment: json['comment'],
      username: json['user']['username'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'media_id': mediaId,
    'comment': comment,
    'username': username,
    'created_at': createdAt.toIso8601String(),
  };
}