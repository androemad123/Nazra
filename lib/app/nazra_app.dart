import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nazra/app/providers/language_provider.dart';
import 'package:nazra/app/providers/theme_provider.dart';
import 'package:nazra/generated/l10n.dart';
import 'package:nazra/peresentation/resources/theme_manager.dart';
import 'package:nazra/routing/app_router.dart';
import 'package:nazra/routing/routes.dart';
import 'package:provider/provider.dart';

class NazraApp extends StatefulWidget {
  const NazraApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  static NazraApp? instance;
  factory NazraApp.getInstance(AppRouter appRouter) {
    instance ??= NazraApp(appRouter: appRouter);
    return instance!;
  }
  @override
  State<NazraApp> createState() => _NazraAppState();
}

class _NazraAppState extends State<NazraApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeManager.lightTheme,  // Light theme
          darkTheme: ThemeManager.darkTheme, // Dark theme
          themeMode: themeProvider.themeMode,
          locale: languageProvider.locale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.loginRoute,
          onGenerateRoute: widget.appRouter.onGenerateRoute,
        );
      },
    );
  }
}