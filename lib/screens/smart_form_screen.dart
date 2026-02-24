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
  final linkedinController = TextEditingController();
  final birthdayController = TextEditingController();
  final languagesController = TextEditingController();
  final skillsController = TextEditingController();
  final experienceController = TextEditingController();
  final summaryController = TextEditingController();

  File? _selectedImage;
  bool _isProcessing = false;

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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          isArabic ? "بيانات النموذج الذكي" : "Smart Form Data",
          style: TextStyle(color: kDustyRose, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kOffWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: kDustyRose),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              langProvider.setLanguage(isArabic ? 'en' : 'ar');
            },
          ),
        ],
      ),
      body: _isProcessing
          ? Center(child: CircularProgressIndicator(color: kDustyRose))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            _buildImagePicker(isArabic),
            const SizedBox(height: 30),
            _buildField(isArabic ? "الاسم الكامل" : "Full Name", nameController, Icons.person_outline, isArabic),
            _buildField(isArabic ? "المسمى الوظيفي" : "Job Title", jobTitleController, Icons.work_outline, isArabic),
            _buildField(isArabic ? "البريد الإلكتروني" : "Email Address", emailController, Icons.alternate_email, isArabic),
            _buildField(isArabic ? "رقم الهاتف" : "Phone Number", phoneController, Icons.phone_android, isArabic),
            _buildField(isArabic ? "العنوان" : "Address", addressController, Icons.location_on_outlined, isArabic),
            _buildField(isArabic ? "رابط LinkedIn" : "LinkedIn Link", linkedinController, Icons.link, isArabic),
            _buildField(isArabic ? "تاريخ الميلاد" : "Date of Birth", birthdayController, Icons.cake_outlined, isArabic),
            _buildField(isArabic ? "اللغات" : "Languages", languagesController, Icons.translate, isArabic),
            _buildField(isArabic ? "المهارات (افصلي بفاصلة)" : "Skills (comma separated)", skillsController, Icons.star_outline, isArabic),
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

      if (_selectedImage != null) {
        imageUrl = await provider.uploadProfileImage(_selectedImage!);
      }

      final newUser = UserModel(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        jobTitle: jobTitleController.text.trim(),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FinalPreviewScreen(isSimple: false),
          ),
        );
      }
    } catch (e) {
      print("Error in SmartForm: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isArabic ? "خطأ في الحفظ: ${e.toString()}" : "Save Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Widget _buildImagePicker(bool isArabic) {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
        );
        if (pickedFile != null) {
          setState(() => _selectedImage = File(pickedFile.path));
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: kSoftPink.withOpacity(0.3),
            backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
            child: _selectedImage == null ? Icon(Icons.add_a_photo, size: 40, color: kDustyRose) : null,
          ),
          const SizedBox(height: 8),
          Text(
            isArabic ? "أضف صورتك الحلوة" : "Add your sweet picture",
            style: TextStyle(color: kDustyRose, fontSize: 12),
          )
        ],
      ),
    );
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
          prefixIcon: Icon(icon, color: kDustyRose),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: kSoftPink.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: kDustyRose),
          ),
        ),
      ),
    );
  }
}