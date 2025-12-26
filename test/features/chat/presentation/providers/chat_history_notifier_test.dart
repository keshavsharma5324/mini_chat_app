import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mini_chat_app/features/chat/domain/entities/chat_session_entity.dart';
import 'package:mini_chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:mini_chat_app/features/users/domain/entities/user_entity.dart';
import 'package:mini_chat_app/features/chat/domain/usecases/get_chat_history_usecase.dart';
import 'package:mini_chat_app/features/chat/presentation/providers/chat_history_notifier.dart';
import 'package:mini_chat_app/core/usecase/usecase.dart';

class MockGetChatHistoryUseCase extends Mock implements GetChatHistoryUseCase {}

void main() {
  late MockGetChatHistoryUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockUseCase = MockGetChatHistoryUseCase();
  });

  group('ChatHistoryNotifier', () {
    final tSessions = [
      ChatSessionEntity(
        user: const UserEntity(id: '1', name: 'Alice', avatarColor: 0),
        lastMessage: MessageEntity(
          id: '1',
          text: 'hi',
          timestamp: DateTime.now(),
          isSender: true,
        ),
      ),
    ];

    test('should fetch history on build', () async {
      when(() => mockUseCase.call(any())).thenAnswer((_) async => tSessions);

      final container = ProviderContainer(
        overrides: [
          getChatHistoryUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );

      final state = await container.read(chatHistoryNotifierProvider.future);
      expect(state, tSessions);
      verify(() => mockUseCase.call(any())).called(1);
    });
  });
}
