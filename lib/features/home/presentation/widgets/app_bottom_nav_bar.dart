import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/home_index_provider.dart';

class AppBottomNavigationBar extends ConsumerWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeIndexProvider);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        ref.read(homeIndexProvider.notifier).setIndex(index);
        // If we can pop (i.e., we are in ChatScreen), go back to MainScreen
        if (Navigator.canPop(context)) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer_outlined),
          label: "Offers",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: "Settings",
        ),
      ],
    );
  }
}
