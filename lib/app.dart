import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "core/theme/app_theme.dart";
import "core/router/app_router.dart";
import "core/storage/hive_service.dart";
import "features/onboarding/onboarding_page.dart";
import "features/auth/login_page.dart";
import "features/auth/providers/auth_provider.dart";

class XixinApp extends StatelessWidget {
  const XixinApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final showOnboarding = !HiveService.onboardingDone;
    final showLogin = !auth.isLoggedIn && !showOnboarding;

    if (showOnboarding) {
      return MaterialApp(
        title: "息心",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: OnboardingPage(onComplete: () {
          HiveService.onboardingDone = true;
          // Force rebuild by notifying auth
          context.read<AuthProvider>().notifyListeners();
        }),
      );
    }

    if (showLogin) {
      return MaterialApp(
        title: "息心",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginPage(),
      );
    }

    return MaterialApp(
      title: "息心",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("zh", "CN"),
        Locale("zh", "TW"),
        Locale("en", "US"),
      ],
      locale: const Locale("zh", "CN"),
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}