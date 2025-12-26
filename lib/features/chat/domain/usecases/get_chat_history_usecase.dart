import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../users/domain/repositories/user_repository.dart';
import '../../../users/data/repositories/user_repository_impl.dart';
import '../entities/chat_session_entity.dart';
import '../repositories/chat_repository.dart';
import '../../data/repositories/chat_repository_impl.dart';

part 'get_chat_history_usecase.g.dart';

class GetChatHistoryUseCase
    implements UseCase<List<ChatSessionEntity>, NoParams> {
  final UserRepository userRepository;
  final ChatRepository chatRepository;

  GetChatHistoryUseCase(this.userRepository, this.chatRepository);

  @override
  Future<List<ChatSessionEntity>> call(NoParams params) async {
    final users = await userRepository.getUsers();
    final List<ChatSessionEntity> sessions = [];

    for (final user in users) {
      final messages = await chatRepository.getMessages(user.id);
      if (messages.isNotEmpty) {
        // Assume messages are sorted by time already or sort here
        final lastMessage = messages.last;
        sessions.add(ChatSessionEntity(user: user, lastMessage: lastMessage));
      }
    }

    // Sort sessions by last message timestamp descending
    sessions.sort(
      (a, b) => b.lastMessage.timestamp.compareTo(a.lastMessage.timestamp),
    );

    return sessions;
  }
}

@riverpod
GetChatHistoryUseCase getChatHistoryUseCase(GetChatHistoryUseCaseRef ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final chatRepository = ref.watch(chatRepositoryProvider);
  return GetChatHistoryUseCase(userRepository, chatRepository);
}
