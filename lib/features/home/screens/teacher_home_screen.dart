import 'package:atlas_app/core/app_router.dart';
import 'package:atlas_app/features/home/providers/teacher_home_provider.dart';
import 'package:atlas_app/features/home/screens/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TeacherHomeScreen extends ConsumerWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider'dan verileri çekiyoruz
    final uiState = ref.watch(teacherHomeProvider);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const CustomDrawer(isTeacher:true),
      body: SafeArea(
        child: uiState.isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- ÜST BAR: BAŞLIK VE MENÜ ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Öğretmen Paneli",
                            style: TextStyle(
                              fontSize: 22.sp, 
                              fontWeight: FontWeight.bold,
                              color: Colors.black87
                            ),
                          ),
                          Text(
                            uiState.userName, // Provider'dan gelen öğretmen ismi
                            style: TextStyle(
                              fontSize: 15.sp, 
                              color: Colors.black54,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.menu, size: 28.sp, color: Colors.blue),
                        onPressed: () => scaffoldKey.currentState?.openDrawer(),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // --- ÖZET İSTATİSTİKLER (Dinamik) ---
                  Row(
                    children: [
                      _buildStatCard("Öğrenci", uiState.totalStudents.toString(), Colors.blue),
                      SizedBox(width: 3.w),
                      _buildStatCard("Bekleyen RDT", uiState.pendingRdt.toString(), Colors.orange),
                      SizedBox(width: 3.w),
                      _buildStatCard("Hazır BEP", uiState.readyBep.toString(), Colors.green),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    "Sınıf Listesi",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2.h),

                  // --- ÖĞRENCİ LİSTESİ ---
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: uiState.students.length,
                    itemBuilder: (context, index) {
                      final student = uiState.students[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: _buildTeacherStudentCard(
                          context: context,
                          name: student.name,
                          details: student.details,
                          rdtProgress: student.rdtStatus,
                          bepStatus: student.bepStatus,
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 5.h),
                ],
              ),
            ),
      ),
    );
  }

  // İstatistik Kartı Tasarımı
  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // Öğretmen İçin Özelleştirilmiş Çift Butonlu Öğrenci Kartı
  Widget _buildTeacherStudentCard({
    required BuildContext context,
    required String name,
    required String details,
    required String rdtProgress,
    required String bepStatus,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  Text(details, style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
                ],
              ),
            ],
          ),
          const Divider(height: 30),

          // Durum Göstergeleri
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusRow("RDT:", rdtProgress, Colors.orange),
              _statusRow("BEP:", bepStatus, Colors.blue),
            ],
          ),

          SizedBox(height: 2.h),

          // Aksiyon Butonları: RDT Takibi ve BEP Hazırlama
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.rdtAgeSelection);
                  },
                  icon: const Icon(Icons.analytics_outlined, size: 18),
                  label: const Text("RDT Takibi"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // BEP hazırlama akışına yönlendirecek
                  },
                  icon: const Icon(Icons.description_outlined, size: 18, color: Colors.white),
                  label: const Text("BEP Hazırla"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusRow(String label, String status, Color color) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
        SizedBox(width: 1.w),
        Text(
          status,
          style: TextStyle(fontSize: 13.sp, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}