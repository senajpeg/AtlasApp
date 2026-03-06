import 'package:atlas_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../providers/parent_home_provider.dart';
import 'custom_drawer.dart'; // Drawer dosyasını import etmeyi unutma

class ParentHomeScreen extends ConsumerWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(parentHomeProvider);
    // Drawer'ı kod ile açabilmek için bu key'i kullanıyoruz
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey, // Scaffold'a key'i tanımladık
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const CustomDrawer(), // Yandan açılacak menü bileşeni
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- ÜST BAR: BAŞLIK VE MENÜ BUTONU ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ana Sayfa", 
                    style: TextStyle(
                      fontSize: 22.sp, // İstediğin gibi büyütüldü
                      fontWeight: FontWeight.bold, 
                      color: Colors.black87
                    )
                  ),
                  IconButton(
                    icon: Icon(Icons.menu, size: 28.sp, color: Colors.blue),
                    onPressed: () {
                      // Üç çizgiye basınca menüyü açar
                      scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ],
              ),
              
              SizedBox(height: 2.h),

              // Hoşgeldiniz Mesajı 
              Text(
                "Hoşgeldiniz, ${uiState.userName}", 
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.black87)
              ),
              SizedBox(height: 1.h),
              Text(
                "Çocuğunuzun gelişimini takip etmek ve özel eğitim süreçlerini yönetmek için ihtiyacınız olan tüm araçlar burada.", 
                style: TextStyle(fontSize: 15.sp, color: Colors.black54)
              ),
              
              SizedBox(height: 3.h),

              // Günün İpucu Kartı 
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Colors.blue),
                        SizedBox(width: 2.w),
                        Text("Günün İpucu", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16.sp)),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(uiState.dailyTip, style: TextStyle(fontSize: 14.5.sp, color: Colors.black87)),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Öğrenciler Başlığı 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Öğrencileriniz", style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
                  Text("Tümünü Gör", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 15.sp)),
                ],
              ),
              
              SizedBox(height: 2.h),

             // Öğrenci Kartı 1 - Deniz Yılmaz 
              _buildStudentCard(
                name: "Deniz Yılmaz",
                age: "24 Ay",
                status: "Değerlendirme Devam Ediyor",
                buttonText: "Değerlendirmeye Devam Et",
                isActionRequired: true,
              ),

              SizedBox(height: 2.h),

              // Öğrenci Kartı 2 - Zeynep Kaya 
              _buildStudentCard(
                name: "Zeynep Kaya",
                age: "4 Yaş",
                status: "Rapor Hazır",
                buttonText: "Raporu Görüntüle",
                isActionRequired: false,
              ),

              SizedBox(height: 3.h),

              // Yeni Gelişim Takibi Bilgi Kutusu 
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Yeni Bir Gelişim Takibi Başlatın", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black87)),
                    SizedBox(height: 0.5.h),
                    Text("Başka bir çocuğunuzu ekleyerek gelişimini uzmanlarımızla takip edebilirsiniz.", 
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
                  ],
                ),
              ),
              SizedBox(height: 12.h), 
            ],
          ),
        ),
      ),
      
      // Floating Action Button - Öğrenci Ekle 
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.addStudent);
        },
        backgroundColor: const Color(0xFF2196F3),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("Öğrenci Ekle", style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Öğrenci Kartı Tasarımı
  Widget _buildStudentCard({
    required String name,
    required String age,
    required String status,
    required String buttonText,
    required bool isActionRequired,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 25, backgroundColor: Color(0xFFE1E1E1), child: Icon(Icons.person, color: Colors.white)),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    Text(age, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActionRequired ? Colors.orange.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: TextStyle(color: isActionRequired ? Colors.orange : Colors.green, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Son Değerlendirme:", style: TextStyle(color: Colors.black87, fontSize: 14.sp, fontWeight: FontWeight.w500)),
              Text("27 Şubat 2026", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
            ],
          ),
          SizedBox(height: 1.5.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isActionRequired ? const Color(0xFF2196F3) : Colors.white,
                foregroundColor: isActionRequired ? Colors.white : const Color(0xFF2196F3),
                side: isActionRequired ? BorderSide.none : const BorderSide(color: Color(0xFF2196F3)),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 1.2.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(buttonText, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}