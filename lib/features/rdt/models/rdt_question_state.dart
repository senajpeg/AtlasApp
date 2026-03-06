class RdtQuestionState {
  // Kategori bazlı cevapları tutan Map: { "Dil-İletişim": {1: true, 2: false...} }
  final Map<String, Map<int, bool>> categoryAnswers;

  RdtQuestionState({
    this.categoryAnswers = const {},
  });

  RdtQuestionState copyWith({
    Map<String, Map<int, bool>>? categoryAnswers,
  }) {
    return RdtQuestionState(
      categoryAnswers: categoryAnswers ?? this.categoryAnswers,
    );
  }
}