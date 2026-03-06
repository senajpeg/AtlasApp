import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/add_student_state.dart';

class AddStudentViewModel extends StateNotifier<AddStudentUiState> {
  AddStudentViewModel() : super(AddStudentUiState());

  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final schoolController = TextEditingController();
  final classController = TextEditingController();
  final locationController = TextEditingController();

  void checkInputs() {
    // Ad Soyad dolu olmalı ve Tarih GG/AA/YYYY formatında (10 karakter) olmalı
    final isValid = nameController.text.trim().isNotEmpty && 
                    dateController.text.length == 10;
    state = state.copyWith(isButtonActive: isValid);
  }

  void onSaveAndCalculate(VoidCallback onSuccess) {
    // Şimdilik manuel set ediyoruz, ilerde gerçek hesaplama buraya gelecek
    state = state.copyWith(calculatedAge: "24 Ay");
    onSuccess();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    schoolController.dispose();
    classController.dispose();
    locationController.dispose();
    super.dispose();
  }
}

final addStudentProvider = StateNotifierProvider<AddStudentViewModel, AddStudentUiState>((ref) {
  return AddStudentViewModel();
});