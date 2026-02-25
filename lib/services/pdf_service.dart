import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:arabic_reshaper/arabic_reshaper.dart';
import '../models/user_model.dart';

class PdfService {
  static String fix(String? text) {
    if (text == null || text.isEmpty) return "";
    return ArabicReshaper.instance.reshape(text);
  }

  static Future<void> generateAndShareResume(UserModel user, bool isArabic) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("assets/fonts/Cairo-Regular.ttf");
    final ttfFont = pw.Font.ttf(fontData);

    final darkPink = PdfColor.fromHex('#AD1457');
    final lightPink = PdfColor.fromHex('#F8BBD0');
    final offWhite = PdfColor.fromHex('#FAF9F6');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        theme: pw.ThemeData.withFont(
          base: ttfFont,
          bold: ttfFont,
        ),
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    color: darkPink,
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 40),
                        pw.Text(fix(user.fullName), style: pw.TextStyle(color: PdfColors.black, fontSize: 20, fontWeight: pw.FontWeight.bold)),
                        pw.Text(fix(user.jobTitle), style: pw.TextStyle(color: PdfColors.black, fontSize: 14)),
                        pw.SizedBox(height: 30),
                        _buildContactInfo(isArabic ? "الايميل" : "Email", user.email, ttfFont),
                        _buildContactInfo(isArabic ? "الهاتف" : "Phone", user.phone, ttfFont),
                        _buildContactInfo(isArabic ? "لينكد إن" : "LinkedIn", user.linkedin ?? "", ttfFont),
                        _buildContactInfo(isArabic ? "تاريخ الميلاد" : "Birthday", user.birthDate ?? "", ttfFont),
                      ],
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                    color: lightPink,
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 40),
                        _buildSectionHeader(isArabic ? "المهارات" : "Skills", darkPink, ttfFont),
                        pw.Text(fix(user.skills), style: pw.TextStyle(fontSize: 11, font: ttfFont)),
                        pw.SizedBox(height: 25),
                        _buildSectionHeader(isArabic ? "الخبرات" : "Experience", darkPink, ttfFont),
                        pw.Text(fix(user.experience), style: pw.TextStyle(fontSize: 11, font: ttfFont)),
                        pw.SizedBox(height: 25),
                        _buildSectionHeader(isArabic ? "اللغات" : "Languages", darkPink, ttfFont),
                        pw.Text(fix(user.languages), style: pw.TextStyle(fontSize: 11, font: ttfFont)),
                      ],
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    color: offWhite,
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(height: 40),
                            _buildSectionHeader(isArabic ? "النبذة" : "Profile", darkPink, ttfFont),
                            pw.Text(fix(user.summary), style: pw.TextStyle(fontSize: 11, font: ttfFont)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/resume.pdf");
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)]);
  }

  static pw.Widget _buildContactInfo(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(fix(label), style: pw.TextStyle(color: PdfColors.white, fontSize: 10, fontWeight: pw.FontWeight.bold, font: font)),
          pw.Text(value, style: pw.TextStyle(color: PdfColors.white, fontSize: 9, font: font)),
        ],
      ),
    );
  }

  static pw.Widget _buildSectionHeader(String title, PdfColor color, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(fix(title), style: pw.TextStyle(color: color, fontSize: 16, fontWeight: pw.FontWeight.bold, font: font)),
        pw.Container(width: 30, height: 2, color: color, margin: const pw.EdgeInsets.only(top: 4, bottom: 10)),
      ],
    );
  }
}