import 'dart:convert';
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/services/local_storage_service.dart';
import '../../../../../core/services/impl/shared_prefs_storage_service.dart';
import '../../models/user_model.dart';
import '../../../../../utils/app_utils.dart';

part 'user_local_datasource.g.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getUsers();
  Future<void> addUser(String name);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final LocalStorageService _storageService;
  static const String _kUsersKey = 'users_v2'; // Versioned key

  UserLocalDataSourceImpl(this._storageService);

  @override
  Future<List<UserModel>> getUsers() async {
    final jsonString = await _storageService.getString(_kUsersKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    final users = jsonList.map((e) => UserModel.fromJson(e)).toList();

    // For demo purposes: randomly set some users as online/offline and set lastSeen
    return users.map((u) {
      final isOnline = Random().nextBool();
      DateTime? lastSeen;
      if (!isOnline) {
        // Randomly pick a time within the last 3 days
        lastSeen = DateTime.now().subtract(
          Duration(
            days: Random().nextInt(3),
            hours: Random().nextInt(24),
            minutes: Random().nextInt(60),
          ),
        );
      }
      return u.copyWithIsOnline(isOnline, lastSeen: lastSeen);
    }).toList();
  }

  @override
  Future<void> addUser(String name) async {
    final users = await getUsers();
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      avatarColor: UiUtils.getRandomAvatarColor().value,
      isOnline: Random().nextBool(),
      lastSeen: null,
    );
    users.add(newUser);
    final jsonString = jsonEncode(users.map((e) => e.toJson()).toList());
    await _storageService.saveString(_kUsersKey, jsonString);
  }
}

@riverpod
UserLocalDataSource userLocalDataSource(UserLocalDataSourceRef ref) {
  return UserLocalDataSourceImpl(ref.watch(localStorageServiceProvider));
}
