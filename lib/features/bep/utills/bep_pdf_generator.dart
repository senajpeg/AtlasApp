import 'dart:typed_data';
import 'package:atlas_app/features/bep/models/bep_state.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BepPdfGenerator {
  static Future<Uint8List> generateBepPdf(BepState bepState) async {
    final pdf = pw.Document();

    // TÜRKÇE KARAKTER DESTEKLİ FONTLARI YÜKLÜYORUZ
    final ttf = await PdfGoogleFonts.robotoRegular();
    final ttfBold = await PdfGoogleFonts.robotoBold();

    final studentName = bepState.studentName ?? "Ali Yılmaz";
    final subjects = bepState.allSubjects;

    // Her ders için PDF'te yeni bir sayfa (veya bölüm) oluşturuyoruz
    for (String subject in subjects) {
      final goals = bepState.currentGoals[subject] ?? [];
      final evaluations = bepState.evaluations[subject] ?? {};
      final udaList = bepState.longTermGoals[subject] ?? [];
      final kdaList = bepState.shortTermGoals[subject] ?? [];

      // YAPABİLDİKLERİNİ CÜMLEYE ÇEVİRME (Eğitsel Performans)
      List<String> yaparList = [];
      for (int i = 0; i < goals.length; i++) {
        if (evaluations[i] == true) yaparList.add(goals[i]);
      }
      String performansMetni = yaparList.isNotEmpty 
          ? "Öğrenci; ${yaparList.join(' ')}" 
          : "Bu alanda henüz bağımsız yapabildiği bir beceri gözlemlenmemiştir.";

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // BAŞLIK KISMI
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text("T.C.", style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                      pw.Text("MİLLİ EĞİTİM BAKANLIĞI", style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                      pw.Text("[Kurum Adı / Okul Adı]", style: pw.TextStyle(font: ttf, fontSize: 12)),
                      pw.SizedBox(height: 10),
                      pw.Text("BİREYSELLEŞTİRİLMİŞ EĞİTİM PROGRAMI (BEP)", style: pw.TextStyle(font: ttfBold, fontSize: 14)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // ÖĞRENCİ BİLGİLERİ TABLOSU
                pw.Table.fromTextArray(
                  context: context,
                  cellStyle: pw.TextStyle(font: ttf, fontSize: 10), // Tablo içi normal font
                  headerStyle: pw.TextStyle(font: ttfBold, fontSize: 10), // Tablo başlıkları kalın font
                  data: <List<String>>[
                    ['ÖĞRENCİ ADI SOYADI', studentName],
                    ['SINIFI', '3/B'],
                    ['EĞİTİM DÖNEMİ', '18 Ocak - 21 Haziran'],
                    ['DERS', subject],
                    ['TANI', 'Hafif Düzey Otizm'],
                  ],
                  cellAlignment: pw.Alignment.centerLeft,
                  cellPadding: const pw.EdgeInsets.all(5),
                ),
                pw.SizedBox(height: 20),

                // EĞİTSEL PERFORMANS
                pw.Text("1. EĞİTSEL PERFORMANS", style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                pw.SizedBox(height: 5),
                pw.Text(performansMetni, style: pw.TextStyle(font: ttf, fontSize: 11)),
                pw.SizedBox(height: 20),

                // UZUN DÖNEMLİ AMAÇLAR
                pw.Text("2. UZUN DÖNEMLİ AMAÇLAR (U.D.A)", style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                pw.SizedBox(height: 5),
                if (udaList.isEmpty) pw.Text("Seçilen amaç yok.", style: pw.TextStyle(font: ttf, fontSize: 11, color: PdfColors.grey)),
                ...udaList.map((uda) => pw.Text("• $uda", style: pw.TextStyle(font: ttf, fontSize: 11))).toList(),
                pw.SizedBox(height: 20),

                // KISA DÖNEMLİ AMAÇLAR
                pw.Text("3. KISA DÖNEMLİ AMAÇLAR (K.D.A)", style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                pw.SizedBox(height: 5),
                if (kdaList.isEmpty) pw.Text("Seçilen amaç yok.", style: pw.TextStyle(font: ttf, fontSize: 11, color: PdfColors.grey)),
                ...kdaList.map((kda) => pw.Text("• $kda", style: pw.TextStyle(font: ttf, fontSize: 11))).toList(),
                
                pw.Spacer(),

                // İMZA SİRKÜLERİ
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSignArea("Sınıf Öğretmeni", ttf, ttfBold),
                    _buildSignArea("Özel Eğitim Öğrt.", ttf, ttfBold),
                    _buildSignArea("Veli", ttf, ttfBold),
                    _buildSignArea("Okul Müdürü", ttf, ttfBold),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }
    return pdf.save();
  }

  // İmza alanlarına da fontları dışarıdan yolluyoruz
  static pw.Widget _buildSignArea(String title, pw.Font font, pw.Font boldFont) {
    return pw.Column(
      children: [
        pw.Text(title, style: pw.TextStyle(font: boldFont, fontSize: 9)),
        pw.SizedBox(height: 30), // İmza boşluğu
        pw.Text("İmza", style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey)),
      ],
    );
  }
}