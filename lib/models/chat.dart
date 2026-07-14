import 'package:flutter/material.dart';

class Chat {
  final int id;
  final String name;
  final String username;
  final String avatarColor;
  final String? lastMessage;
  final DateTime? lastTime;
  final int unreadCount;

  Chat({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarColor,
    this.lastMessage,
    this.lastTime,
    required this.unreadCount,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        username: json['username'] ?? '',
        avatarColor: json['avatar_color'] ?? '#2AABEE',
        lastMessage: json['last_message'],
        lastTime: json['last_time'] != null
            ? DateTime.tryParse(json['last_time'])?.toLocal()
            : null,
        unreadCount: json['unread_count'] ?? 0,
      );

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
