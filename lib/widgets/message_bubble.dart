import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message.dart';
import '../theme/app_theme.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool animateIn;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.animateIn = false,
  });

  @override
  Widget build(BuildContext context) {
    final bubble = _buildBubble(context);
    if (!animateIn) return bubble;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutBack,
      builder: (context, t, child) {
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset((isMe ? 1 : -1) * 30 * (1 - t), 0),
            child: Transform.scale(
              scale: 0.9 + 0.1 * t,
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: child,
            ),
          ),
        );
      },
      child: bubble,
    );
  }

  Widget _buildBubble(BuildContext context) {
    final time = DateFormat('hh:mm a').format(message.createdAt);
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isMe ? 20 : 6),
      bottomRight: Radius.circular(isMe ? 6 : 20),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        padding: const EdgeInsets.fromLTRB(14, 9, 12, 8),
        decoration: BoxDecoration(
          gradient: isMe ? AppColors.outgoingGradient : null,
          color: isMe ? null : AppColors.bubbleIn,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.content,
              style: TextStyle(
                fontSize: 15.5,
                height: 1.3,
                color: isMe ? Colors.white : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isMe
                        ? Colors.white.withOpacity(0.85)
                        : AppColors.textLight,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 3),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    size: 15,
                    color: message.isRead
                        ? Colors.white
                        : Colors.white.withOpacity(0.75),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
