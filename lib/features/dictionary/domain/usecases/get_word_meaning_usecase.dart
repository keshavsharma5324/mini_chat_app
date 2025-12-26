import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/word_meaning_entity.dart';
import '../repositories/dictionary_repository.dart';
import '../../data/repositories/dictionary_repository_impl.dart';

part 'get_word_meaning_usecase.g.dart';

class GetWordMeaningUseCase implements UseCase<WordMeaningEntity, String> {
  final DictionaryRepository repository;
  GetWordMeaningUseCase(this.repository);

  @override
  Future<WordMeaningEntity> call(String word) {
    return repository.getWordMeaning(word);
  }
}

@riverpod
GetWordMeaningUseCase getWordMeaningUseCase(GetWordMeaningUseCaseRef ref) {
  final repo = ref.watch(dictionaryRepositoryProvider);
  return GetWordMeaningUseCase(repo);
}
