import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/main_screen.dart';
import 'features/users/data/datasources/user_local_datasource.dart';
import 'features/chat/data/datasources/chat_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        userLocalDataSourceProvider.overrideWith(
          (ref) => UserLocalDataSourceImpl(sharedPrefs),
        ),
        chatLocalDataSourceProvider.overrideWith(
          (ref) => ChatLocalDataSourceImpl(sharedPrefs),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Chat App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
