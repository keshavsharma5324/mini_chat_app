import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../utils/app_utils.dart';
import '../providers/word_meaning_notifier.dart';

class WordMeaningSheet extends ConsumerWidget {
  final String word;

  const WordMeaningSheet({super.key, required this.word});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sanitize word (remove punctuation)
    final sanitizedWord = word.sanitized;
    final meaningAsync = ref.watch(wordMeaningNotifierProvider(sanitizedWord));

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sanitizedWord,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 8),
          meaningAsync.when(
            data: (meaning) {
              if (meaning == null) return const Text("Something went wrong.");
              return Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (meaning.phonetic.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            meaning.phonetic,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      const Text(
                        "Definitions:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...meaning.definitions
                          .take(3)
                          .map(
                            (def) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "• ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(child: Text(def)),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, stack) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ErrorView(
                message: err.toString().replaceAll('Exception: ', ''),
                onRetry: () =>
                    ref.invalidate(wordMeaningNotifierProvider(sanitizedWord)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
