import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/message_model.dart';

part 'chat_repository_impl.g.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<List<MessageEntity>> getMessages(String userId) async {
    try {
      return await localDataSource.getMessages(userId);
    } catch (e) {
      throw Exception("Failed to load your chat messages.");
    }
  }

  @override
  Future<void> sendMessage(String userId, String text) async {
    try {
      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        timestamp: DateTime.now(),
        isSender: true,
      );
      await localDataSource.saveMessage(userId, message);
    } catch (e) {
      throw Exception("Failed to send your message. Please try again.");
    }
  }

  @override
  Future<void> receiveMessage(String userId) async {
    try {
      final quote = await remoteDataSource.fetchRandomComment();
      final reply = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: quote,
        timestamp: DateTime.now(),
        isSender: false,
      );
      await localDataSource.saveMessage(userId, reply);
    } catch (e) {
      // For automated replies, maybe just ignore or log
    }
  }
}

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final local = ref.watch(chatLocalDataSourceProvider);
  final remote = ref.watch(chatRemoteDataSourceProvider);
  return ChatRepositoryImpl(local, remote);
}
