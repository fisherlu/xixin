import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "core/theme/app_theme.dart";
import "core/router/app_router.dart";
import "core/storage/hive_service.dart";
import "features/onboarding/onboarding_page.dart";

class XixinApp extends StatefulWidget {
  const XixinApp({super.key});

  @override State<XixinApp> createState() => _XixinAppState();
}

class _XixinAppState extends State<XixinApp> {
  bool _showOnboarding = false;

  @override void initState() {
    super.initState();
    _showOnboarding = !HiveService.onboardingDone;
  }

  void _completeOnboarding() {
    HiveService.onboardingDone = true;
    setState(() => _showOnboarding = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return MaterialApp(
        title: "息心",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: OnboardingPage(onComplete: _completeOnboarding),
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