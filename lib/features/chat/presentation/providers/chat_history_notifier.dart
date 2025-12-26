import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/chat_session_entity.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../../../../core/usecase/usecase.dart';

part 'chat_history_notifier.g.dart';

@riverpod
class ChatHistoryNotifier extends _$ChatHistoryNotifier {
  @override
  Future<List<ChatSessionEntity>> build() async {
    return _fetchHistory();
  }

  Future<List<ChatSessionEntity>> _fetchHistory() {
    final useCase = ref.watch(getChatHistoryUseCaseProvider);
    return useCase(NoParams());
  }

  void refresh() {
    ref.invalidateSelf();
  }
}
