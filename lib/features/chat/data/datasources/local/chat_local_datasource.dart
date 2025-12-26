import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/services/local_storage_service.dart';
import '../../../../../core/services/impl/shared_prefs_storage_service.dart';
import '../../models/message_model.dart';

part 'chat_local_datasource.g.dart';

abstract class ChatLocalDataSource {
  Future<List<MessageModel>> getMessages(String userId);
  Future<void> saveMessage(String userId, MessageModel message);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final LocalStorageService _storageService;
  static const String _kChatsKeyPrefix = 'chat_v2_';

  ChatLocalDataSourceImpl(this._storageService);

  @override
  Future<List<MessageModel>> getMessages(String userId) async {
    final key = '$_kChatsKeyPrefix$userId';
    final jsonString = await _storageService.getString(key);
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
    await _storageService.saveString(key, jsonString);
  }
}

@riverpod
ChatLocalDataSource chatLocalDataSource(ChatLocalDataSourceRef ref) {
  return ChatLocalDataSourceImpl(ref.watch(localStorageServiceProvider));
}
