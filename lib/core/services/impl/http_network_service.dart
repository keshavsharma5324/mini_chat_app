import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network_service.dart';

part 'http_network_service.g.dart';

class HttpNetworkService implements NetworkService {
  final http.Client _client;

  HttpNetworkService(this._client);

  @override
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final response = await _client.get(Uri.parse(url), headers: headers);
    return _handleResponse(response);
  }

  @override
  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final response = await _client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Network Error: ${response.statusCode} - ${response.reasonPhrase}',
      );
    }
  }
}

@riverpod
NetworkService networkService(NetworkServiceRef ref) {
  return HttpNetworkService(http.Client());
}
