import 'package:atlas_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../providers/rdt_provider.dart';

class RdtCategoryScreen extends ConsumerWidget {
  // Yaş aralığı bilgisini artık constructor üzerinden alıyoruz
  final String ageTitle;

  const RdtCategoryScreen({super.key, required this.ageTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kategori durumlarını ve ilerleme yüzdesini izliyoruz
    final categoryState = ref.watch(rdtCategoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        // Arguments üzerinden gelen yaş bilgisini başlığa yazdırıyoruz
        title: Text(
          "$ageTitle Değerlendirme",
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alanlar Başlığı 
            Text(
              "Alanlar - 5 Kategori",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            Text(
              "Lütfen çocuğunuzun gelişimini değerlendirmek istediğiniz alanı seçin. Tüm alanları tamamlamanız önerilir.",
              style: TextStyle(fontSize: 15.sp, color: Colors.black54),
            ), 

            SizedBox(height: 3.h),

            // Kategoriler - State'e göre durumları dinamik değişiyor 
            _buildCategoryTile(
              context,
              title: "Dil - İletişim",
              subtitle: "Sözel ve sözel olmayan ifade yeteneği",
              isDone: categoryState.isDilIletisimDone,
            ),
            _buildCategoryTile(
              context,
              title: "Bilişsel",
              subtitle: "Problem çözme ve anlama becerileri",
              isDone: categoryState.isBilisselDone,
            ),
            _buildCategoryTile(
              context,
              title: "Sosyal - Duygusal",
              subtitle: "Akran etkileşimi ve duygu kontrolü",
              isDone: categoryState.isSosyalDuygusalDone,
            ),
            _buildCategoryTile(
              context,
              title: "Motor",
              subtitle: "Kaba ve ince motor gelişim takibi",
              isDone: categoryState.isMotorDone,
            ),
            _buildCategoryTile(
              context,
              title: "Özbakım",
              subtitle: "Günlük yaşam becerileri ve bağımsızlık",
              isDone: categoryState.isOzbakimDone,
            ),

            SizedBox(height: 4.h),

            // Dinamik İlerleme Özeti [cite: 83, 102]
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Toplam İlerleme",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      Text(
                        "%${(categoryState.progress * 100).toInt()} Tamamlandı",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  LinearProgressIndicator(
                    value: categoryState.progress,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.blue,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Risk Hesapla Butonu 
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: categoryState.progress == 1.0
                    ? () {
                        
                        Navigator.pushNamed(context, AppRouter.rdtResult);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: categoryState.progress == 1.0
                      ? const Color(0xFF2196F3)
                      : Colors.grey.shade300,
                  padding: EdgeInsets.symmetric(vertical: 1.8.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  "Risk Durumunu Hesapla",
                  style: TextStyle(
                    color: categoryState.progress == 1.0 ? Colors.white : Colors.black38,
                    fontSize: 17.sp,
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

  Widget _buildCategoryTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isDone,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isDone ? Colors.green.shade200 : Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5.sp),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 0.5.h),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 14.sp, color: Colors.black54),
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.8.h),
          decoration: BoxDecoration(
            color: isDone ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isDone ? "Tamamlandı" : "Bekliyor",
            style: TextStyle(
              color: isDone ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
        ),
        onTap: () {
          // Kategori ismini bir sonraki sayfaya (Sayfa 6) argüman olarak yolluyoruz
          Navigator.pushNamed(
            context,
            AppRouter.rdtQuestionScreen,
            arguments: title,
          );
        },
      ),
    );
  }
}