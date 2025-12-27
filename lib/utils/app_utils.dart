import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import 'dart:math';

// --- String Extensions ---
extension StringExtensions on String {
  String toCapitalized() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get initials {
    if (isEmpty) return '?';
    final parts = trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return this[0].toUpperCase();
  }

  String get sanitized => replaceAll(RegExp(r'[^\w\s]'), '');
}

// --- Date Extensions ---
extension DateExtensions on DateTime {
  String toTimeString() {
    return DateFormat.jm().format(this);
  }

  String toDateString() {
    return DateFormat.yMMMd().format(this);
  }

  bool isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  String toRelativeString() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inMinutes < 1) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24 && isToday()) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else {
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      if (day == yesterday.day &&
          month == yesterday.month &&
          year == yesterday.year) {
        return "Yesterday";
      }
      if (difference.inDays < 7) {
        return "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
      }
      return toDateString();
    }
  }
}

// --- Context Extensions ---
extension ContextExtensions on BuildContext {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

// --- UI Utils ---
class UiUtils {
  static Color getRandomAvatarColor() {
    final List<Color> colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      Colors.green,
      Colors.orange,
      Colors.teal,
      Colors.purple,
      Colors.indigo,
    ];
    return colors[Random().nextInt(colors.length)];
  }
}
