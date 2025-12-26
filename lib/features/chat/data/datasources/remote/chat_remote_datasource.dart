import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/services/network_service.dart';
import '../../../../../core/services/impl/http_network_service.dart';

part 'chat_remote_datasource.g.dart';

abstract class ChatRemoteDataSource {
  Future<String> fetchRandomComment();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final NetworkService _networkService;

  ChatRemoteDataSourceImpl(this._networkService);

  @override
  Future<String> fetchRandomComment() async {
    try {
      final data = await _networkService.get(
        'https://dummyjson.com/quotes/random',
      );
      return data['quote'] ?? "Hello!";
    } catch (e) {
      return "Hello! How are you?"; // Fallback
    }
  }
}

@riverpod
ChatRemoteDataSource chatRemoteDataSource(ChatRemoteDataSourceRef ref) {
  return ChatRemoteDataSourceImpl(ref.watch(networkServiceProvider));
}
