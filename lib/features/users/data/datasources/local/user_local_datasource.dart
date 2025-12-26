import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/local_storage_service.dart';
import '../../../../../core/services/impl/shared_prefs_storage_service.dart';
import '../../models/user_model.dart';

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
    return jsonList.map((e) => UserModel.fromJson(e)).toList();
  }

  @override
  Future<void> addUser(String name) async {
    final users = await getUsers();
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      avatarColor: _getRandomColor().value,
    );
    users.add(newUser);
    final jsonString = jsonEncode(users.map((e) => e.toJson()).toList());
    await _storageService.saveString(_kUsersKey, jsonString);
  }

  Color _getRandomColor() {
    final List<Color> colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      Colors.green,
      Colors.orange,
      Colors.teal,
    ];
    return colors[Random().nextInt(colors.length)];
  }
}

@riverpod
UserLocalDataSource userLocalDataSource(UserLocalDataSourceRef ref) {
  return UserLocalDataSourceImpl(ref.watch(localStorageServiceProvider));
}
