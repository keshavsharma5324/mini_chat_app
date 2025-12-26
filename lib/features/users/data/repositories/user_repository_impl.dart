import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/user_local_datasource.dart';

part 'user_repository_impl.g.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<List<UserEntity>> getUsers() async {
    return await localDataSource.getUsers();
  }

  @override
  Future<void> addUser(String name) async {
    return await localDataSource.addUser(name);
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final localDataSource = ref.watch(userLocalDataSourceProvider);
  return UserRepositoryImpl(localDataSource);
}
