import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cv_provider.dart';
import '../models/user_model.dart';
import 'final_preview_screen.dart';

class SimpleFormScreen extends StatefulWidget {
  const SimpleFormScreen({super.key});

  @override
  State<SimpleFormScreen> createState() => _SimpleFormScreenState();
}

class _SimpleFormScreenState extends State<SimpleFormScreen> {
  // الكنترولرز للحقول
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final educationController = TextEditingController();
  final addressController = TextEditingController();
  final skillsController = TextEditingController();
  final experienceController = TextEditingController();
  final summaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const kColor = Color(0xFF1A237E); // الكحلي

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // الخلفية البيج
      appBar: AppBar(
        title: const Text("النموذج البسيط"),
        backgroundColor: kColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildField("الاسم الكامل", nameController, Icons.person, kColor),
            _buildField("البريد الإلكتروني", emailController, Icons.email, kColor),
            _buildField("رقم الهاتف", phoneController, Icons.phone, kColor),
            _buildField("مكان السكن", addressController, Icons.location_city, kColor),
            _buildField("التعليم", educationController, Icons.school, kColor),
            _buildField("المهارات", skillsController, Icons.star, kColor),
            _buildField("الخبرات", experienceController, Icons.work, kColor, maxLines: 3),
            _buildField("نبذة بسيطة", summaryController, Icons.info, kColor, maxLines: 3),

            const SizedBox(height: 30),

            // الكبسة بعد التعديل والتنظيف
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kColor,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                // 1. إنشاء كائن البيانات
                final newUser = UserModel(
                  fullName: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  address: addressController.text,
                  education: educationController.text,
                  skills: skillsController.text,
                  experience: experienceController.text,
                  summary: summaryController.text,
                  isSmart: false,
                );

                try {
                  // 2. حفظ البيانات في السيرفر عبر الـ Provider
                  await Provider.of<CVProvider>(context, listen: false).saveCVData(newUser);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("تم حفظ البيانات بنجاح!")),
                    );

                    // 3. الانتقال لصفحة المعاينة
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FinalPreviewScreen()),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("حدث خطأ أثناء الحفظ: $e")),
                    );
                  }
                }
              },
              child: const Text(
                "حفظ ومعاينة السيرة الذاتية",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, Color color, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: color),
          prefixIcon: Icon(icon, color: color),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: color, width: 2),
          ),
        ),
      ),
    );
  }
}