import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/cv_provider.dart';

class FinalPreviewScreen extends StatelessWidget {
  const FinalPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CVProvider>(context, listen: false);
    const kNavy = Color(0xFF1A237E);
    const kBeige = Color(0xFFF5F5DC);

    return Scaffold(
      backgroundColor: kBeige,
      appBar: AppBar(
        title: const Text("معاينة السيرة الذاتية"),
        backgroundColor: kNavy,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // كبسة المشاركة (ممكن برمجتها لاحقاً)
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("جاري تحضير ملف الـ PDF...")));
            },
          )
        ],
      ),
      // استخدمنا StreamBuilder عشان الكبسات تكون شغالة وتجيب البيانات فوراً
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(provider.isSimple ? 'simple_cvs' : 'smart_cvs')
            .doc(provider.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kNavy));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("لا توجد بيانات محفوظة بعد."));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // إذا كان سمارت، بنعرض الصورة الشخصية
                if (data['profileImage'] != null && data['profileImage'] != "")
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(data['profileImage']),
                    backgroundColor: Colors.white,
                  ),
                const SizedBox(height: 20),

                // الهيدر (الاسم والوظيفة)
                Text(
                  data['fullName'] ?? "الاسم غير موجود",
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kNavy),
                ),
                if (data['jobTitle'] != null)
                  Text(
                    data['jobTitle'],
                    style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                  ),

                const Divider(height: 40, thickness: 2, color: kNavy),

                // عرض الأقسام بشكل فخم
                _buildInfoSection("المعلومات الشخصية", [
                  _infoRow(Icons.email, data['email']),
                  _infoRow(Icons.phone, data['phone']),
                  _infoRow(Icons.location_on, data['address']),
                  if (data['linkedin'] != null) _infoRow(Icons.link, data['linkedin']),
                ]),

                if (data['summary'] != null)
                  _buildInfoSection("النبذة التعريفية", [
                    Text(data['summary'], style: const TextStyle(height: 1.5)),
                  ]),

                if (data['skills'] != null)
                  _buildInfoSection("المهارات", [
                    // عرض المهارات اللي اخترناها من الـ AI على شكل Chips
                    Wrap(
                      spacing: 8,
                      children: (data['skills'] as List).map((s) => Chip(
                        label: Text(s.toString()),
                        backgroundColor: kNavy.withOpacity(0.1),
                      )).toList(),
                    ),
                  ]),

                _buildInfoSection("المسار الأكاديمي والمهني", [
                  Text(data['education'] ?? data['experience'] ?? "لا توجد تفاصيل"),
                ]),

                const SizedBox(height: 30),

                // كبسة "تعديل" عشان المستخدم يرجع يعدل بياناته
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNavy,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text("تعديل البيانات", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String? text) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}