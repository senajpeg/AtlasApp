// lib/features/rdt/screens/rdt_result_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../core/app_router.dart';
import '../providers/rdt_provider.dart';

class RdtResultScreen extends ConsumerWidget {
  const RdtResultScreen({super.key});

  // Bilgilendirme diyaloğunu gösteren yardımcı metod
  void _showMhrsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("MHRS Yönlendirmesi"),
        content: const Text(
          "MHRS sistemine yönlendiriliyorsunuz.\n\n"
          "Randevu alırken 'Çocuk ve Ergen Ruh Sağlığı' bölümünü seçmeniz önerilir.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Vazgeç", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              // Aksiyon provider üzerinden tetikleniyor
              ref.read(rdtActionsProvider).launchMHRS();
            },
            child: const Text(
              "Sisteme Git",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(rdtResultProvider);
    final bool isHighRisk = result["isHighRisk"];
    final String riskLevel = result["level"];
    final int score = result["score"];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Değerlendirme Sonucu"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(rdtCategoryProvider.notifier).resetProgress();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            _buildResultCard(isHighRisk, riskLevel, score),
            SizedBox(height: 3.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Önerilen Eylemler",
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 2.h),
            _buildActionCard(
              icon: Icons.local_hospital_outlined,
              title: "MHRS Randevu Al",
              subtitle: "Çocuk Ergen Ruh Sağlığı bölümünden randevu oluşturun.",
              color: Colors.blue,
              onTap: () => _showMhrsDialog(context, ref),
            ),
            _buildActionCard(
              icon: Icons.chat_bubble_outline,
              title: "Uzmana Sor",
              subtitle: "Platformumuzdaki uzmanlara sorularınızı iletin.",
              color: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, AppRouter.expertScreen);
              },
            ),
            _buildActionCard(
              icon: Icons.menu_book_outlined,
              title: "Materyal Desteği",
              subtitle: "Gelişimi destekleyici aktivite ve dökümanlar.",
              color: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Eğitim materyalleri yakında eklenecek."),
                  ),
                );
              },
            ),
            SizedBox(height: 4.h),
            Text(
              "Bu değerlendirme bir tarama testidir, kesin tanı niteliği taşımaz. En kısa sürede bir uzmana danışmanız önerilir.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref.read(rdtCategoryProvider.notifier).resetProgress();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Ana Sayfaya Dön",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(bool isHighRisk, String level, int score) {
    final Color mainColor = isHighRisk ? Colors.red : Colors.green;
    final Color bgColor = isHighRisk
        ? const Color(0xFFFFF1F0)
        : const Color(0xFFF6FFED);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: mainColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            isHighRisk
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline,
            color: mainColor,
            size: 45,
          ),
          SizedBox(height: 1.5.h),
          Text(
            "DEĞERLENDİRME TAMAMLANDI",
            style: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            level,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.5.h),
          Text(
            "Toplam $score kritik gelişim göstergesi 'Yapamaz' olarak işaretlendi.",
            style: TextStyle(fontSize: 15.sp, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        leading: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 13.5.sp)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
