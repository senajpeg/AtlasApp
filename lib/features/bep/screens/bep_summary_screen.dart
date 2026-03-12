import 'package:atlas_app/core/app_router.dart';
import 'package:atlas_app/features/bep/providers/bep_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BepPerformanceSummaryScreen extends ConsumerWidget {
  const BepPerformanceSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider'dan mevcut durumu alıyoruz
    final bepState = ref.watch(bepProvider);
    
    // YENİ YAPI: O anki dersi ve o derse ait listeleri alıyoruz
    final selectedSubject = bepState.currentSubject ?? "Türkçe";
    final goals = bepState.currentGoals[selectedSubject] ?? [];
    final evaluations = bepState.evaluations[selectedSubject] ?? {};

    // "Yapar" ve "Yapamaz" olanları ayırıyoruz
    List<String> yapabildikleri = [];
    List<String> yapamadiklari = [];

    for (int i = 0; i < goals.length; i++) {
      if (evaluations[i] == true) {
        yapabildikleri.add(goals[i]);
      } else if (evaluations[i] == false) {
        yapamadiklari.add(goals[i]);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Eğitsel Performans ve Amaçlar",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 17.sp),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // İlerleme Çubuğu (Step 3)
                    Row(
                      children: [
                        Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(3)))),
                        SizedBox(width: 1.w),
                        Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(3)))),
                        SizedBox(width: 1.w),
                        Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(3)))),
                        SizedBox(width: 1.w),
                        Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3)))),
                      ],
                    ),
                    SizedBox(height: 3.h),

                    // Başlıklar
                    Text(
                      "$selectedSubject Dersi Değerlendirmesi",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "Performans Özeti",
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Öğrencinin mevcut durumuna göre hazırlanan gelişim tablosu.",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 3.h),

                    // --- YAPABİLDİKLERİ (Eğitsel Performans) ---
                    _buildSectionTitle("Eğitsel Performans (Yapabildikleri)", Colors.green),
                    SizedBox(height: 1.5.h),
                    if (yapabildikleri.isEmpty)
                      Text("Henüz eklenen bir beceri yok.", style: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp)),
                    ...yapabildikleri.map((item) => _buildListItem(item, Icons.check_circle, Colors.green)).toList(),
                    
                    SizedBox(height: 4.h),

                    // --- YAPAMADIKLARI (Öğretilecek Beceriler) ---
                    _buildSectionTitle("Öğretilecek Beceriler (Yapamadıkları)", Colors.redAccent),
                    SizedBox(height: 1.5.h),
                    if (yapamadiklari.isEmpty)
                      Text("Henüz eklenen bir beceri yok.", style: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp)),
                    ...yapamadiklari.map((item) => _buildListItem(item, Icons.cancel, Colors.redAccent)).toList(),

                    SizedBox(height: 3.h),

                    // Bilgi İpucu Kutusu
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.orange, size: 20.sp),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              "İpucu: \"Yapamadıkları\" listesindeki beceriler, bir sonraki adımda Kısa Dönemli Amaçlar (K.D.A) olarak seçilecektir.",
                              style: TextStyle(fontSize: 13.5.sp, color: Colors.orange.shade800, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),

            // --- ALT BUTON ---
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // YENİ YAPI: 15. Sayfaya yönlendirme eklendi
                    Navigator.pushNamed(context, AppRouter.bepGoals);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "U.D.A ve K.D.A Belirle",
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(width: 2.w),
                      Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Alt Başlık Tasarımı
  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 2.5.h,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  // Liste Elemanı Tasarımı
  Widget _buildListItem(String text, IconData icon, Color iconColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 18.sp),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.5.sp, color: Colors.black87, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}