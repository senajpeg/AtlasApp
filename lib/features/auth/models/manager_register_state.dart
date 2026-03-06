class ManagerRegisterUiState {
  final bool isLoading;
  final bool isButtonActive;

  ManagerRegisterUiState({
    this.isLoading = false,
    this.isButtonActive = false,
  });

  ManagerRegisterUiState copyWith({
    bool? isLoading,
    bool? isButtonActive,
  }) {
    return ManagerRegisterUiState(
      isLoading: isLoading ?? this.isLoading,
      isButtonActive: isButtonActive ?? this.isButtonActive,
    );
  }
}