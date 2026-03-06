import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../core/app_router.dart';
import '../providers/rdt_provider.dart';

class RdtQuestionScreen extends ConsumerWidget {
  final String categoryTitle;

  const RdtQuestionScreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tüm cevapları dinliyoruz, bir değişiklik olduğunda sayfa yenilenir
    final questionState = ref.watch(rdtQuestionProvider);
    final categoryAnswers = questionState.categoryAnswers[categoryTitle] ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("$categoryTitle Alanı", 
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // İlerleme Çubuğu [cite: 111, 112]
          LinearProgressIndicator(
            value: categoryAnswers.length / 10,
            backgroundColor: Colors.grey.shade100,
            color: Colors.blue,
            minHeight: 6,
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              children: [
                Text(
                  "Lütfen çocuğunuzun davranışlarını gözlemleyerek en uygun seçeneği işaretleyin.",
                  style: TextStyle(fontSize: 15.5.sp, color: Colors.black54),
                ), 
                SizedBox(height: 4.h),

                _buildQuestion(context, ref, 1, "İsmi söylendiğinde dönüp bakar mı?"), 
                _buildQuestion(context, ref, 2, "İstediği bir nesneyi parmağıyla gösterir mi?"), 
                _buildQuestion(context, ref, 3, "Basit yönergeleri (Gel, Al, Ver vb.) yerine getirir mi?"), 
                _buildQuestion(context, ref, 4, "En az 5-10 kelime kullanarak konuşur mu?"), 
                _buildQuestion(context, ref, 5, "Göz teması kurarak iletişim başlatır mi?"), 
                _buildQuestion(context, ref, 6, "Bay-bay yapma, alkış yapma gibi jestleri taklit eder mi?"), 
                _buildQuestion(context, ref, 7, "Tanıdığı kişilerin isimlerini söyleyebilir mi?"), 
                _buildQuestion(context, ref, 8, "İhtiyaçlarını ağlamak yerine işaretle veya kelimeyle belirtir mi?"), 
                _buildQuestion(context, ref, 9, "Resimli kitaplardaki nesnelerin ismini sorduğunuzda gösterir mi?"),
                _buildQuestion(context, ref, 10, "Kendi başına 'anne', 'baba' gibi anlamlı kelimeler kullanır mı?"), 
                
                SizedBox(height: 2.h),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(5.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // 10 sorunun tamamı cevaplanınca buton aktif olur 
                onPressed: categoryAnswers.length < 10 ? null : () {
                  ref.read(rdtCategoryProvider.notifier).completeCategory(categoryTitle);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: categoryAnswers.length == 10 ? const Color(0xFF2196F3) : Colors.grey.shade300,
                  padding: EdgeInsets.symmetric(vertical: 1.6.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  "Kaydet ve Devam Et", 
                  style: TextStyle(
                    color: categoryAnswers.length == 10 ? Colors.white : Colors.black45, 
                    fontSize: 17.sp, 
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, WidgetRef ref, int index, String question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$index) $question", 
          style: TextStyle(fontSize: 16.5.sp, fontWeight: FontWeight.w600, color: Colors.black87)
        ),
        SizedBox(height: 1.5.h),
        Row(
          children: [
            _answerOption(ref, index, "Yapar", true), 
            SizedBox(width: 4.w),
            _answerOption(ref, index, "Yapamaz", false), 
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Divider(color: Colors.grey.shade200, thickness: 1),
        ),
      ],
    );
  }

  Widget _answerOption(WidgetRef ref, int qIndex, String label, bool value) {
    // Burada watch kullanarak state değişimini dinliyoruz
    final questionState = ref.watch(rdtQuestionProvider);
    final categoryAnswers = questionState.categoryAnswers[categoryTitle] ?? {};
    final bool isSelected = categoryAnswers[qIndex] == value;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          // Seçimi doğrudan notifier üzerinden güncelliyoruz
          ref.read(rdtQuestionProvider.notifier).updateAnswer(categoryTitle, qIndex, value);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          decoration: BoxDecoration(
            // Seçilince PDF'deki gibi açık mavi arka plan
            color: isSelected ? const Color(0xFFE3F2FD) : Colors.transparent,
            border: Border.all(
              color: isSelected ? const Color(0xFF2196F3) : Colors.grey.shade300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2196F3) : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 15.sp
              ),
            ),
          ),
        ),
      ),
    );
  }
}