import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/chat_history_notifier.dart';
import '../../domain/entities/message_entity.dart';
import '../../data/repositories/chat_repository_impl.dart';

part 'chat_notifier.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  late String _userId;

  @override
  Future<List<MessageEntity>> build(String userId) async {
    _userId = userId;
    return _getMessages(userId);
  }

  Future<List<MessageEntity>> _getMessages(String userId) async {
    final repo = ref.read(chatRepositoryProvider);
    return repo.getMessages(userId);
  }

  Future<void> sendMessage(String text) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(chatRepositoryProvider);
      await repo.sendMessage(_userId, text);

      // Invalidate history to show new last message
      ref.invalidate(chatHistoryNotifierProvider);

      // Simulate reply delay
      Future.delayed(const Duration(seconds: 1), () async {
        await repo.receiveMessage(_userId);
        ref.invalidateSelf(); // Refresh state to show reply
        ref.invalidate(chatHistoryNotifierProvider); // Update history tab too
      });

      return _getMessages(_userId);
    });
  }
}
