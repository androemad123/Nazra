import 'package:flutter/material.dart';
import 'package:nazra/app/providers/language_provider.dart';
import 'package:nazra/app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AppContext {
  final BuildContext context;

  AppContext(this.context);

  ThemeProvider get theme => Provider.of<ThemeProvider>(context, listen: false);
  LanguageProvider get lang => Provider.of<LanguageProvider>(context, listen: false);

  /// Toggles between dark and light theme
  void toggleTheme() {
    if (theme.isDarkMode) {
      theme.setTheme(ThemeMode.light);
    } else {
      theme.setTheme(ThemeMode.dark);
    }
  }

  /// Toggles between English and Arabic
  void toggleLanguage() {
    if (lang.locale.languageCode == 'en') {
      lang.setLocale(const Locale('ar'));
    } else {
      lang.setLocale(const Locale('en'));
    }
  }
}
