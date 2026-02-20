import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/parent_register_state.dart';

class ParentRegisterNotifier extends StateNotifier<ParentRegisterState> {
  ParentRegisterNotifier() : super(ParentRegisterState());

  // Şifre görünürlüğü kontrolleri
  void togglePassword() => state = state.copyWith(obscurePassword: !state.obscurePassword);
  void toggleConfirmPassword() => state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);

  // Form doğrulama (Buton aktifliği için)
  void validateForm(String name, String email, String phone, String p1, String p2) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^05[0-9]{9}$');

    final isValid = name.isNotEmpty &&
        emailRegex.hasMatch(email) &&
        phoneRegex.hasMatch(phone.replaceAll(' ', '')) &&
        p1.length >= 6 &&
        p1 == p2;

    state = state.copyWith(isFormValid: isValid);
  }

  // Kayıt işlemi (Firebase veya Backend isteği)
  Future<void> registerParent() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 2)); // Simülasyon
    state = state.copyWith(isLoading: false);
  }
}

// UI'ın dinleyeceği Provider
final parentRegisterProvider = StateNotifierProvider<ParentRegisterNotifier, ParentRegisterState>((ref) {
  return ParentRegisterNotifier();
});