// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../providers/drawer_provider.dart';
import 'package:atlas_app/core/app_router.dart'; // Router importunu eklemeyi unutma

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(drawerIndexProvider);

    return Drawer(
      width: 75.w,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Mavi Header Alanı [cite: 242]
          _buildHeader(),

          // Menü Öğeleri [cite: 244, 246, 247, 248, 249, 250]
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildItem(context, ref, 0, Icons.grid_view_rounded, "Anasayfa", selectedIndex == 0),
                _buildItem(context, ref, 1, Icons.assignment_outlined, "Risk Değerlendirme", selectedIndex == 1),
                _buildItem(context, ref, 2, Icons.tablet_android_outlined, "Materyal Desteği", selectedIndex == 2),
                _buildItem(context, ref, 3, Icons.stacked_line_chart_rounded, "İzleme - Raporlama", selectedIndex == 3),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(),
                ),

                _buildItem(context, ref, 4, Icons.person_outline, "Profil", selectedIndex == 4),
                _buildItem(context, ref, 5, Icons.people_outline, "Öğrencilerim", selectedIndex == 5),
              ],
            ),
          ),

          // Çıkış Yap ve Versiyon [cite: 251, 252]
          _buildFooter(),
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
        leading: Icon(
          icon, 
          color: isSelected ? const Color(0xFF2196F3) : Colors.grey[600]
        ),
        title: Text(
          title, 
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF2196F3) : Colors.black87,
          )
        ),
        onTap: () {
          // 1. Menü state'ini güncelle
          ref.read(drawerIndexProvider.notifier).state = index;
          
          // 2. Drawer'ı (yandan açılır menüyü) kapat
          Navigator.pop(context);

          // 3. Tıklanan öğeye göre yönlendirme yap
          if (index == 1) {
            // Risk Değerlendirme tıklandığında Sayfa 4'e git [cite: 58, 60]
            Navigator.pushNamed(context, AppRouter.rdtAgeSelection);
          }
          // Diğer sayfalar için buraya else-if ekleyebilirsin
        },
      ),
    );
  }

  Widget _buildHeader() {
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
          Text("Hoşgeldiniz,", style: TextStyle(color: Colors.white70, fontSize: 16.sp)),
          Text("Ahmet Veli", style: TextStyle(color: Colors.white, fontSize: 19.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.redAccent),
          title: Text("Çıkış Yap", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16.sp)),
          onTap: () {
            // Çıkış işlemleri buraya
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Text("ÖZEL EĞİTİM PLATFORMU V1.0.4", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
        ),
      ],
    );
  }
}