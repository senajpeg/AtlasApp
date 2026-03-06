import 'package:atlas_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../providers/rdt_provider.dart';

class RdtAgeSelectionScreen extends ConsumerWidget {
  // ConsumerWidget yapıldı
  const RdtAgeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Seçilen yaş aralığını izliyoruz
    final selectedAge = ref.watch(selectedAgeRangeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Risk Durumu Modülü",
          style: TextStyle(fontSize: 17.sp),
        ), // [cite: 58]
        leading: const BackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Yaş Aralığı Seçimi",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ), // [cite: 60]
            SizedBox(height: 1.h),
            Text(
              "Lütfen çocuğunuzun takvim yaşına uygun aralığı seçin. Bu bilgi değerlendirme formunu özelleştirmek için kullanılır.",
              style: TextStyle(fontSize: 15.sp, color: Colors.black54),
            ), // [cite: 61]
            SizedBox(height: 3.h),

            // Yaş Aralığı Seçenekleri [cite: 63-69]
            Expanded(
              child: ListView(
                children: [
                  _ageOption(ref, "0-36 ay", selectedAge == "0-36 ay"),
                  _ageOption(ref, "37-66 ay", selectedAge == "37-66 ay"),
                  _ageOption(ref, "67-78 ay", selectedAge == "67-78 ay"),
                  _ageOption(ref, "7-11 yaş", selectedAge == "7-11 yaş"),
                  _ageOption(ref, "12-14 yaş", selectedAge == "12-14 yaş"),
                  _ageOption(ref, "15-18 yaş", selectedAge == "15-18 yaş"),
                  _ageOption(ref, "18+ yaş", selectedAge == "18+ yaş"),
                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // Eğer bir yaş seçilmemişse onPressed null döner, bu da butonu deaktif yapar
                onPressed: selectedAge == null
                    ? null
                    : () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.rdtCategorySelection,
                          arguments:
                              selectedAge, // Seçilen "0-36 ay" vb. argüman olarak gider
                        );
                      },
                style: ElevatedButton.styleFrom(
                  // Aktifken mavi, deaktifken gri görünür
                  backgroundColor: selectedAge == null
                      ? Colors.grey.shade300
                      : Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "İleri",
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: selectedAge == null ? Colors.grey : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ), //
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ageOption(WidgetRef ref, String title, bool isSelected) {
    return Card(
      margin: EdgeInsets.only(bottom: 1.5.h),
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.blue : Colors.black87,
          ),
        ),
        trailing: Icon(
          isSelected ? Icons.check_circle : Icons.chevron_right,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
        onTap: () {
          // Provider üzerinden seçimi güncelle
          ref.read(selectedAgeRangeProvider.notifier).state = title;
        },
      ),
    );
  }
}
