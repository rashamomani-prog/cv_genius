import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cv_provider.dart';
import '../models/user_model.dart';
import 'final_preview_screen.dart';
import '../main.dart';

class SimpleFormScreen extends StatefulWidget {
  const SimpleFormScreen({super.key});

  @override
  State<SimpleFormScreen> createState() => _SimpleFormScreenState();
}

class _SimpleFormScreenState extends State<SimpleFormScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final educationController = TextEditingController();
  final addressController = TextEditingController();
  final skillsController = TextEditingController();
  final experienceController = TextEditingController();
  final summaryController = TextEditingController();

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
          isArabic ? "النموذج البسيط" : "Simple Form",
          style: TextStyle(color: kDustyRose, fontWeight: FontWeight.w300),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? "المعلومات الشخصية ✨" : "Personal Information ✨",
              style: TextStyle(fontSize: 18, color: kDustyRose, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildField(isArabic ? "الاسم الكامل" : "Full Name", nameController, Icons.person_outline, isArabic),
            _buildField(isArabic ? "البريد الإلكتروني" : "Email Address", emailController, Icons.alternate_email, isArabic),
            _buildField(isArabic ? "رقم الهاتف" : "Phone Number", phoneController, Icons.phone_android_outlined, isArabic),
            _buildField(isArabic ? "مكان السكن" : "Address", addressController, Icons.location_on_outlined, isArabic),

            const SizedBox(height: 20),
            Text(
              isArabic ? "المؤهلات والخبرات 📚" : "Qualifications & Experience 📚",
              style: TextStyle(fontSize: 18, color: kDustyRose, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildField(isArabic ? "التعليم" : "Education", educationController, Icons.school_outlined, isArabic),
            _buildField(isArabic ? "المهارات" : "Skills", skillsController, Icons.star_border, isArabic),
            _buildField(isArabic ? "الخبرات" : "Experience", experienceController, Icons.work_outline, isArabic, maxLines: 3),
            _buildField(isArabic ? "نبذة بسيطة" : "Summary", summaryController, Icons.info_outline, isArabic, maxLines: 3),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDustyRose,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              onPressed: () async {
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
                  await Provider.of<CVProvider>(context, listen: false).saveCVData(newUser);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isArabic ? "تم حفظ البيانات بنجاح!" : "Data saved successfully!"),
                        backgroundColor: kDustyRose,
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FinalPreviewScreen(isSimple: true),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isArabic ? "حدث خطأ أثناء الحفظ" : "Error during save"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                isArabic ? "حفظ ومعاينة السيرة الذاتية ✨" : "Save & Preview CV ✨",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
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
          labelStyle: TextStyle(color: kDustyRose.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: kSoftPink),
          filled: true,
          fillColor: Colors.white.withOpacity(0.5),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kSoftPink.withOpacity(0.5)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kDustyRose, width: 2),
          ),
        ),
      ),
    );
  }
}