import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class PdfService {
  static final PdfColor kDustyRose = PdfColor.fromInt(0xFFAD1457);
  static final PdfColor kSoftPink = PdfColor.fromInt(0xFFF8BBD0);
  static final PdfColor kTextDark = PdfColor.fromInt(0xFF2D3142);
  static Future<void> generateAndShareResume(UserModel user, bool isArabic) async {
    final pdf = pw.Document();
    pw.MemoryImage? profileImage;
    if (user.profileImage != null && user.profileImage!.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(user.profileImage!));
        if (response.statusCode == 200) {
          profileImage = pw.MemoryImage(response.bodyBytes);
        }
      } catch (e) {
        print("خطأ في جلب الصورة للـ PDF: $e");
      }
    }
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                decoration: pw.BoxDecoration(color: kDustyRose),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          user.fullName.toUpperCase(),
                          style: pw.TextStyle(fontSize: 26, color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          user.jobTitle?.toUpperCase() ?? "PROFESSIONAL",
                          style: const pw.TextStyle(fontSize: 14, color: PdfColors.white),
                        ),
                      ],
                    ),
                    if (profileImage != null)
                      pw.Container(
                        width: 90,
                        height: 90,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          border: pw.Border.all(color: PdfColors.white, width: 3),
                          image: pw.DecorationImage(image: profileImage, fit: pw.BoxFit.cover),
                        ),
                      ),
                  ],
                ),
              ),

              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(35),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("CONTACT"),
                            _buildInfoItem(isArabic ? "الإيميل" : "Email", user.email),
                            _buildInfoItem(isArabic ? "الهاتف" : "Phone", user.phone),
                            _buildInfoItem(isArabic ? "العنوان" : "Address", user.address),
                            if (user.linkedin != null && user.linkedin!.isNotEmpty)
                              _buildInfoItem("LinkedIn", user.linkedin!),

                            pw.SizedBox(height: 25),
                            _buildSectionTitle("SKILLS"),
                            pw.Text(user.skills ?? "", style: const pw.TextStyle(fontSize: 10, lineSpacing: 4)),

                            if (user.languages != null && user.languages!.trim().isNotEmpty) ...[
                             pw.SizedBox(height: 25),
                             _buildSectionTitle(isArabic ? "اللغات" : "LANGUAGES"),
                              pw.Text(user.languages!, style: const pw.TextStyle(fontSize: 10)),
                            ]
                          ],
                        ),
                      ),

                      pw.SizedBox(width: 35),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("PROFESSIONAL SUMMARY"),
                            pw.Text(user.summary ?? "", style: pw.TextStyle(fontSize: 11, color: kTextDark, lineSpacing: 1.5)),

                            pw.SizedBox(height: 25),
                            _buildSectionTitle("WORK EXPERIENCE"),
                            pw.Text(user.experience ?? "", style: pw.TextStyle(fontSize: 11, color: kTextDark, lineSpacing: 1.5)),

                            pw.SizedBox(height: 25),
                            _buildSectionTitle("EDUCATION"),
                            pw.Text(user.education ?? "", style: pw.TextStyle(fontSize: 11, color: kTextDark, lineSpacing: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Container(
                height: 10,
                width: double.infinity,
                color: kSoftPink,
              )
            ],
          );
        },
      ),
    );
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/CV_${user.fullName.replaceAll(' ', '_')}.pdf');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], text: isArabic ? 'إليك سيرتي الذاتية' : 'Here is my resume');
  }
  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.only(bottom: 3),
      decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: kDustyRose, width: 1.5))),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13, color: kDustyRose),
      ),
    );
  }

  static pw.Widget _buildInfoItem(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 8, color: kDustyRose, fontWeight: pw.FontWeight.bold)),
          pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }
}