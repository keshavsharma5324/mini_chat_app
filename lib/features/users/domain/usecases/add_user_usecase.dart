import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';

part 'add_user_usecase.g.dart';

class AddUserUseCase implements UseCase<void, String> {
  final UserRepository repository;
  AddUserUseCase(this.repository);

  @override
  Future<void> call(String name) {
    return repository.addUser(name);
  }
}

@riverpod
AddUserUseCase addUserUseCase(AddUserUseCaseRef ref) {
  final repository = ref.watch(userRepositoryProvider);
  return AddUserUseCase(repository);
}
