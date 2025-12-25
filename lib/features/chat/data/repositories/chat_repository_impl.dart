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
  Future<List<MessageEntity>> getMessages(String userId) {
    return localDataSource.getMessages(userId);
  }

  @override
  Future<void> sendMessage(String userId, String text) async {
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      isSender: true,
    );
    await localDataSource.saveMessage(userId, message);
  }

  @override
  Future<void> receiveMessage(String userId) async {
    final text = await remoteDataSource.fetchRandomComment();
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      isSender: false,
    );
    await localDataSource.saveMessage(userId, message);
  }
}

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final local = ref.watch(chatLocalDataSourceProvider);
  final remote = ref.watch(chatRemoteDataSourceProvider);
  return ChatRepositoryImpl(local, remote);
}
