import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/add_user_usecase.dart';
import '../../../../core/usecase/usecase.dart';

part 'user_notifier.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<List<UserEntity>> build() async {
    return _getUsers();
  }

  Future<List<UserEntity>> _getUsers() {
    final getUsers = ref.read(getUsersUseCaseProvider);
    return getUsers(NoParams());
  }

  Future<void> addUser(String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(addUserUseCaseProvider)(name);
      return _getUsers();
    });
  }

  void refresh() {
    ref.invalidateSelf();
  }
}
