import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_utils.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../dictionary/presentation/widgets/word_meaning_sheet.dart';
import '../../../users/domain/entities/user_entity.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final UserEntity user;

  const MessageBubble({super.key, required this.message, required this.user});

  void _showWordMeaning(BuildContext context, String word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WordMeaningSheet(word: word),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.isSender;
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isMe
        ? AppColors.chatBubbleSender
        : AppColors.chatBubbleReceiver;
    final textColor = isMe ? Colors.white : Colors.black87;

    // Split text into words and punctuation
    final List<String> words = message.text.split(' ');

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) ...[
              CircleAvatar(
                radius: 14,
                backgroundColor: Color(user.avatarColor),
                child: Text(
                  user.name.initials,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                    bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                  ),
                ),
                child: Wrap(
                  children: words.map((word) {
                    return GestureDetector(
                      onLongPress: () => _showWordMeaning(context, word),
                      onTap: () => _showWordMeaning(context, word),
                      child: Text(
                        '$word ',
                        style: GoogleFonts.outfit(
                          color: textColor,
                          fontSize: 15,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            message.timestamp.toTimeString(),
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
          ),
        ),
      ],
    );
  }
}
