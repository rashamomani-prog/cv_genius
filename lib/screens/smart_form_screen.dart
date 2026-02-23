import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/cv_provider.dart';
import '../models/user_model.dart'; // تأكدي من عمل الـ Import للموديل
import 'final_preview_screen.dart';

class SmartFormScreen extends StatefulWidget {
  const SmartFormScreen({super.key});

  @override
  State<SmartFormScreen> createState() => _SmartFormScreenState();
}

class _SmartFormScreenState extends State<SmartFormScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final linkedin = TextEditingController();
  final birthDate = TextEditingController();
  final jobTitle = TextEditingController();

  List<String> selectedSkills = [];
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    const kColor = Color(0xFF1A237E);
    return Scaffold(
      appBar: AppBar(title: const Text("النموذج السمارت (AI)"), backgroundColor: kColor, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? const Icon(Icons.add_a_photo, size: 40, color: kColor) : null,
              ),
            ),
            const SizedBox(height: 20),
            _buildField("الاسم الكامل", name, Icons.person, kColor),
            _buildField("المسمى الوظيفي (للحصول على مقترحات)", jobTitle, Icons.work, kColor, onChanged: (v) => setState(() {})),
            _buildField("رقم الهاتف", phone, Icons.phone, kColor),
            _buildField("مكان السكن", address, Icons.location_on, kColor),
            _buildField("البريد الإلكتروني", email, Icons.email, kColor),
            _buildField("حساب LinkedIn", linkedin, Icons.link, kColor),
            _buildField("تاريخ الميلاد", birthDate, Icons.cake, kColor),

            const Divider(height: 40),
            const Text("مقترحات ذكية لمهاراتك:", style: TextStyle(fontWeight: FontWeight.bold, color: kColor)),
            const SizedBox(height: 10),
            _buildAISuggestions(jobTitle.text),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kColor,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () async {
                final provider = Provider.of<CVProvider>(context, listen: false);
                String imageUrl = "";

                try {
                  // 1. رفع الصورة لـ Storage إذا وجدت
                  if (_image != null) {
                    imageUrl = await provider.uploadProfileImage(_image!);
                  }

                  // 2. إنشاء كائن UserModel (هنا حل المشكلة)
                  final smartUser = UserModel(
                    fullName: name.text,
                    email: email.text,
                    phone: phone.text,
                    address: address.text,
                    jobTitle: jobTitle.text,
                    linkedin: linkedin.text,
                    birthDate: birthDate.text,
                    profileImage: imageUrl,
                    smartSkills: selectedSkills, // المهارات اللي اخترناها من الـ AI
                    isSmart: true,
                  );

                  // 3. الحفظ في Firestore بباراميتر واحد فقط
                  await provider.saveCVData(smartUser);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم حفظ النموذج السمارت بنجاح!")));

                  // 4. الانتقال للمعاينة
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FinalPreviewScreen()));

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ: $e")));
                }
              },
              child: const Text("حفظ ومعاينة السيرة الذاتية", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAISuggestions(String title) {
    Map<String, List<String>> aiData = {
      "مطور": ["Flutter", "Dart", "Firebase", "Git", "Clean Architecture"],
      "مصمم": ["UI/UX", "Adobe XD", "Figma", "Photoshop", "Typography"],
      "محاسب": ["Excel", "Financial Analysis", "QuickBooks", "Taxation"],
    };

    List<String> suggestions = [];
    aiData.forEach((key, value) {
      if (title.contains(key)) suggestions = value;
    });

    if (suggestions.isEmpty) return const Text("ابدأ بكتابة مسمى وظيفي لرؤية المقترحات", style: TextStyle(fontSize: 12, color: Colors.grey));

    return Wrap(
      spacing: 8,
      children: suggestions.map((skill) {
        bool isAdded = selectedSkills.contains(skill);
        return ActionChip(
          label: Text(skill),
          backgroundColor: isAdded ? Colors.green[100] : Colors.white,
          onPressed: () => setState(() => isAdded ? selectedSkills.remove(skill) : selectedSkills.add(skill)),
        );
      }).toList(),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, Color color, {Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: color),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}