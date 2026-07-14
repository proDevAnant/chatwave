class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] ?? 0,
        senderId: json['sender_id'] ?? 0,
        receiverId: json['receiver_id'] ?? 0,
        content: json['content'] ?? '',
        isRead: (json['is_read'] ?? 0) == 1,
        createdAt:
            DateTime.tryParse(json['created_at'] ?? '')?.toLocal() ??
                DateTime.now(),
      );
}
