class ParentRegisterState {
  final bool isLoading;
  final String? errorMessage;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isFormValid;

  ParentRegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.isFormValid = false,
  });

  // Compose'daki .copy() fonksiyonu
  ParentRegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isFormValid,
  }) {
    return ParentRegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}