import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/counter.dart';
import 'pages/gallery.dart';
import 'pages/home.dart';

import 'generated/l10n.dart';
import 'pages/vibrationStore/main.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: 'Vibration',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme ??
              ColorScheme.fromSwatch(
                  primarySwatch: Colors.pink, brightness: Brightness.light),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme ??
              ColorScheme.fromSwatch(
                  primarySwatch: Colors.pink, brightness: Brightness.dark),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/counter': (context) => const CounterPage(),
          '/store': (context) => const VibrationStore(),
          '/gallery': (context) => const PatternGalleryPage(),
        },
      );
    });
  }
}
