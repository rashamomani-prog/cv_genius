import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'providers/cv_provider.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  void setLanguage(String langCode) {
    _locale = Locale(langCode);
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CVProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const CVGeniusApp(),
    ),
  );
}

class CVGeniusApp extends StatelessWidget {
  const CVGeniusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        return MaterialApp(
          title: 'CV Genius',
          debugShowCheckedModeBanner: false,
          locale: langProvider.locale,
          supportedLocales: const [
            Locale('ar', ''),
            Locale('en', ''),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          theme: ThemeData(
            primaryColor: const Color(0xFFAD1457),
            scaffoldBackgroundColor: const Color(0xFFFAF9F6),
            fontFamily: langProvider.locale.languageCode == 'ar' ? 'Cairo' : 'Roboto',
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}