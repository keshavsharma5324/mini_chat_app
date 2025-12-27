import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.avatarColor,
    super.isOnline = false,
    super.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      avatarColor: entity.avatarColor,
      isOnline: entity.isOnline,
      lastSeen: entity.lastSeen,
    );
  }

  UserModel copyWithIsOnline(bool isOnline, {DateTime? lastSeen}) {
    return UserModel(
      id: id,
      name: name,
      avatarColor: avatarColor,
      isOnline: isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
