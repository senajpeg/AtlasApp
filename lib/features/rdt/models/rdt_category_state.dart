class RdtCategoryState {
  final bool isDilIletisimDone;
  final bool isBilisselDone;
  final bool isSosyalDuygusalDone;
  final bool isMotorDone;
  final bool isOzbakimDone;

  RdtCategoryState({
    this.isDilIletisimDone = false,
    this.isBilisselDone = false,
    this.isSosyalDuygusalDone = false,
    this.isMotorDone = false,
    this.isOzbakimDone = false,
  });

  // İlerlemeyi hesaplayan yardımcı fonksiyon
  double get progress {
    int count = 0;
    if (isDilIletisimDone) count++;
    if (isBilisselDone) count++;
    if (isSosyalDuygusalDone) count++;
    if (isMotorDone) count++;
    if (isOzbakimDone) count++;
    return count / 5;
  }

  // State'i güncellemek için copyWith
  RdtCategoryState copyWith({
    bool? isDilIletisimDone,
    bool? isBilisselDone,
    bool? isSosyalDuygusalDone,
    bool? isMotorDone,
    bool? isOzbakimDone,
  }) {
    return RdtCategoryState(
      isDilIletisimDone: isDilIletisimDone ?? this.isDilIletisimDone,
      isBilisselDone: isBilisselDone ?? this.isBilisselDone,
      isSosyalDuygusalDone: isSosyalDuygusalDone ?? this.isSosyalDuygusalDone,
      isMotorDone: isMotorDone ?? this.isMotorDone,
      isOzbakimDone: isOzbakimDone ?? this.isOzbakimDone,
    );
  }
}