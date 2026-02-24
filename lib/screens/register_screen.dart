import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final Color kOffWhite = const Color(0xFFFAF9F6);
  final Color kSoftPink = const Color(0xFFF8BBD0);
  final Color kDustyRose = const Color(0xFFAD1457);

  Future<void> _signUp(bool isArabic) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? "لا تنسى تعبي الحقول 🌸" : "Don't forget to fill the fields 🌸")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isArabic ? "برافووو تم إنشاء الحساب بنجاح!" : "Bravo! Account created successfully!"),
            backgroundColor: kDustyRose,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg = isArabic ? "حدث خطأ" : "An error occurred";
      if (e.code == 'weak-password') msg = isArabic ? "كلمة المرور ضعيفة" : "Weak password";
      else if (e.code == 'email-already-in-use') msg = isArabic ? "الإيميل مستخدم مسبقاً" : "Email already in use";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
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
      backgroundColor: kOffWhite,
      appBar: AppBar(
        backgroundColor: kOffWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: kDustyRose),
        actions: [
          TextButton(
            onPressed: () {
              langProvider.setLanguage(isArabic ? 'en' : 'ar');
            },
            child: Text(
              isArabic ? "English" : "العربية",
              style: TextStyle(color: kDustyRose, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Icon(Icons.person_add_outlined, size: 80, color: kSoftPink),
            const SizedBox(height: 10),
            Text(
              isArabic ? "إنشاء حساب جديد" : "Create New Account",
              style: TextStyle(fontSize: 22, color: kDustyRose, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            _buildUnderlineField(
                _nameController,
                isArabic ? "الاسم الكامل" : "Full Name",
                Icons.person_outline,
                isArabic
            ),
            const SizedBox(height: 20),
            _buildUnderlineField(
                _emailController,
                isArabic ? "البريد الإلكتروني" : "Email Address",
                Icons.alternate_email,
                isArabic
            ),
            const SizedBox(height: 20),
            _buildUnderlineField(
                _phoneController,
                isArabic ? "رقم الهاتف" : "Phone Number",
                Icons.phone_android_outlined,
                isArabic
            ),
            const SizedBox(height: 20),
            _buildUnderlineField(
                _passwordController,
                isArabic ? "كلمة المرور" : "Password",
                Icons.lock_open_outlined,
                isArabic,
                isPassword: true
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDustyRose,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                onPressed: _isLoading ? null : () => _signUp(isArabic),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                    isArabic ? "تأكيد التسجيل" : "Confirm Registration",
                    style: const TextStyle(color: Colors.white, fontSize: 18)
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUnderlineField(TextEditingController controller, String label, IconData icon, bool isArabic, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      textAlign: isArabic ? TextAlign.right : TextAlign.left,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: kDustyRose.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: kSoftPink),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kSoftPink.withOpacity(0.5))),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kDustyRose)),
      ),
    );
  }
}