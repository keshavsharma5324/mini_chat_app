import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_index_provider.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'home_content_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeIndexProvider);

    final List<Widget> _screens = [
      const HomeContentScreen(),
      const Center(child: Text("Offers")),
      const Center(child: Text("Settings")),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: const AppBottomNavigationBar(),
    );
  }
}
