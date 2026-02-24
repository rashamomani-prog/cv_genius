import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('ar'); // اللغة الافتراضية عربي

  Locale get currentLocale => _currentLocale;

  void changeLanguage(String langCode) {
    _currentLocale = Locale(langCode);
    notifyListeners(); // هاد السطر هو اللي بغير اللغة في كل التطبيق فوراً
  }
}