import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../models/chat.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class ApiService {
  static const _timeout = Duration(seconds: 15);

  static Future<Map<String, dynamic>> _post(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final res = await http
          .post(
            Uri.parse('${AppConfig.baseUrl}/$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException('Server se connect nahi ho paaya. Internet/URL check karein.');
    }
  }

  static Future<Map<String, dynamic>> _get(String endpoint) async {
    try {
      final res = await http
          .get(Uri.parse('${AppConfig.baseUrl}/$endpoint'))
          .timeout(_timeout);
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException('Server se connect nahi ho paaya.');
    }
  }

  static Future<AppUser> register(
      String username, String name, String password) async {
    final data = await _post('register.php', {
      'username': username,
      'name': name,
      'password': password,
    });
    if (data['success'] != true) throw ApiException(data['message'] ?? 'Register fail');
    return AppUser.fromJson(data['user']);
  }

  static Future<AppUser> login(String username, String password) async {
    final data = await _post('login.php', {
      'username': username,
      'password': password,
    });
    if (data['success'] != true) throw ApiException(data['message'] ?? 'Login fail');
    return AppUser.fromJson(data['user']);
  }

  static Future<List<AppUser>> getUsers(int userId, {String search = ''}) async {
    final data = await _get('users.php?user_id=$userId&search=$search');
    if (data['success'] != true) throw ApiException(data['message'] ?? 'Error');
    return (data['users'] as List).map((e) => AppUser.fromJson(e)).toList();
  }

  static Future<List<Chat>> getChats(int userId) async {
    final data = await _get('get_chats.php?user_id=$userId');
    if (data['success'] != true) throw ApiException(data['message'] ?? 'Error');
    return (data['chats'] as List).map((e) => Chat.fromJson(e)).toList();
  }

  static Future<List<Message>> getMessages(int userId, int chatWith) async {
    final data = await _get('get_messages.php?user_id=$userId&chat_with=$chatWith');
    if (data['success'] != true) throw ApiException(data['message'] ?? 'Error');
    return (data['messages'] as List).map((e) => Message.fromJson(e)).toList();
  }

  static Future<Message> sendMessage(
      int senderId, int receiverId, String content) async {
    final data = await _post('send_message.php', {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
    });
    if (data['success'] != true) throw ApiException(data['message'] ?? 'Send fail');
    return Message.fromJson(data['message']);
  }
}
