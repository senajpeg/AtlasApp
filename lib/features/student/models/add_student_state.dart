class AddStudentUiState {
  final bool isButtonActive;
  final String? calculatedAge;

  AddStudentUiState({
    this.isButtonActive = false,
    this.calculatedAge,
  });

  AddStudentUiState copyWith({
    bool? isButtonActive,
    String? calculatedAge,
  }) {
    return AddStudentUiState(
      isButtonActive: isButtonActive ?? this.isButtonActive,
      calculatedAge: calculatedAge ?? this.calculatedAge,
    );
  }
}