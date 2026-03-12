class TeacherHomeState {
  final String userName;
  final String schoolName;
  final int totalStudents;
  final int pendingRdt;
  final int readyBep;
  final List<TeacherStudentModel> students;
  final bool isLoading;

  TeacherHomeState({
    this.userName = "",
    this.schoolName = "",
    this.totalStudents = 0,
    this.pendingRdt = 0,
    this.readyBep = 0,
    this.students = const [],
    this.isLoading = false,
  });

  TeacherHomeState copyWith({
    String? userName,
    String? schoolName,
    int? totalStudents,
    int? pendingRdt,
    int? readyBep,
    List<TeacherStudentModel>? students,
    bool? isLoading,
  }) {
    return TeacherHomeState(
      userName: userName ?? this.userName,
      schoolName: schoolName ?? this.schoolName,
      totalStudents: totalStudents ?? this.totalStudents,
      pendingRdt: pendingRdt ?? this.pendingRdt,
      readyBep: readyBep ?? this.readyBep,
      students: students ?? this.students,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TeacherStudentModel {
  final String id;
  final String name;
  final String details;
  final String rdtStatus;
  final String bepStatus;
  final bool isBepReady;

  TeacherStudentModel({
    required this.id,
    required this.name,
    required this.details,
    required this.rdtStatus,
    required this.bepStatus,
    this.isBepReady = false,
  });
}