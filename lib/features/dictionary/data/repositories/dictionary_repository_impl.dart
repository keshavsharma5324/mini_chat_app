import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/word_meaning_entity.dart';
import '../../domain/repositories/dictionary_repository.dart';
import '../datasources/remote/dictionary_remote_datasource.dart';

part 'dictionary_repository_impl.g.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryRemoteDataSource remoteDataSource;

  DictionaryRepositoryImpl(this.remoteDataSource);

  @override
  Future<WordMeaningEntity> getWordMeaning(String word) async {
    try {
      final data = await remoteDataSource.fetchWordMeaning(word);

      final String phonetics =
          data['phonetic'] ??
          (data['phonetics'] as List?)?.firstOrNull?['text'] ??
          '';
      final meanings = data['meanings'] as List;
      final List<String> definitions = [];

      for (var meaning in meanings) {
        final defs = meaning['definitions'] as List;
        for (var def in defs) {
          definitions.add(def['definition'] ?? '');
        }
      }

      return WordMeaningEntity(
        word: data['word'] ?? word,
        phonetic: phonetics,
        definitions: definitions,
      );
    } catch (e) {
      if (e.toString().contains('NOT_FOUND')) {
        throw Exception("Word '$word' not found in our records.");
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Network')) {
        throw Exception("Please check your internet connection and try again.");
      }
      throw Exception(
        "Unexpected error occurred while fetching dictionary data.",
      );
    }
  }
}

@riverpod
DictionaryRepository dictionaryRepository(DictionaryRepositoryRef ref) {
  final remote = ref.watch(dictionaryRemoteDataSourceProvider);
  return DictionaryRepositoryImpl(remote);
}
