import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat_app/features/chat/data/models/message_model.dart';

void main() {
  group('MessageModel', () {
    final timestamp = DateTime.parse('2023-01-01T12:00:00Z');
    final messageJson = {
      'id': 'msg_1',
      'text': 'Hello world',
      'timestamp': '2023-01-01T12:00:00.000Z',
      'isSender': true,
    };

    test('should convert from JSON correctly', () {
      final model = MessageModel.fromJson(messageJson);
      expect(model.id, 'msg_1');
      expect(model.text, 'Hello world');
      expect(model.timestamp.toIso8601String(), '2023-01-01T12:00:00.000Z');
      expect(model.isSender, true);
    });

    test('should convert to JSON correctly', () {
      final model = MessageModel(
        id: 'msg_1',
        text: 'Hello world',
        timestamp: timestamp.toUtc(),
        isSender: true,
      );
      final json = model.toJson();
      expect(json['id'], 'msg_1');
      expect(json['text'], 'Hello world');
      expect(json['timestamp'], '2023-01-01T12:00:00.000Z');
      expect(json['isSender'], true);
    });
  });
}
