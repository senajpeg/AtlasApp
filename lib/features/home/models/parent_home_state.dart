class ParentHomeUiState {
  final String userName;
  final String dailyTip;
  final bool isLoading;

  ParentHomeUiState({
    this.userName = "Mehmet", // Tasarımdaki isim [cite: 22]
    this.dailyTip = "RDT testini her 6 ayda bir tekrarlamak, gelişim takibi için uzmanlar tarafından önerilir.", // [cite: 25]
    this.isLoading = false,
  });

  ParentHomeUiState copyWith({
    String? userName,
    String? dailyTip,
    bool? isLoading,
  }) {
    return ParentHomeUiState(
      userName: userName ?? this.userName,
      dailyTip: dailyTip ?? this.dailyTip,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}