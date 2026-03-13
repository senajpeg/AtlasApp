// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../providers/drawer_provider.dart';
import 'package:atlas_app/core/app_router.dart';

class CustomDrawer extends ConsumerWidget {
  final bool isTeacher; // Parametre olarak rolü alıyoruz

  const CustomDrawer({
    super.key, 
    this.isTeacher = false, // Varsayılan olarak veli (false)
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(drawerIndexProvider);

    return Drawer(
      width: 75.w,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Parametreden gelen bilgiye göre Header oluşur
          _buildHeader(isTeacher),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildItem(context, ref, 0, Icons.grid_view_rounded, "Anasayfa", selectedIndex == 0),
                _buildItem(context, ref, 1, Icons.assignment_outlined, "Risk Değerlendirme (RDT)", selectedIndex == 1),
                
                // Sadece öğretmense BEP Hazırlama görünür
                if (isTeacher)
                  _buildItem(context, ref, 2, Icons.description_outlined, "BEP Hazırlama", selectedIndex == 2),
                
                _buildItem(context, ref, 3, Icons.tablet_android_outlined, "Materyal Desteği", selectedIndex == 3),
                _buildItem(context, ref, 4, Icons.stacked_line_chart_rounded, "İzleme - Raporlama", selectedIndex == 4),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(),
                ),

                _buildItem(context, ref, 5, Icons.person_outline, "Profil", selectedIndex == 5),
                
                // Alt etiket role göre değişir
                _buildItem(context, ref, 6, Icons.people_outline, isTeacher ? "Öğrencilerim" : "Çocuklarım", selectedIndex == 6),
              ],
            ),
          ),

          // DÜZELTME: context parametresini içeri gönderiyoruz
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, WidgetRef ref, int index, IconData icon, String title, bool isSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selected: isSelected,
        selectedTileColor: const Color(0xFFE3F2FD), 
        leading: Icon(icon, color: isSelected ? const Color(0xFF2196F3) : Colors.grey[600]),
        title: Text(
          title, 
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF2196F3) : Colors.black87,
          )
        ),
        onTap: () {
          ref.read(drawerIndexProvider.notifier).state = index;
          Navigator.pop(context); // Tıklandığında menüyü kapatır
          
          // Yönlendirmeler
          if (index == 1) {
            Navigator.pushNamed(context, AppRouter.rdtAgeSelection);
          } else if (index == 2) {
            // BEP Hazırlama tıklandığında Ders Seçimi ekranına gider
            Navigator.pushNamed(context, AppRouter.bepSubjectSelection);
          }
        },
      ),
    );
  }

  Widget _buildHeader(bool teacherMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 8.h, bottom: 4.h, left: 6.w),
      color: const Color(0xFF2196F3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30, 
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          SizedBox(height: 2.h),
          Text(
            teacherMode ? "Ahmet Yılmaz" : "Ahmet Veli", 
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)
          ),
          Text(
            teacherMode ? "Özel Eğitim Öğretmeni" : "Ebeveyn", 
            style: TextStyle(color: Colors.white70, fontSize: 14.sp, fontWeight: FontWeight.w400)
          ),
        ],
      ),
    );
  }

  // DÜZELTME: BuildContext context parametresini buraya ekledik
  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.redAccent),
          title: Text("Çıkış Yap", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16.sp)),
          onTap: () {
            // Geçmişteki tüm rotaları silip Login ekranına yönlendirir
            Navigator.pushNamedAndRemoveUntil(
              context, 
              AppRouter.login, 
              (route) => false,
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Text("ATLAS ÖZEL EĞİTİM V1.0.4", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
        ),
      ],
    );
  }
}