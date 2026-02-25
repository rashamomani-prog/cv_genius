import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:intl/intl.dart' as intl;
import '../models/user_model.dart';

class SimplePdfService {
  static String fix(String? text) {
    if (text == null || text.isEmpty) return "";
    var reshaped = ArabicReshaper().reshape(text);
    String result = (reshaped is String) ? reshaped : String.fromCharCodes(reshaped as Iterable<int>);
    if (intl.Bidi.hasAnyRtl(text)) {
      return result.split('').reversed.join();
    }
    return text;
  }

  static Future<void> generateAndShareSimpleResume(UserModel user, bool isArabic) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("assets/fonts/Cairo-Regular.ttf");
    final ttfFont = pw.Font.ttf(fontData);

    final kBackground = PdfColor.fromHex('#E8E2D9');
    final kTextDark = PdfColor.fromHex('#212121');
    final kLineColor = PdfColors.grey400;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        theme: pw.ThemeData.withFont(base: ttfFont, bold: ttfFont),
        build: (pw.Context context) {
          return pw.Container(
            color: kBackground,
            padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 50),
            child: pw.Directionality(
              textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(fix(user.fullName).toUpperCase(),
                            style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: kTextDark)),
                        pw.Text(fix(user.jobTitle).toUpperCase(),
                            style: pw.TextStyle(fontSize: 12, letterSpacing: 1.5, color: kTextDark)),

                        pw.SizedBox(height: 40),
                        _buildSimpleTitle(isArabic ? "اتصال" : "CONTACT", kTextDark),
                        _buildContactDetail(user.phone),
                        _buildContactDetail(user.email),
                        _buildContactDetail(user.address ?? ""),

                        pw.SizedBox(height: 30),
                        _buildSimpleTitle(isArabic ? "عني" : "ABOUT ME", kTextDark),
                        pw.Text(fix(user.summary), style: const pw.TextStyle(fontSize: 10, height: 1.4)),

                        pw.SizedBox(height: 30),
                        _buildSimpleTitle(isArabic ? "التعليم" : "EDUCATION", kTextDark),
                        pw.Text(fix(user.education), style: const pw.TextStyle(fontSize: 10, height: 1.4)),

                        pw.SizedBox(height: 30),
                        _buildSimpleTitle(isArabic ? "المهارات" : "SKILLS", kTextDark),
                        pw.Text(fix(user.skills), style: const pw.TextStyle(fontSize: 10, height: 1.4)),
                      ],
                    ),
                  ),

                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                    child: pw.VerticalDivider(width: 1, color: kLineColor, thickness: 1),
                  ),
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildSimpleTitle(isArabic ? "الخبرة" : "EXPERIENCE", kTextDark),
                        pw.SizedBox(height: 10),
                        pw.Text(fix(user.experience),
                            style: const pw.TextStyle(fontSize: 10, height: 1.6)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/classic_simple_resume.pdf");
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)]);
  }
  static pw.Widget _buildSimpleTitle(String title, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(fix(title), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: color)),
          pw.SizedBox(height: 2),
          pw.Container(width: 20, height: 1, color: color),
        ],
      ),
    );
  }
  static pw.Widget _buildContactDetail(String value) {
    if (value.isEmpty) return pw.SizedBox();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
    );
  }
}