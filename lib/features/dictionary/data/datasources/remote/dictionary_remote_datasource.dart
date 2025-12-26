import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/services/network_service.dart';
import '../../../../../core/services/impl/http_network_service.dart';

part 'dictionary_remote_datasource.g.dart';

abstract class DictionaryRemoteDataSource {
  Future<Map<String, dynamic>> fetchWordMeaning(String word);
}

class DictionaryRemoteDataSourceImpl implements DictionaryRemoteDataSource {
  final NetworkService _networkService;

  DictionaryRemoteDataSourceImpl(this._networkService);

  @override
  Future<Map<String, dynamic>> fetchWordMeaning(String word) async {
    try {
      final data = await _networkService.get(
        'https://api.dictionaryapi.dev/api/v2/entries/en/$word',
      );
      if (data is List && data.isNotEmpty) {
        return data.first;
      }
      throw Exception('FETCH_ERROR');
    } catch (e) {
      if (e.toString().contains('404')) {
        throw Exception('NOT_FOUND');
      }
      throw Exception('FETCH_ERROR');
    }
  }
}

@riverpod
DictionaryRemoteDataSource dictionaryRemoteDataSource(
  DictionaryRemoteDataSourceRef ref,
) {
  return DictionaryRemoteDataSourceImpl(ref.watch(networkServiceProvider));
}
