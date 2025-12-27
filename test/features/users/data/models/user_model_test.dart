import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat_app/features/users/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    const userJson = {
      'id': '1',
      'name': 'Test User',
      'avatarColor': 0xFF123456,
      'isOnline': false,
      'lastSeen': null,
    };

    test('should convert from JSON correctly', () {
      final model = UserModel.fromJson(userJson);
      expect(model.id, '1');
      expect(model.name, 'Test User');
      expect(model.avatarColor, 0xFF123456);
      expect(model.isOnline, false);
      expect(model.lastSeen, null);
    });

    test('should convert to JSON correctly', () {
      const model = UserModel(
        id: '1',
        name: 'Test User',
        avatarColor: 0xFF123456,
        isOnline: false,
        lastSeen: null,
      );
      final json = model.toJson();
      expect(json, userJson);
    });
  });
}
