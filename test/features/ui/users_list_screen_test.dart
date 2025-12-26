import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mini_chat_app/features/users/presentation/screens/users_list_screen.dart';
import 'package:mini_chat_app/features/users/domain/usecases/get_users_usecase.dart';
import 'package:mini_chat_app/features/users/presentation/providers/user_notifier.dart';
import 'package:mini_chat_app/features/users/domain/entities/user_entity.dart';

void main() {
  testWidgets('UsersListScreen shows list of users', (tester) async {
    final tUsers = [
      const UserEntity(id: '1', name: 'Alice', avatarColor: 0xFF000000),
      const UserEntity(id: '2', name: 'Bob', avatarColor: 0xFFFFFFFF),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getUsersUseCaseProvider.overrideWithValue(
            MockGetUsersUseCase(tUsers),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: UsersListScreen())),
      ),
    );

    // Wait for async build
    await tester.pumpAndSettle();

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
  });

  testWidgets('UsersListScreen shows empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getUsersUseCaseProvider.overrideWithValue(MockGetUsersUseCase([])),
        ],
        child: const MaterialApp(home: Scaffold(body: UsersListScreen())),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("No users added yet. Tap + to add one."), findsOneWidget);
  });
}

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {
  final List<UserEntity> users;
  MockGetUsersUseCase(this.users);

  @override
  Future<List<UserEntity>> call(dynamic params) async => users;
}
