class UserEntity {
  final String id;
  final String name;
  final int avatarColor;
  final bool isOnline;
  final DateTime? lastSeen;

  const UserEntity({
    required this.id,
    required this.name,
    required this.avatarColor,
    this.isOnline = false,
    this.lastSeen,
  });
}
