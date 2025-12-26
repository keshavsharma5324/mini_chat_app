import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/word_meaning_entity.dart';
import '../../domain/usecases/get_word_meaning_usecase.dart';

part 'word_meaning_notifier.g.dart';

@riverpod
class WordMeaningNotifier extends _$WordMeaningNotifier {
  @override
  FutureOr<WordMeaningEntity?> build(String word) async {
    if (word.isEmpty) return null;
    final useCase = ref.watch(getWordMeaningUseCaseProvider);
    return useCase(word);
  }
}
