import 'package:flutter/material.dart';

class AppUser {
  final int id;
  final String username;
  final String name;
  final String avatarColor;
  final String bio;
  final String? token;

  AppUser({
    required this.id,
    required this.username,
    required this.name,
    required this.avatarColor,
    required this.bio,
    this.token,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] ?? 0,
        username: json['username'] ?? '',
        name: json['name'] ?? '',
        avatarColor: json['avatar_color'] ?? '#2AABEE',
        bio: json['bio'] ?? '',
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'name': name,
        'avatar_color': avatarColor,
        'bio': bio,
        'token': token,
      };

  Color get color {
    var hex = avatarColor.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
