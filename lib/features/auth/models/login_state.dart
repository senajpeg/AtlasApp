import '../screens/login_screen.dart'; // AppRole enum'u burada olduğu için

class LoginUiState {
  final AppRole selectedRole;
  final bool isLoading;
  final String? errorMessage;
  final bool isButtonActive;

  LoginUiState({
    this.selectedRole = AppRole.veli,
    this.isLoading = false,
    this.errorMessage,
    this.isButtonActive = false,
  });

  LoginUiState copyWith({
    AppRole? selectedRole,
    bool? isLoading,
    String? errorMessage,
    bool? isButtonActive,
  }) {
    return LoginUiState(
      selectedRole: selectedRole ?? this.selectedRole,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isButtonActive: isButtonActive ?? this.isButtonActive,
    );
  }
}