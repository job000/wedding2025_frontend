import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AuthResponseModel {
  final String accessToken;
  final Map<String, dynamic>? user;

  const AuthResponseModel({
    required this.accessToken,
    this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) => AuthResponseModel(
        accessToken: json['access_token'] as String,
        user: json['user'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'user': user,
      };
}