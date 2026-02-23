import 'package:cv_genius/screens/simple_form_screen.dart';
import 'package:cv_genius/screens/template_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // دالة تسجيل الدخول
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // إذا نجح الدخول، ننتقل للشاشة التالية (مثلاً HomeScreen)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تسجيل الدخول بنجاح!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TemplateSelectionScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = 'حدث خطأ ما';
        if (e.code == 'user-not-found') message = 'المستخدم غير موجود';
        else if (e.code == 'wrong-password') message = 'كلمة المرور خاطئة';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الخلفية بيج كما طلبنا
      backgroundColor: const Color(0xFFF5F5DC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // لوجو أو أيقونة التطبيق
                const Icon(Icons.auto_awesome, size: 80, color: Color(0xFF1A237E)),
                const SizedBox(height: 10),
                const Text(
                  "CV Genius",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 40),

                // حقل البريد الإلكتروني
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "البريد الإلكتروني",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value!.isEmpty ? "أدخل البريد الإلكتروني" : null,
                ),
                const SizedBox(height: 20),

                // حقل كلمة المرور
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "كلمة المرور",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value!.length < 6 ? "كلمة المرور ضعيفة" : null,
                ),
                const SizedBox(height: 30),

                // زر الدخول (كحلي)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("تسجيل الدخول", style: TextStyle(fontSize: 18)),
                  ),
                ),

                const SizedBox(height: 15),

                // زر إنشاء حساب (اختياري)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    "ليس لديك حساب؟ سجل الآن",
                    style: TextStyle(color: Color(0xFF1A237E)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}