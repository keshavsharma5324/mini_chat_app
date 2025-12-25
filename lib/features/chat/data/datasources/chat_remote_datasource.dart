import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_remote_datasource.g.dart';

abstract class ChatRemoteDataSource {
  Future<String> fetchRandomComment();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;

  ChatRemoteDataSourceImpl(this.client);

  @override
  Future<String> fetchRandomComment() async {
    try {
      // Using simpler endpoint for reliability in demo
      final response = await client.get(
        Uri.parse('https://dummyjson.com/quotes/random'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['quote'] ?? "Hello!";
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      return "Hello! How are you?"; // Fallback
    }
  }
}

@riverpod
ChatRemoteDataSource chatRemoteDataSource(ChatRemoteDataSourceRef ref) {
  return ChatRemoteDataSourceImpl(http.Client());
}
