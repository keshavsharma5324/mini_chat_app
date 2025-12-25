import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_chat_app/features/users/domain/entities/user_entity.dart';
import 'package:mini_chat_app/features/users/presentation/providers/user_notifier.dart';
import 'package:mini_chat_app/features/users/domain/usecases/get_users_usecase.dart';
import 'package:mini_chat_app/features/users/domain/usecases/add_user_usecase.dart';
import 'package:mini_chat_app/core/usecase/usecase.dart'; // import NoParams

class MockGetUsersUseCase implements GetUsersUseCase {
  @override
  Future<List<UserEntity>> call(NoParams params) async {
    return [const UserEntity(id: '1', name: 'Alice', avatarColor: 0xFF000000)];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAddUserUseCase implements AddUserUseCase {
  @override
  Future<void> call(String name) async {
    // Mock success
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('UserNotifier loads users on build', () async {
    final container = ProviderContainer(
      overrides: [
        getUsersUseCaseProvider.overrideWith((ref) => MockGetUsersUseCase()),
      ],
    );

    final users = await container.read(userNotifierProvider.future);
    expect(users.length, 1);
    expect(users.first.name, 'Alice');
  });
}
