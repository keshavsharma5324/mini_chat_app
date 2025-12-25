import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/message_entity.dart';
import '../../data/repositories/chat_repository_impl.dart';

part 'chat_notifier.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  Future<List<MessageEntity>> build(String userId) async {
    return _getMessages(userId);
  }

  Future<List<MessageEntity>> _getMessages(String userId) async {
    final repo = ref.read(chatRepositoryProvider);
    return repo.getMessages(userId);
  }

  Future<void> sendMessage(String text) async {
    final userId = arg; // Family argument
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(chatRepositoryProvider);
      await repo.sendMessage(userId, text);

      // Simulate reply delay
      Future.delayed(const Duration(seconds: 1), () async {
        await repo.receiveMessage(userId);
        ref.invalidateSelf(); // Refresh state to show reply
      });

      return _getMessages(userId);
    });
  }
}
