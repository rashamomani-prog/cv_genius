import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'register_screen.dart';
import 'template_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  final Color kMainPink = const Color(0xFFC2185B);
  final Color kBgLight = const Color(0xFFFDF7F9);

  Future<void> _signIn(bool isArabic) async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? "الرجاء إدخال البيانات" : "Please enter data")),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TemplateSelectionScreen()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isArabic ? "خطأ في الدخول" : "Login error"))
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    bool isArabic = langProvider.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: kBgLight,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 380,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF8BBD0), Color(0xFFFDF7F9)],
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome, size: 80, color: kMainPink),
                      const SizedBox(height: 20),
                      Text("CV Builder", style: TextStyle(fontSize: 28, color: kMainPink, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 15),
                      Text(isArabic ? "جاهز لتبدأ رحلتك المهنية؟" : "Ready to start?", style: TextStyle(fontSize: 16, color: kMainPink)),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        decoration: InputDecoration(
                          hintText: isArabic ? "البريد الإلكتروني" : "Email Address",
                          suffixIcon: Icon(Icons.alternate_email, color: kMainPink.withOpacity(0.5)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        decoration: InputDecoration(
                          hintText: isArabic ? "كلمة المرور" : "Password",
                          suffixIcon: Icon(Icons.lock_outline, color: kMainPink.withOpacity(0.5)),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _isLoading
                          ? CircularProgressIndicator(color: kMainPink)
                          : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kMainPink,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () => _signIn(isArabic),
                        child: Text(isArabic ? "دخول" : "Login", style: const TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                        child: Text(isArabic ? "إنشاء حساب جديد" : "Register Now", style: TextStyle(color: kMainPink, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.language, color: Color(0xFFC2185B)),
    onPressed: () {
    (langProvider as dynamic).changeLanguage(isArabic ? 'en' : 'ar');
    },
            ),
          ),
          ),
        ],
      ),
    );
  }
}