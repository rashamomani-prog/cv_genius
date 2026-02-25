import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/cv_provider.dart';
import '../models/user_model.dart';
import 'final_preview_screen.dart';
import '../main.dart';

class SmartFormScreen extends StatefulWidget {
  const SmartFormScreen({super.key});

  @override
  State<SmartFormScreen> createState() => _SmartFormScreenState();
}

class _SmartFormScreenState extends State<SmartFormScreen> {
  final nameController = TextEditingController();
  final jobTitleController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final educationController= TextEditingController();
  final linkedinController = TextEditingController();
  final birthdayController = TextEditingController();
  final languagesController = TextEditingController();
  final skillsController = TextEditingController();
  final experienceController = TextEditingController();
  final summaryController = TextEditingController();

  File? _selectedImage;
  bool _isProcessing = false;
  final List<String> _suggestedSkills = [
    "Communication", "Leadership", "Teamwork",
    "Problem Solving", "Time Management", "Creativity", "Technical Skills"
  ];
  final List<String> _suggestedLanguages = [
    "Arabic", "English", "French", "Spanish", "German", "Turkish"
  ];

  List<String> _selectedSkillsList = [];
  List<String> _selectedLanguagesList = [];

  final Color kOffWhite = const Color(0xFFFAF9F6);
  final Color kSoftPink = const Color(0xFFF8BBD0);
  final Color kDustyRose = const Color(0xFFAD1457);

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    bool isArabic = langProvider.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFAD1457)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isArabic ? "بيانات النموذج الذكي" : "Smart Form Data",
          style: TextStyle(color: kDustyRose, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kOffWhite,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => langProvider.setLanguage(isArabic ? 'en' : 'ar'),
          ),
        ],
      ),
      body: _isProcessing
          ? Center(child: CircularProgressIndicator(color: kDustyRose))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            _buildField(isArabic ? "الاسم الكامل" : "Full Name", nameController, Icons.person_outline, isArabic),
            _buildField(isArabic ? "المسمى الوظيفي" : "Job Title", jobTitleController, Icons.work_outline, isArabic),
            _buildField(isArabic ? "البريد الإلكتروني" : "Email Address", emailController, Icons.alternate_email, isArabic),
            _buildField(isArabic ? "رقم الهاتف" : "Phone Number", phoneController, Icons.phone_android, isArabic),

            const Divider(height: 40),

            _buildQuizSection(
              title: isArabic ? "ما هي لغاتك؟ 🌍" : "What are your languages? 🌍",
              suggestions: _suggestedLanguages,
              selectedList: _selectedLanguagesList,
              controller: languagesController,
              isArabic: isArabic,
            ),
            _buildField(isArabic ? "اللغات المختارة" : "Selected Languages", languagesController, Icons.translate, isArabic),

            const SizedBox(height: 20),
            _buildQuizSection(
              title: isArabic ? "اختر مهاراتك بسرعة 💡" : "Quickly pick your skills 💡",
              suggestions: _suggestedSkills,
              selectedList: _selectedSkillsList,
              controller: skillsController,
              isArabic: isArabic,
            ),
            _buildField(isArabic ? "المهارات المختارة" : "Selected Skills", skillsController, Icons.star_outline, isArabic),

            const Divider(height: 40),
            _buildField(isArabic ? "العنوان" : "Address", addressController, Icons.location_on_outlined, isArabic),
            _buildField(isArabic ? "التعليم" : "Education", educationController, Icons.school_outlined, isArabic),
            _buildField(isArabic ? "رابط LinkedIn" : "LinkedIn Link", linkedinController, Icons.link, isArabic),
            _buildField(isArabic ? "تاريخ الميلاد" : "Date of Birth", birthdayController, Icons.cake_outlined, isArabic),
            _buildField(isArabic ? "الخبرات" : "Experience", experienceController, Icons.history, isArabic, maxLines: 3),
            _buildField(isArabic ? "نبذة تعريفية" : "Professional Summary", summaryController, Icons.description_outlined, isArabic, maxLines: 3),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDustyRose,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () => _saveAndNavigate(isArabic),
              child: Text(
                isArabic ? "حفظ ومعاينة الـ CV ✨" : "Save & Preview CV ✨",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildQuizSection({
    required String title,
    required List<String> suggestions,
    required List<String> selectedList,
    required TextEditingController controller,
    required bool isArabic,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: kDustyRose, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: suggestions.map((item) {
            final isSelected = selectedList.contains(item);
            return FilterChip(
              label: Text(item, style: TextStyle(color: isSelected ? Colors.white : kDustyRose, fontSize: 12)),
              selected: isSelected,
              selectedColor: kDustyRose,
              checkmarkColor: Colors.white,
              backgroundColor: kSoftPink.withOpacity(0.2),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedList.add(item);
                  } else {
                    selectedList.remove(item);
                  }
                  controller.text = selectedList.join(', ');
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Future<void> _saveAndNavigate(bool isArabic) async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? "الرجاء كتابة الاسم" : "Please enter your name")),
      );
      return;
    }
    setState(() => _isProcessing = true);
    try {
      final provider = Provider.of<CVProvider>(context, listen: false);
      String imageUrl = "";
      if (_selectedImage != null) imageUrl = await provider.uploadProfileImage(_selectedImage!);

      final newUser = UserModel(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        jobTitle: jobTitleController.text.trim(),
        education: educationController.text,
        linkedin: linkedinController.text.trim(),
        birthDate: birthdayController.text.trim(),
        languages: languagesController.text.trim(),
        skills: skillsController.text.trim(),
        experience: experienceController.text.trim(),
        summary: summaryController.text.trim(),
        profileImage: imageUrl,
        isSmart: true,
      );

      await provider.saveCVData(newUser);
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FinalPreviewScreen(isSimple: false)));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }


  Widget _buildField(String label, TextEditingController controller, IconData icon, bool isArabic, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: kDustyRose, size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: kSoftPink.withOpacity(0.5))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: kDustyRose)),
        ),
      ),
    );
  }
}