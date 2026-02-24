import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cv_provider.dart';
import '../main.dart';
import '../services/pdf_service.dart';

class FinalPreviewScreen extends StatelessWidget {
  final bool isSimple;

  const FinalPreviewScreen({super.key, required this.isSimple});

  final Color kOffWhite = const Color(0xFFFAF9F6);
  final Color kSoftPink = const Color(0xFFF8BBD0);
  final Color kDustyRose = const Color(0xFFAD1457);

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    bool isArabic = langProvider.locale.languageCode == 'ar';

    return Consumer<CVProvider>(
      builder: (context, cvProvider, child) {
        final cvData = cvProvider.userCV;

        if (cvData == null) {
          return Scaffold(
            backgroundColor: kOffWhite,
            body: Center(
              child: Text(isArabic ? "لا توجد بيانات" : "No data found"),
            ),
          );
        }

        return Scaffold(
          backgroundColor: kOffWhite,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFAD1457)), // نفس لون الـ Dusty Rose
              onPressed: () {
                Navigator.pop(context); // هاي اللي بترجعك للصفحة اللي قبلها
              },
            ),
            title: Text(
              isSimple
                  ? (isArabic ? "النموذج الكلاسيكي" : "Classic Template")
                  : (isArabic ? "النموذج الذكي الحديث" : "Modern Smart Template"),
              style: TextStyle(color: kDustyRose, fontWeight: FontWeight.bold),
            ),
            backgroundColor: kOffWhite,
            elevation: 0,
            iconTheme: IconThemeData(color: kDustyRose),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: kDustyRose,
            onPressed: () async {
              print("Share button clicked!"); // عشان نتأكد إن الكبسة بتنضغط أصلاً
              try {
                if (cvProvider.userCV != null) {
                  await PdfService.generateAndShareResume(cvProvider.userCV!, isArabic);
                } else {
                  print("CV Data is NULL!");
                }
              } catch (e) {
                print("PDF ERROR: $e"); // هون رح يطبع لك ليش مش راضي يفتح الـ Share
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            label: Text(isArabic ? "تحميل PDF" : "Download PDF"),
            icon: const Icon(Icons.share),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: isSimple
                ? _buildSimpleLayout(cvData, isArabic)
                : _buildSmartModernLayout(cvData, isArabic),
          ),
        );
      },
    );
  }

  Widget _buildSimpleLayout(cvData, bool isArabic) {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildBasicHeader(cvData),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(isArabic ? "المعلومات الشخصية" : "Personal Information", Icons.person_outline),
                _buildInfoRow(Icons.email_outlined, cvData.email),
                _buildInfoRow(Icons.phone_android_outlined, cvData.phone),
                const Divider(height: 30),
                _buildSectionTitle(isArabic ? "النبذة" : "Summary", Icons.work_outline),
                Text(cvData.summary ?? "", textAlign: isArabic ? TextAlign.right : TextAlign.left),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- التعديل هنا في دالة النموذج الذكي ---
  Widget _buildSmartModernLayout(cvData, bool isArabic) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [kDustyRose, const Color(0xFF6A0D34)]),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row( // تغيير إلى Row ليصبح الاسم بجانب الصورة
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. دائرة الصورة
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: (cvData.profileImage != null && cvData.profileImage!.startsWith('http'))
                    ? NetworkImage(cvData.profileImage!)
                    : null,
                child: (cvData.profileImage == null || !cvData.profileImage!.startsWith('http'))
                    ? Icon(Icons.person, size: 45, color: kDustyRose)
                    : null,
              ),
              const SizedBox(width: 20),
              // 2. النصوص (الاسم والمسمى) داخل Expanded لمنع العجقة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cvData.fullName ?? "",
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      cvData.jobTitle ?? "",
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildCard(
          title: isArabic ? "المهارات" : "Skills",
          icon: Icons.bolt,
          child: Column(
            children: (cvData.skills ?? "")
                .split(',')
                .map<Widget>((s) => _buildSkillBar(s.trim()))
                .toList(),
          ),
        ),
      ],
    );
  }

  // دوال الـ Decoration والـ Helpers
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: kSoftPink.withOpacity(0.1),
          blurRadius: 15,
          offset: const Offset(0, 5),
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: kDustyRose, size: 22),
        const SizedBox(width: 10),
        Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: kDustyRose)),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: kSoftPink),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title, icon),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildSkillBar(String skill) {
    if (skill.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(skill, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: 0.8,
            backgroundColor: kSoftPink.withOpacity(0.2),
            color: kDustyRose,
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicHeader(cvData) {
    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(
        color: kSoftPink.withOpacity(0.2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Text(
        cvData.fullName,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kDustyRose),
      ),
    );
  }
}