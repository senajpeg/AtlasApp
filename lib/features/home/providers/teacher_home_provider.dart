import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/teacher_home_state.dart';

final teacherHomeProvider = StateNotifierProvider<TeacherHomeNotifier, TeacherHomeState>((ref) {
  return TeacherHomeNotifier();
});

class TeacherHomeNotifier extends StateNotifier<TeacherHomeState> {
  TeacherHomeNotifier() : super(TeacherHomeState()) {
    _init();
  }

  void _init() {
    state = state.copyWith(isLoading: true);
    
    // Simüle edilmiş başlangıç verileri (Daha sonra API/Firebase ile değişecek)
    state = state.copyWith(
      userName: "Ayşe Demir",
      totalStudents: 12,
      pendingRdt: 3,
      readyBep: 8,
      students: [
        TeacherStudentModel(
          id: "No: 124",
          name: "Ali Yılmaz",
          details: "9 Yaş - Hafif Düzey Otizm",
          rdtStatus: "Tamamlandı",
          bepStatus: "Taslak Hazır",
          isBepReady: true,
        ),
        TeacherStudentModel(
          id: "No: 452",
          name: "Zeynep Kaya",
          details: "7 Yaş - Disleksi",
          rdtStatus: "Veli Bekleniyor",
          bepStatus: "Başlanmadı",
          isBepReady: false,
        ),
      ],
      isLoading: false,
    );
  }

  // Yeni öğrenci ekleme veya veri yenileme gibi metodlar buraya eklenebilir
  void refreshData() {
    _init();
  }
}