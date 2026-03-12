import 'package:atlas_app/core/app_router.dart';
import 'package:atlas_app/features/bep/providers/bep_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BepPerformanceScreen extends ConsumerWidget {
  const BepPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bepState = ref.watch(bepProvider);
    final bepNotifier = ref.read(bepProvider.notifier);

    // HATALAR BURADA DÜZELTİLDİ: O anki derse ait listeyi ve haritayı çekiyoruz
    final currentSubject = bepState.currentSubject ?? "Türkçe"; 
    final goals = bepState.currentGoals[currentSubject] ?? [];
    final evaluations = bepState.evaluations[currentSubject] ?? {};

    // Kontrol: Tüm sorular işaretlendi mi?
    final int answeredCount = evaluations.length;
    final bool isAllAnswered = answeredCount == goals.length && goals.isNotEmpty;

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
          "Performans Alımı",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- ÜST BİLGİ ALANI ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(3)))),
                      SizedBox(width: 1.w),
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(3)))),
                      SizedBox(width: 1.w),
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3)))),
                      SizedBox(width: 1.w),
                      Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3)))),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  
                  Text(
                    "$answeredCount/${goals.length} İşaretlendi", 
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14.sp)
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "$currentSubject Dersi", 
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black87)
                  ),
                  Text(
                    "Kazanım Değerlendirmesi", 
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.blue)
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "Öğrencinin yapabildiği ve yapamadığı kazanımları aşağıdan işaretleyin.",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.h),

            // --- KAZANIMLAR LİSTESİ ---
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final String goalText = goals[index];
                  final bool? isYapar = evaluations[index];

                  return _buildGoalItem(
                    index: index, 
                    goal: goalText, 
                    isYapar: isYapar, 
                    onEvaluate: (val) => bepNotifier.setEvaluation(index, val)
                  );
                },
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
                  onPressed: isAllAnswered 
                    ? () {
                        Navigator.pushNamed(context, AppRouter.bepPerformanceSummary);
                      } 
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Kaydet ve İleri", 
                        style: TextStyle(
                          fontSize: 16.sp, 
                          fontWeight: FontWeight.bold, 
                          color: isAllAnswered ? Colors.white : Colors.grey.shade500
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(Icons.arrow_forward_ios, size: 16.sp, color: isAllAnswered ? Colors.white : Colors.grey.shade500),
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

  // Özel Tasarımlı Kazanım Maddesi
  Widget _buildGoalItem({
    required int index, 
    required String goal, 
    required bool? isYapar,
    required Function(bool) onEvaluate,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                child: Text(
                  "${index + 1}", 
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 14.sp)
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 1.w),
                  child: Text(
                    goal, 
                    style: TextStyle(fontSize: 15.sp, color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildToggleButton(
                title: "Yapar",
                isSelected: isYapar == true,
                selectedColor: Colors.blue,
                onTap: () => onEvaluate(true),
              ),
              SizedBox(width: 3.w),
              _buildToggleButton(
                title: "Yapamaz",
                isSelected: isYapar == false,
                selectedColor: Colors.redAccent,
                onTap: () => onEvaluate(false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required bool isSelected,
    required Color selectedColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor.withOpacity(0.1) : Colors.white,
            border: Border.all(color: isSelected ? selectedColor : Colors.grey.shade300, width: isSelected ? 2 : 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                Icon(Icons.check_circle, color: selectedColor, size: 16.sp),
                SizedBox(width: 1.w),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? selectedColor : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}