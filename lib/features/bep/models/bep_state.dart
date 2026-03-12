class BepState {
  final String? studentId;
  final String? studentName;
  
  // Döngü için eklendi
  final List<String> allSubjects; // Seçilen tüm derslerin listesi
  final String? currentSubject; // O an işlem yapılan ders

  // Her dersin verisini ayrı ayrı tutan haritalar (Key: Ders Adı)
  final Map<String, List<String>> currentGoals; 
  final Map<String, Map<int, bool>> evaluations; 
  final Map<String, List<String>> shortTermGoals; 
  final Map<String, List<String>> longTermGoals; 

  BepState({
    this.studentId,
    this.studentName,
    this.allSubjects = const ["Türkçe", "Matematik", "Hayat Bilgisi", "Oyun ve Fiziki Etkinlikler"],
    this.currentSubject,
    this.currentGoals = const {},
    this.evaluations = const {},
    this.shortTermGoals = const {},
    this.longTermGoals = const {},
  });

  BepState copyWith({
    String? studentId,
    String? studentName,
    List<String>? allSubjects,
    String? currentSubject,
    Map<String, List<String>>? currentGoals,
    Map<String, Map<int, bool>>? evaluations,
    Map<String, List<String>>? shortTermGoals,
    Map<String, List<String>>? longTermGoals,
  }) {
    return BepState(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      allSubjects: allSubjects ?? this.allSubjects,
      currentSubject: currentSubject ?? this.currentSubject,
      currentGoals: currentGoals ?? this.currentGoals,
      evaluations: evaluations ?? this.evaluations,
      shortTermGoals: shortTermGoals ?? this.shortTermGoals,
      longTermGoals: longTermGoals ?? this.longTermGoals,
    );
  }
}