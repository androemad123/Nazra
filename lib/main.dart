import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nazra/app/nazra_app.dart';
import 'package:nazra/app/providers/language_provider.dart';
import 'package:nazra/app/providers/theme_provider.dart';
import 'package:nazra/routing/app_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: NazraApp(appRouter: AppRouter()),
    ),
  );
}

