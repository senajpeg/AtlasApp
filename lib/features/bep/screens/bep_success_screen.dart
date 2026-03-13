import 'package:atlas_app/core/app_router.dart';
import 'package:atlas_app/features/bep/providers/bep_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BepResultScreen extends ConsumerWidget {
  const BepResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bepState = ref.watch(bepProvider);
    final studentName = bepState.studentName ?? "Ali Yılmaz";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Başarı İkonu ve Mesajı
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                child: Icon(Icons.check_circle, color: Colors.green, size: 60.sp),
              ),
              SizedBox(height: 3.h),
              Text(
                "BEP Raporu Başarıyla\nOluşturuldu!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 1.5.h),
              Text(
                "Öğrencimiz $studentName için tüm dersleri kapsayan BEP dosyası hazır.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade600),
              ),
              SizedBox(height: 5.h),

              // Tıklanabilir PDF Dosyası Kartı (Önizlemeye Gider)
              GestureDetector(
                onTap: () {
                  // Önizleme Ekranına Git
                  Navigator.pushNamed(context, AppRouter.bepPdfPreview);
                },
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 24.sp),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${studentName.replaceAll(' ', '_')}_BEP.pdf", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                            SizedBox(height: 0.5.h),
                            Text("PDF • Az önce • Tıkla ve İncele", style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // PDF'i Cihaza İndir Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Cihaza indirme mantığı buraya eklenebilir (path_provider ile)
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("PDF Cihaza İndiriliyor...")));
                  },
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: Text("PDF'i Cihaza İndir", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(height: 1.5.h),

              // Ana Sayfaya Dön Butonu
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // BEP verilerini temizle ve ana sayfaya dön
                    ref.read(bepProvider.notifier).clearBep();
                    Navigator.pushNamedAndRemoveUntil(context, AppRouter.teacherHome, (route) => false);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Ana Sayfaya Dön", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}