import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/teacher_register_state.dart';

class TeacherRegisterViewModel extends StateNotifier<TeacherRegisterUiState> {
  TeacherRegisterViewModel() : super(TeacherRegisterUiState());

  // Controller'lar burada sabit kalarak klavye sorununu çözer
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void togglePassword() => state = state.copyWith(obscurePassword: !state.obscurePassword);
  void toggleConfirmPassword() => state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);

  void checkValidation() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^05[0-9]{9}$');

    final isValid = codeController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailRegex.hasMatch(emailController.text) &&
        phoneRegex.hasMatch(phoneController.text.replaceAll(' ', '')) &&
        passwordController.text.length >= 6 &&
        passwordController.text == confirmPasswordController.text;

    state = state.copyWith(isFormValid: isValid);
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

final teacherRegisterProvider = StateNotifierProvider<TeacherRegisterViewModel, TeacherRegisterUiState>((ref) {
  return TeacherRegisterViewModel();
});