import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../providers/user_notifier.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import '../../../../utils/app_utils.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  const UsersListScreen({super.key});

  @override
  ConsumerState<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _addUserQuickly() {
    final List<String> names = [
      "Alice Smith",
      "Bob Jones",
      "Charlie Brown",
      "Diana Prince",
      "Ethan Hunt",
    ];
    final name =
        names[DateTime.now().millisecondsSinceEpoch % names.length] +
        " ${Random().nextInt(100)}";

    ref.read(userNotifierProvider.notifier).addUser(name);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("User added: $name"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final usersAsync = ref.watch(userNotifierProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addUserQuickly,
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: Text("No users added yet. Tap + to add one."),
            );
          }
          return ListView.builder(
            key: const PageStorageKey('users_list'),
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(user.avatarColor),
                        radius: 24,
                        child: Text(
                          user.name.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (user.isOnline)
                        Positioned(
                          right: 2,
                          bottom: 2,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  user.isOnline
                      ? "Online"
                      : (user.lastSeen?.toRelativeString() ?? "Offline"),
                  style: TextStyle(
                    color: user.isOnline ? Colors.green : Colors.grey,
                    fontSize: 12,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatScreen(user: user)),
                  );
                },
              );
            },
          );
        },
        error: (err, stack) => ErrorView(
          message: err.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref.read(userNotifierProvider.notifier).refresh(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
