import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/app_utils.dart';
import '../../../../core/widgets/error_view.dart';
import '../providers/chat_history_notifier.dart';
import 'chat_screen.dart';

class ChatHistoryScreen extends ConsumerStatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  ConsumerState<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends ConsumerState<ChatHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final historyAsync = ref.watch(chatHistoryNotifierProvider);

    return historyAsync.when(
      data: (sessions) {
        if (sessions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text("No chat history found."),
                Text(
                  "Start a conversation with a user!",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          key: const PageStorageKey('chat_history_list'),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(session.user.avatarColor),
                radius: 24,
                child: Text(
                  session.user.name.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                session.user.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                session.lastMessage.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    session.lastMessage.timestamp.toRelativeString(),
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                  ),
                  if (session.unreadCount > 0) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${session.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(user: session.user),
                  ),
                ).then((_) {
                  ref.read(chatHistoryNotifierProvider.notifier).refresh();
                });
              },
            );
          },
        );
      },
      error: (err, stack) => ErrorView(
        message: err.toString().replaceAll('Exception: ', ''),
        onRetry: () => ref.read(chatHistoryNotifierProvider.notifier).refresh(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
