import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // الملف اللي ولدناه بالـ CLI
import 'providers/cv_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // الربط الرسمي والنهائي
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => CVProvider(),
      child: const CVGeniusApp(),
    ),
  );
}

class CVGeniusApp extends StatelessWidget {
  const CVGeniusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Genius',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A237E), // كحلي
        scaffoldBackgroundColor: const Color(0xFFF5F5DC), // بيج
      ),
      home: const LoginScreen(),
    );
  }
}
