import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:provider/provider.dart";
import "app.dart";
import "core/storage/hive_service.dart";
import "core/notification/notification_service.dart";
import "core/payment/payment_provider.dart";
import "features/meditation/providers/meditation_provider.dart";
import "features/breathing/providers/breathing_provider.dart";
import "features/home/providers/home_provider.dart";
import "features/profile/providers/profile_provider.dart";
import "features/auth/providers/auth_provider.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveService.init();
  await NotificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MeditationProvider()),
        ChangeNotifierProvider(create: (_) => BreathingProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: const XixinApp(),
    ),
  );
}