import 'package:mini_chat_app/features/users/domain/entities/user_entity.dart';
import 'message_entity.dart';

class ChatSessionEntity {
  final UserEntity user;
  final MessageEntity lastMessage;
  final int unreadCount;

  ChatSessionEntity({
    required this.user,
    required this.lastMessage,
    this.unreadCount = 0,
  });
}
