import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bep_state.dart';

class BepNotifier extends StateNotifier<BepState> {
  BepNotifier() : super(BepState());

  void selectSubject(String subject) {
    state = state.copyWith(currentSubject: subject);
    
    // Eğer daha önce bu derse girilmediyse varsayılan kazanımlarını yükle
    if (!state.currentGoals.containsKey(subject)) {
      _loadGoalsForSubject(subject);
    }
  }

  void _loadGoalsForSubject(String subject) {
    List<String> goals = [];
    if (subject == "Türkçe") {
      goals = ["Harfleri tanır ve seslendirir.", "Basit heceleri okur.", "İki kelimeli cümleler kurar."];
    } else if (subject == "Matematik") {
      goals = ["1'den 10'a kadar sayar.", "Rakamları tanır.", "Basit toplama yapar."];
    } else {
      goals = ["$subject için kazanım 1", "$subject için kazanım 2"];
    }

    final newGoals = Map<String, List<String>>.from(state.currentGoals);
    newGoals[subject] = goals;
    state = state.copyWith(currentGoals: newGoals);
  }

  void setEvaluation(int index, bool isYapar) {
    final currentSub = state.currentSubject!;
    final newEvals = Map<String, Map<int, bool>>.from(state.evaluations);
    
    if (newEvals[currentSub] == null) newEvals[currentSub] = {};
    newEvals[currentSub]![index] = isYapar;
    
    state = state.copyWith(evaluations: newEvals);
  }

  // Amaçlar kaydedildiğinde bu ders "Tamamlandı" kabul edilecek
  void saveGoals(List<String> uda, List<String> kda) {
    final currentSub = state.currentSubject!;
    final newLong = Map<String, List<String>>.from(state.longTermGoals);
    final newShort = Map<String, List<String>>.from(state.shortTermGoals);
    
    newLong[currentSub] = uda;
    newShort[currentSub] = kda;
    
    state = state.copyWith(longTermGoals: newLong, shortTermGoals: newShort);
  }

  void clearBep() {
    state = BepState();
  }
}

final bepProvider = StateNotifierProvider<BepNotifier, BepState>((ref) {
  return BepNotifier();
});