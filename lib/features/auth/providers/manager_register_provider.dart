import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/manager_register_state.dart';

class ManagerRegisterViewModel extends StateNotifier<ManagerRegisterUiState> {
  ManagerRegisterViewModel() : super(ManagerRegisterUiState());

  final managerNameController = TextEditingController();
  final schoolNameController = TextEditingController();

  void checkInputs() {
    final isValid = managerNameController.text.isNotEmpty && 
                    schoolNameController.text.isNotEmpty;
    state = state.copyWith(isButtonActive: isValid);
  }

  // Kod üretme mantığını da buraya aldık (Logic katmanı)
  String generateInstitutionCode() {
    return "MUD-${DateTime.now().millisecond}X";
  }

  @override
  void dispose() {
    managerNameController.dispose();
    schoolNameController.dispose();
    super.dispose();
  }
}

final managerRegisterProvider = StateNotifierProvider<ManagerRegisterViewModel, ManagerRegisterUiState>((ref) {
  return ManagerRegisterViewModel();
});