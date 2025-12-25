class MessageEntity {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isSender;

  MessageEntity({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isSender,
  });
}
