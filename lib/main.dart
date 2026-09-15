import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

import 'providers/practice_provider.dart';
import 'providers/subject_provider.dart';

import 'screens/splash/splash_screen.dart';
import 'providers/theme_provider.dart';

import 'providers/language_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox("questions");
  await Hive.openBox("settings");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PracticeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SubjectProvider(),
        ),
      ],
      child: const ARankIndiaApp(),
    ),
  );
}

class ARankIndiaApp extends StatelessWidget {
  const ARankIndiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ARank India',

          locale: languageProvider.locale,

          theme: AppTheme.lightTheme,
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,

          home: const SplashScreen(),
        );
      },
    );
  }
}