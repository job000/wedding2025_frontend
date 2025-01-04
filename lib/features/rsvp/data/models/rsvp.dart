// lib/features/rsvp/data/models/rsvp.dart

class RSVP {
  final int? id;
  final String name;
  final String email;
  final bool attending;
  final String? allergies;
  final DateTime? createdAt;

  RSVP({
    this.id,
    required this.name,
    required this.email,
    required this.attending,
    this.allergies,
    this.createdAt,
  });

  factory RSVP.fromJson(Map<String, dynamic> json) {
    return RSVP(
      id: json['id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String,
      attending: json['attending'] as bool,
      allergies: json['allergies'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'attending': attending,
      if (allergies != null) 'allergies': allergies,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'RSVP(id: $id, name: $name, email: $email, attending: $attending, '
           'allergies: $allergies, createdAt: $createdAt)';
  }
}