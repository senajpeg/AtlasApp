import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/parent_home_state.dart';

class ParentHomeViewModel extends StateNotifier<ParentHomeUiState> {
  ParentHomeViewModel() : super(ParentHomeUiState());

  // İleride verileri çekmek için metodlar buraya gelecek
  void refreshDashboard() {
    state = state.copyWith(isLoading: true);
    // Simülasyon
    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(isLoading: false);
    });
  }
}

final parentHomeProvider = StateNotifierProvider<ParentHomeViewModel, ParentHomeUiState>((ref) {
  return ParentHomeViewModel();
});