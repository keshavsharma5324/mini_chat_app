import '../entities/message_entity.dart';

abstract class ChatRepository {
  Future<List<MessageEntity>> getMessages(String userId);
  Future<void> sendMessage(String userId, String text);
  Future<void> receiveMessage(String userId); // Fetches from API
}
