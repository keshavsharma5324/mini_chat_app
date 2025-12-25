import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

part 'get_users_usecase.g.dart';

class GetUsersUseCase implements UseCase<List<UserEntity>, NoParams> {
  final UserRepository repository;
  GetUsersUseCase(this.repository);

  @override
  Future<List<UserEntity>> call(NoParams params) {
    return repository.getUsers();
  }
}

@riverpod
GetUsersUseCase getUsersUseCase(GetUsersUseCaseRef ref) {
  throw UnimplementedError('Provider was not overridden');
}
