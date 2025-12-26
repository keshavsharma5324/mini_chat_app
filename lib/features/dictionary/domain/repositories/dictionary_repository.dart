import '../entities/word_meaning_entity.dart';

abstract class DictionaryRepository {
  Future<WordMeaningEntity> getWordMeaning(String word);
}
