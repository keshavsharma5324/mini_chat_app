import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mini_chat_app/features/users/data/datasources/user_local_datasource.dart';
import 'package:mini_chat_app/features/users/data/repositories/user_repository_impl.dart';
import 'package:mini_chat_app/features/users/data/models/user_model.dart';

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

void main() {
  late UserRepositoryImpl repository;
  late MockUserLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockUserLocalDataSource();
    repository = UserRepositoryImpl(mockDataSource);
  });

  group('UserRepositoryImpl', () {
    const tUsers = [UserModel(id: '1', name: 'Alice', avatarColor: 0)];

    test('getUsers should call localDataSource.getUsers', () async {
      when(() => mockDataSource.getUsers()).thenAnswer((_) async => tUsers);

      final result = await repository.getUsers();

      expect(result, tUsers);
      verify(() => mockDataSource.getUsers()).called(1);
    });

    test('addUser should call localDataSource.addUser', () async {
      const tName = 'Bob';
      when(() => mockDataSource.addUser(tName)).thenAnswer((_) async => {});

      await repository.addUser(tName);

      verify(() => mockDataSource.addUser(tName)).called(1);
    });
  });
}
