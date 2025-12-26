import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mini_chat_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:mini_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:mini_chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:mini_chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:mini_chat_app/features/users/domain/entities/user_entity.dart';

void main() {
  const tUser = UserEntity(id: '1', name: 'Alice', avatarColor: 0xFF123456);

  testWidgets('ChatScreen shows messages', (tester) async {
    final tMessages = [
      MessageEntity(
        id: '1',
        text: 'Hello Alice',
        timestamp: DateTime.now(),
        isSender: true,
      ),
      MessageEntity(
        id: '2',
        text: 'Hi there!',
        timestamp: DateTime.now(),
        isSender: false,
      ),
    ];

    final mockRepo = MockChatRepository();
    when(() => mockRepo.getMessages('1')).thenAnswer((_) async => tMessages);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [chatRepositoryProvider.overrideWithValue(mockRepo)],
        child: const MaterialApp(home: ChatScreen(user: tUser)),
      ),
    );

    await tester.pumpAndSettle();

    // Verify AppBar shows user name
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Alice')),
      findsOneWidget,
    );

    // Verify message bubble words (split for dictionary)
    expect(find.text('Hello '), findsOneWidget);
    expect(find.text('Alice '), findsOneWidget);
    expect(find.text('Hi '), findsOneWidget);
  });
}

class MockChatRepository extends Mock implements ChatRepository {}
