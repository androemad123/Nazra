import 'package:flutter/material.dart';
import 'package:nazra/app/providers/language_provider.dart';
import 'package:nazra/app/providers/theme_provider.dart';
import 'package:nazra/generated/l10n.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text(S.of(context).welcome_message)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (themeProvider.isDarkMode) {
                themeProvider.setTheme(ThemeMode.light);
              } else {
                themeProvider.setTheme(ThemeMode.dark);
              }
              if (localeProvider.locale.languageCode == 'en') {
                localeProvider.setLocale(const Locale('ar'));
              } else {
                localeProvider.setLocale(const Locale('en'));
              }
            },
            child: Text(S.of(context).dummy_button_text),
          ),
        ],
      ),
    );
  }
}
