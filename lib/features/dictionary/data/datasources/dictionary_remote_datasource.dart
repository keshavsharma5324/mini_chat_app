import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dictionary_remote_datasource.g.dart';

abstract class DictionaryRemoteDataSource {
  Future<Map<String, dynamic>> fetchWordMeaning(String word);
}

class DictionaryRemoteDataSourceImpl implements DictionaryRemoteDataSource {
  final http.Client client;

  DictionaryRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> fetchWordMeaning(String word) async {
    final response = await client.get(
      Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.first;
    } else if (response.statusCode == 404) {
      throw Exception('NOT_FOUND');
    } else {
      throw Exception('FETCH_ERROR');
    }
  }
}

@riverpod
DictionaryRemoteDataSource dictionaryRemoteDataSource(
  DictionaryRemoteDataSourceRef ref,
) {
  return DictionaryRemoteDataSourceImpl(http.Client());
}
