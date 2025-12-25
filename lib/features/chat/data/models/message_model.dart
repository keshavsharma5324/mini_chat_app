import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/message_entity.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.text,
    required super.timestamp,
    required super.isSender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
