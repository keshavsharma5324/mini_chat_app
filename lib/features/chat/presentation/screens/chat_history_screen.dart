import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
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

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: sessions.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, indent: 72),
          itemBuilder: (context, index) {
            final session = sessions[index];
            final lastMsg = session.lastMessage;
            final user = session.user;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(user.avatarColor),
                radius: 24,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                lastMsg.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(lastMsg.timestamp),
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                  ),
                  if (!lastMsg.isSender) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatScreen(user: user)),
                ).then((_) {
                  // Refresh history when coming back as messages might have been sent
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

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (date == today) {
      return DateFormat.jm().format(timestamp);
    } else if (today.difference(date).inDays == 1) {
      return "Yesterday";
    } else {
      return DateFormat.MMMd().format(timestamp);
    }
  }
}
