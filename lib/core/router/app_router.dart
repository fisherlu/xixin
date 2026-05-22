import "package:flutter/material.dart";
import "../../features/home/home_page.dart";
import "../../features/meditation/meditation_player_page.dart";
import "../../features/meditation/meditation_list_page.dart";
import "../../features/breathing/breathing_page.dart";
import "../../features/sleep/sleep_page.dart";
import "../../features/sleep/sleep_player_page.dart";
import "../../features/profile/profile_page.dart";

class AppRouter {
  AppRouter._();

  static const String home = "/";
  static const String meditationPlayer = "/meditation/player";
  static const String meditationList = "/meditation/list";
  static const String breathing = "/breathing";
  static const String sleep = "/sleep";
  static const String sleepPlayer = "/sleep/player";
  static const String profile = "/profile";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case home:
        return _buildRoute(const HomePage(), settings);
      case meditationPlayer:
        return _buildRoute(const MeditationPlayerPage(), settings);
      case meditationList:
        final category = args as String? ?? "";
        return _buildRoute(MeditationListPage(category: category), settings);
      case breathing:
        return _buildRoute(const BreathingPage(), settings);
      case sleep:
        return _buildRoute(const SleepPage(), settings);
      case sleepPlayer:
        return _buildRoute(const SleepPlayerPage(), settings);
      case profile:
        return _buildRoute(const ProfilePage(), settings);
      default:
        return _buildRoute(const HomePage(), settings);
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
