import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../utils/app_utils.dart';
import '../../../users/domain/entities/user_entity.dart';
import '../providers/chat_notifier.dart';
import '../widgets/message_bubble.dart';
import '../../../home/presentation/widgets/app_bottom_nav_bar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final UserEntity user;
  final bool readOnly;

  const ChatScreen({super.key, required this.user, this.readOnly = false});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();

    try {
      await ref
          .read(chatNotifierProvider(widget.user.id).notifier)
          .sendMessage(text);
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider(widget.user.id));

    // Listen for state changes to scroll to bottom on new messages
    ref.listen(chatNotifierProvider(widget.user.id), (previous, next) {
      if (next is AsyncData && next.value != null) {
        final prevLength = previous?.value?.length ?? 0;
        final nextLength = next.value!.length;
        if (nextLength > prevLength) {
          _scrollToBottom();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Color(widget.user.avatarColor),
                  child: Text(
                    widget.user.name.initials,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (widget.user.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.name, style: const TextStyle(fontSize: 16)),
                Text(
                  widget.user.isOnline ? "Online" : "Offline",
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.user.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text("Say Hello!"));
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: messages[index],
                      user: widget.user,
                    );
                  },
                );
              },
              error: (err, stack) => ErrorView(
                message: err.toString().replaceAll('Exception: ', ''),
                onRetry: () =>
                    ref.invalidate(chatNotifierProvider(widget.user.id)),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
          if (!widget.readOnly) _buildMessageInput(),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigationBar(),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 4,
            color: Colors.black12,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              onPressed: _sendMessage,
              mini: true,
              elevation: 0,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
