import 'package:atlas_app/core/app_router.dart';
import 'package:atlas_app/features/bep/providers/bep_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BepGoalsScreen extends ConsumerStatefulWidget {
  const BepGoalsScreen({super.key});

  @override
  ConsumerState<BepGoalsScreen> createState() => _BepGoalsScreenState();
}

class _BepGoalsScreenState extends ConsumerState<BepGoalsScreen> {
  // U.D.A artık tek bir seçim olduğu için String? yapıyoruz (Radio Button için)
  String? _selectedUda;
  // K.D.A çoklu seçim olduğu için List kalıyor (Checkbox için)
  final List<String> _selectedKda = [];

  @override
  Widget build(BuildContext context) {
    final bepState = ref.watch(bepProvider);
    final bepNotifier = ref.read(bepProvider.notifier);

    final currentSubject = bepState.currentSubject ?? "Bilinmeyen Ders";
    
    // O anki dersin kazanımlarını ve değerlendirmelerini çekiyoruz
    final goals = bepState.currentGoals[currentSubject] ?? [];
    final evaluations = bepState.evaluations[currentSubject] ?? {};

    // SADECE "YAPAMAZ" (false) OLARAK İŞARETLENENLERİ FİLTRELİYORUZ
    List<String> yapamadiklari = [];
    for (int i = 0; i < goals.length; i++) {
      if (evaluations[i] == false) {
        yapamadiklari.add(goals[i]);
      }
    }
    
    // Diğer derslerin tamamlanma durumunu kontrol ediyoruz
    final completedCount = bepState.shortTermGoals.keys.where((k) => k != currentSubject).length;
    final bool isAllSubjectsCompleted = (completedCount + 1) == bepState.allSubjects.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Amaç Belirleme", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18.sp)),
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
                    Text(
                      "Öğrencinin yapamadığı beceriler aşağıda listelenmiştir. Lütfen bu dönem için hedeflerinizi seçin.",
                      style: TextStyle(fontSize: 14.5.sp, color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Mevcut Ders: $currentSubject",
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    SizedBox(height: 3.h),

                    // EĞER YAPAMADIĞI HİÇBİR ŞEY YOKSA (Full Çektiyse)
                    if (yapamadiklari.isEmpty)
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Öğrenci bu dersteki tüm becerileri yapabilmektedir. Yeni bir amaç belirlemenize gerek yoktur.",
                          style: TextStyle(color: Colors.green.shade800, fontSize: 14.sp),
                        ),
                      )
                    else ...[
                      // --- UZUN DÖNEMLİ AMAÇLAR (Tekil Seçim - Radio) ---
                      Text("Uzun Dönemli Amaç Seçin (Tek Seçim)", style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                      SizedBox(height: 1.5.h),
                      ...yapamadiklari.map((item) => _buildRadioItem(item)).toList(),

                      SizedBox(height: 4.h),

                      // --- KISA DÖNEMLİ AMAÇLAR (Çoklu Seçim - Checkbox) ---
                      Text("Kısa Dönemli Amaçları Seçin", style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                      SizedBox(height: 0.5.h),
                      Text("Not: U.D.A olarak seçilen madde burada listelenmez.", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                      SizedBox(height: 1.5.h),
                      
                      // U.D.A seçilen maddeyi K.D.A listesinden gizliyoruz
                      ...yapamadiklari
                          .where((item) => item != _selectedUda)
                          .map((item) => _buildCheckboxItem(item))
                          .toList(),
                    ],
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),

            // --- ALT BUTONLAR ---
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: Column(
                children: [
                  // 1. BUTON: DİĞER DERSLERE DÖN
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: !isAllSubjectsCompleted
                          ? () {
                              // Provider'a kaydet (UDA stringini listeye çevirip gönderiyoruz)
                              final udaList = _selectedUda != null ? [_selectedUda!] : <String>[];
                              bepNotifier.saveGoals(udaList, List.from(_selectedKda));
                              
                              // 3 sayfa geri gidip ders seçimine dönüyoruz
                              Navigator.pop(context); 
                              Navigator.pop(context); 
                              Navigator.pop(context); 
                            }
                          : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: BorderSide(color: !isAllSubjectsCompleted ? Colors.blue : Colors.grey.shade300, width: 2),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        !isAllSubjectsCompleted ? "Kaydet ve Diğer Derslere Dön" : "Tüm Dersler Değerlendirildi",
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 1.5.h),

                  // 2. BUTON: BEP RAPORUNU OLUŞTUR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isAllSubjectsCompleted
                          ? () {
                              final udaList = _selectedUda != null ? [_selectedUda!] : <String>[];
                              bepNotifier.saveGoals(udaList, List.from(_selectedKda));
                              Navigator.pushNamed(context, AppRouter.bepResultScreen);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Tüm Derslerle BEP Raporu Oluştur",
                            style: TextStyle(
                              fontSize: 15.sp, 
                              fontWeight: FontWeight.bold, 
                              color: isAllSubjectsCompleted ? Colors.white : Colors.grey.shade500
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(Icons.description, size: 18.sp, color: isAllSubjectsCompleted ? Colors.white : Colors.grey.shade500),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UDA İÇİN RADYO BUTONU TASARIMI (Tekli Seçim)
  Widget _buildRadioItem(String text) {
    final isSelected = _selectedUda == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUda = text;
          // Eğer önceden KDA olarak seçildiyse, UDA olunca KDA'dan çıkarıyoruz
          _selectedKda.remove(text);
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? Colors.blue : Colors.grey),
            SizedBox(width: 3.w),
            Expanded(child: Text(text, style: TextStyle(fontSize: 14.5.sp, color: Colors.black87))),
          ],
        ),
      ),
    );
  }

  // KDA İÇİN CHECKBOX TASARIMI (Çoklu Seçim)
  Widget _buildCheckboxItem(String text) {
    final isChecked = _selectedKda.contains(text);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isChecked) _selectedKda.remove(text);
          else _selectedKda.add(text);
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isChecked ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isChecked ? Colors.blue : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(isChecked ? Icons.check_box : Icons.check_box_outline_blank, color: isChecked ? Colors.blue : Colors.grey),
            SizedBox(width: 3.w),
            Expanded(child: Text(text, style: TextStyle(fontSize: 14.5.sp, color: Colors.black87))),
          ],
        ),
      ),
    );
  }
}