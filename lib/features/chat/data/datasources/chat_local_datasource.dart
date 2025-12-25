import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/message_model.dart';

part 'chat_local_datasource.g.dart';

abstract class ChatLocalDataSource {
  Future<List<MessageModel>> getMessages(String userId);
  Future<void> saveMessage(String userId, MessageModel message);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _kChatsKeyPrefix = 'chat_v2_';

  ChatLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<MessageModel>> getMessages(String userId) async {
    final key = '$_kChatsKeyPrefix$userId';
    final jsonString = sharedPreferences.getString(key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => MessageModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveMessage(String userId, MessageModel message) async {
    final messages = await getMessages(userId);
    messages.add(message);

    final key = '$_kChatsKeyPrefix$userId';
    final jsonString = jsonEncode(messages.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(key, jsonString);
  }
}

@riverpod
ChatLocalDataSource chatLocalDataSource(ChatLocalDataSourceRef ref) {
  // We need the same SharedPreferences instance.
  // Ideally we have a core provider for SharedPrefs.
  // For now, I will throw standard error to be overridden in main
  throw UnimplementedError('SharedPreferences not initialized');
}
