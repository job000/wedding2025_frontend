import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  final String username;
  final String role;
  final String? email;

  const User({
    required this.username,
    required this.role,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json['username'] as String,
        role: json['role'] as String,
        email: json['email'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'role': role,
        'email': email,
      };
}