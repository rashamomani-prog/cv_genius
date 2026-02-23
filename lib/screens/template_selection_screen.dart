import 'package:flutter/material.dart';
import 'simple_form_screen.dart';
import 'smart_form_screen.dart'; // سننشئها لاحقاً

class TemplateSelectionScreen extends StatelessWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // بيج
      appBar: AppBar(
        title: const Text("اختر نوع النموذج"),
        backgroundColor: const Color(0xFF1A237E), // كحلي
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectionCard(
              context,
              title: "النموذج البسيط",
              subtitle: "للحصول على سيرة ذاتية كلاسيكية وسريعة",
              icon: Icons.article_outlined,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimpleFormScreen())),
            ),
            const SizedBox(height: 20),
            _selectionCard(
              context,
              title: "النموذج السمارت",
              subtitle: "مقترحات ذكاء اصطناعي وتصميم عصري مع صورة",
              icon: Icons.auto_awesome_outlined,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartFormScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectionCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1A237E), width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            Icon(icon, size: 50, color: const Color(0xFF1A237E)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 5),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF1A237E)),
          ],
        ),
      ),
    );
  }
}