import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/login_state.dart';
import '../screens/login_screen.dart';

class LoginViewModel extends StateNotifier<LoginUiState> {
  LoginViewModel() : super(LoginUiState());

  // Controller'lar burada sabit kalarak odak kaybını önler
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Rol değiştirme
  void setRole(AppRole role) {
    state = state.copyWith(selectedRole: role);
  }

  // Buton aktiflik kontrolü
  void checkInputs() {
    final isValid = emailController.text.contains('@') && passwordController.text.length >= 6;
    state = state.copyWith(isButtonActive: isValid);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

final loginProvider = StateNotifierProvider<LoginViewModel, LoginUiState>((ref) {
  return LoginViewModel();
});