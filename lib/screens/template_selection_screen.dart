import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'smart_form_screen.dart';
import 'simple_form_screen.dart';
import '../main.dart';

class TemplateSelectionScreen extends StatelessWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    bool isArabic = langProvider.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFAD1457)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFFFAF9F6),
        elevation: 0,
        title: Text(
          isArabic ? "اختيار النموذج" : "Choose Template",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFAD1457)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Color(0xFFAD1457)),
            onPressed: () => langProvider.setLanguage(isArabic ? 'en' : 'ar'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              isArabic
                  ? "اختر التنسيق الذي يناسب شخصيتك المهنية"
                  : "Select the layout that fits your professional persona",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 30),
            _buildSelectionCard(
              context,
              isArabic: isArabic,
              title: isArabic ? "النموذج الكلاسيكي" : "Classic Template",
              subtitle: isArabic ? "بسيط، رسمي ومباشر" : "Simple, formal, and direct",
              icon: Icons.article_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SimpleFormScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildSelectionCard(
              context,
              isArabic: isArabic,
              title: isArabic ? "النموذج الذكي الحديث" : "Modern Smart Template",
              subtitle: isArabic ? "مع صورة شخصية وتنسيق عصري" : "With profile picture and modern layout",
              icon: Icons.auto_awesome_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SmartFormScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required bool isArabic,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFAD1457).withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 8)
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFFF8BBD0).withOpacity(0.3),
              child: Icon(icon, color: const Color(0xFFAD1457), size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF2D3142))
                  ),
                  const SizedBox(height: 4),
                  Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500)
                  ),
                ],
              ),
            ),
            Icon(
                isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                size: 16,
                color: const Color(0xFFAD1457).withOpacity(0.5)
            ),
          ],
        ),
      ),
    );
  }
}