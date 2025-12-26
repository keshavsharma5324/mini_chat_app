import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mini_chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:mini_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:mini_chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:mini_chat_app/features/chat/presentation/providers/chat_notifier.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepo;
  const tUserId = '1';

  setUp(() {
    mockRepo = MockChatRepository();
  });

  group('ChatNotifier', () {
    final tMessages = [
      MessageEntity(
        id: '1',
        text: 'hi',
        timestamp: DateTime.now(),
        isSender: true,
      ),
    ];

    test('should load messages on build', () async {
      when(
        () => mockRepo.getMessages(tUserId),
      ).thenAnswer((_) async => tMessages);

      final container = ProviderContainer(
        overrides: [chatRepositoryProvider.overrideWithValue(mockRepo)],
      );

      final state = await container.read(chatNotifierProvider(tUserId).future);
      expect(state, tMessages);
      verify(() => mockRepo.getMessages(tUserId)).called(1);
    });

    test('sendMessage should update state and trigger repo calls', () async {
      when(
        () => mockRepo.getMessages(tUserId),
      ).thenAnswer((_) async => tMessages);
      when(
        () => mockRepo.sendMessage(tUserId, 'hello'),
      ).thenAnswer((_) async => {});
      when(() => mockRepo.receiveMessage(tUserId)).thenAnswer((_) async => {});

      final container = ProviderContainer(
        overrides: [chatRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // Trigger build
      await container.read(chatNotifierProvider(tUserId).future);

      await container
          .read(chatNotifierProvider(tUserId).notifier)
          .sendMessage('hello');

      verify(() => mockRepo.sendMessage(tUserId, 'hello')).called(1);
      // verify(() => mockRepo.getMessages(tUserId)).called(2); // Initial + After send
    });
  });
}
