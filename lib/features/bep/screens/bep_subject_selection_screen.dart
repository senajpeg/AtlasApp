import 'package:atlas_app/core/app_router.dart';
import 'package:atlas_app/features/bep/providers/bep_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BepSubjectScreen extends ConsumerWidget {
  const BepSubjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bepState = ref.watch(bepProvider);
    final bepNotifier = ref.read(bepProvider.notifier);

    // BepState modelindeki allSubjects listesini kullanıyoruz
    final subjects = bepState.allSubjects;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () {
            bepNotifier.clearBep();
            Navigator.popUntil(context, ModalRoute.withName(AppRouter.teacherHome));
          },
        ),
        title: Text(
          "BEP Hazırlama",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18.sp),
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
                    Text("Ali Yılmaz", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                    SizedBox(height: 0.5.h),
                    Text("3/B Sınıfı - Hafif Düzey Otizm", style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade700)),
                    
                    SizedBox(height: 4.h),

                    Text(
                      "BEP Hazırlama Başlangıcı", 
                      style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold, color: Colors.black87)
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Aşağıdaki dersler için sırasıyla değerlendirme yapın.",
                      style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade600),
                    ),
                    
                    SizedBox(height: 3.h),

                    ...subjects.map((subject) {
                      final isSelected = bepState.currentSubject == subject;
                      // KONTROL: Bu dersin amaçları kaydedilmiş mi? (Tamamlandı mı?)
                      final isCompleted = bepState.shortTermGoals.containsKey(subject);
                      
                      return GestureDetector(
                        onTap: () => bepNotifier.selectSubject(subject),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green.shade50 : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.blue : (isCompleted ? Colors.green.shade200 : Colors.grey.shade200),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.5.w),
                                decoration: BoxDecoration(
                                  color: isCompleted ? Colors.green.shade100 : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  isCompleted ? Icons.check_circle : Icons.menu_book_outlined, 
                                  color: isCompleted ? Colors.green.shade700 : Colors.black87, 
                                  size: 22.sp
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      subject,
                                      style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      isCompleted ? "Tamamlandı" : "Değerlendirme Bekliyor",
                                      style: TextStyle(
                                        fontSize: 13.5.sp, 
                                        color: isCompleted ? Colors.green.shade700 : Colors.grey.shade600,
                                        fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isCompleted)
                                Icon(Icons.chevron_right, color: Colors.black54, size: 24.sp),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(5.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: bepState.currentSubject != null
                      ? () {
                          Navigator.pushNamed(context, AppRouter.bepPerformance);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    disabledBackgroundColor: Colors.blue.shade100,
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Seçili Dersi Değerlendir", 
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(width: 2.w),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
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
}