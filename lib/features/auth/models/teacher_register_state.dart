class TeacherRegisterUiState {
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isFormValid;

  TeacherRegisterUiState({
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.isFormValid = false,
  });

  TeacherRegisterUiState copyWith({
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isFormValid,
  }) {
    return TeacherRegisterUiState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}