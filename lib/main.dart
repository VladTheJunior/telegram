import 'package:flutter/material.dart';
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart' as tg;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart';
import 'package:telegram_app/home_view.dart';

void main() {
  runApp(MyApp());
}

// user below method to update theme mode
void updateThemeMode() {
  _notifier.value = tg.isDarkMode ? ThemeMode.dark : ThemeMode.light;
}

final ValueNotifier<ThemeMode> _notifier =
    ValueNotifier(tg.isDarkMode ? ThemeMode.dark : ThemeMode.light);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: "Telegram Web JS",
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [
            Locale('ru', 'RU'),
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              )),
          darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              )),
          themeMode: mode,
          home: const HomeView(),
        );
      },
    );
  }
}
