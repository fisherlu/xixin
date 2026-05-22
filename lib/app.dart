import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "core/theme/app_theme.dart";
import "core/router/app_router.dart";

class XixinApp extends StatelessWidget {
  const XixinApp({super.key});

  @override
  Widget build(BuildContext context) {
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
