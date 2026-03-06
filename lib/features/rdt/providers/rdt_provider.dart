// lib/providers/rdt_provider.dart

import 'package:atlas_app/features/rdt/models/rdt_category_state.dart';
import 'package:atlas_app/features/rdt/models/rdt_question_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// --- 1. YAŞ SEÇİMİ PROVIDER'I ---
final selectedAgeRangeProvider = StateProvider<String?>((ref) => null);

// --- 2. KATEGORİ İLERLEME PROVIDER'I ---
final rdtCategoryProvider = StateNotifierProvider<RdtCategoryNotifier, RdtCategoryState>((ref) {
  return RdtCategoryNotifier();
});

class RdtCategoryNotifier extends StateNotifier<RdtCategoryState> {
  RdtCategoryNotifier() : super(RdtCategoryState());

  void completeCategory(String categoryName) {
    if (categoryName == "Dil - İletişim") {
      state = state.copyWith(isDilIletisimDone: true);
    } else if (categoryName == "Bilişsel") {
      state = state.copyWith(isBilisselDone: true);
    } else if (categoryName == "Sosyal - Duygusal") {
      state = state.copyWith(isSosyalDuygusalDone: true);
    } else if (categoryName == "Motor") {
      state = state.copyWith(isMotorDone: true);
    } else if (categoryName == "Özbakım") {
      state = state.copyWith(isOzbakimDone: true);
    }
  }

  void resetProgress() {
    state = RdtCategoryState();
  }
}

// --- 3. SORU CEVAP PROVIDER'I ---
final rdtQuestionProvider = StateNotifierProvider<RdtQuestionNotifier, RdtQuestionState>((ref) {
  return RdtQuestionNotifier();
});

class RdtQuestionNotifier extends StateNotifier<RdtQuestionState> {
  RdtQuestionNotifier() : super(RdtQuestionState());

  void updateAnswer(String category, int questionIndex, bool value) {
    final currentAnswers = Map<String, Map<int, bool>>.from(state.categoryAnswers);
    
    if (!currentAnswers.containsKey(category)) {
      currentAnswers[category] = {};
    }
    
    currentAnswers[category]![questionIndex] = value;
    state = state.copyWith(categoryAnswers: currentAnswers);
  }

  Map<int, bool> getAnswersForCategory(String category) {
    return state.categoryAnswers[category] ?? {};
  }
}

// --- 4. SONUÇ HESAPLAMA PROVIDER'I ---
final rdtResultProvider = Provider<Map<String, dynamic>>((ref) {
  final questionState = ref.watch(rdtQuestionProvider);
  
  int totalYapamaz = 0;
  questionState.categoryAnswers.forEach((category, answers) {
    totalYapamaz += answers.values.where((v) => v == false).length;
  });

  String riskLevel;
  if (totalYapamaz >= 5) {
    riskLevel = "Yüksek Risk";
  } else if (totalYapamaz >= 2) {
    riskLevel = "Orta Risk";
  } else {
    riskLevel = "Düşük Risk";
  }

  return {
    "score": totalYapamaz,
    "level": riskLevel,
    "isHighRisk": totalYapamaz >= 5,
  };
});

// --- 5. RDT AKSİYONLARI PROVIDER'I ---
final rdtActionsProvider = Provider((ref) => RdtActions());

class RdtActions {
  Future<void> launchMHRS() async {
    final Uri url = Uri.parse('https://mhrs.gov.tr/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}