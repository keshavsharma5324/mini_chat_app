import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mini_chat_app/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:mini_chat_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mini_chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:mini_chat_app/features/chat/data/models/message_model.dart';

class MockChatLocalDataSource extends Mock implements ChatLocalDataSource {}

class MockChatRemoteDataSource extends Mock implements ChatRemoteDataSource {}

class FakeMessageModel extends Fake implements MessageModel {}

void main() {
  late ChatRepositoryImpl repository;
  late MockChatLocalDataSource mockLocal;
  late MockChatRemoteDataSource mockRemote;

  setUpAll(() {
    registerFallbackValue(FakeMessageModel());
  });

  setUp(() {
    mockLocal = MockChatLocalDataSource();
    mockRemote = MockChatRemoteDataSource();
    repository = ChatRepositoryImpl(mockLocal, mockRemote);
  });

  group('ChatRepositoryImpl', () {
    const tUserId = 'user_1';
    final tMessages = [
      MessageModel(
        id: '1',
        text: 'hi',
        timestamp: DateTime.now(),
        isSender: true,
      ),
    ];

    test('getMessages should call localDataSource.getMessages', () async {
      when(
        () => mockLocal.getMessages(tUserId),
      ).thenAnswer((_) async => tMessages);

      final result = await repository.getMessages(tUserId);

      expect(result, tMessages);
      verify(() => mockLocal.getMessages(tUserId)).called(1);
    });

    test(
      'sendMessage should create message and save to localDataSource',
      () async {
        const tText = 'hello';
        when(
          () => mockLocal.saveMessage(any(), any()),
        ).thenAnswer((_) async => {});

        await repository.sendMessage(tUserId, tText);

        verify(() => mockLocal.saveMessage(tUserId, any())).called(1);
      },
    );

    test('receiveMessage should fetch from remote and save to local', () async {
      const tQuote = 'Life is good';
      when(
        () => mockRemote.fetchRandomComment(),
      ).thenAnswer((_) async => tQuote);
      when(
        () => mockLocal.saveMessage(any(), any()),
      ).thenAnswer((_) async => {});

      await repository.receiveMessage(tUserId);

      verify(() => mockRemote.fetchRandomComment()).called(1);
      verify(() => mockLocal.saveMessage(tUserId, any())).called(1);
    });
  });
}
