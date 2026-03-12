import 'package:atlas_app/features/auth/screens/login_screen.dart';
import 'package:atlas_app/features/auth/screens/manager_register_screen.dart';
import 'package:atlas_app/features/auth/screens/parent_register_screen.dart';
import 'package:atlas_app/features/auth/screens/teacher_register_screen.dart';
import 'package:atlas_app/features/bep/screens/bep_goal_selection_screen.dart';
import 'package:atlas_app/features/bep/screens/bep_performance_screen.dart';
import 'package:atlas_app/features/bep/screens/bep_subject_selection_screen.dart';
import 'package:atlas_app/features/bep/screens/bep_summary_screen.dart';
import 'package:atlas_app/features/expert/screens/experts_screen.dart';
import 'package:atlas_app/features/home/screens/parent_home_screen.dart';
import 'package:atlas_app/features/home/screens/teacher_home_screen.dart';
import 'package:atlas_app/features/rdt/screens/rdt_age_selection_screen.dart';
import 'package:atlas_app/features/rdt/screens/rdt_category_screen.dart';
import 'package:atlas_app/features/rdt/screens/rdt_questionnaire_screen.dart';
import 'package:atlas_app/features/rdt/screens/rdt_result_screen.dart';
import 'package:atlas_app/features/student/screens/add_student_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String login = '/';
  static const String managerRegister = '/managerRegister';
  static const String teacherRegister = '/teacherRegister';
  static const String parentRegister = '/parentRegister';
  static const String parentHome = '/parentHome';
  static const String addStudent = '/addStudent';
  static const String rdtAgeSelection = '/rdt-age-selection';
  static const String rdtCategorySelection = '/rdt-category-selection';
  static const String rdtQuestionScreen = '/rdt-question-screen';
  static const String rdtResult = '/rdt-result';
  static const String expertScreen = '/expert-screen';
  static const String teacherHome = '/teacherHome';
  static const String bepSubjectSelection = '/bep-subject-selection';
  static const String bepPerformance = '/bep-performance';
  static const String bepPerformanceSummary = '/bep-performance-summary';
  static const String bepGoals = '/bep-goals';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case managerRegister:
        return MaterialPageRoute(builder: (_) => ManagerRegisterScreen());

      case teacherRegister:
        return MaterialPageRoute(builder: (_) => TeacherRegisterScreen());

      case parentRegister:
        return MaterialPageRoute(builder: (_) => ParentRegisterScreen());

      case parentHome:
        return MaterialPageRoute(builder: (_) => const ParentHomeScreen());

      case addStudent:
        return MaterialPageRoute(builder: (_) => const AddStudentScreen());

      case AppRouter.rdtAgeSelection:
        return MaterialPageRoute(builder: (_) => const RdtAgeSelectionScreen());

      case rdtCategorySelection:
        // Yaş seçim sayfasından gelen string'i yakalıyoruz
        final selectedAge = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => RdtCategoryScreen(ageTitle: selectedAge),
        );

      case rdtQuestionScreen:
        // Gönderilen kategori ismini (String) yakalıyoruz
        final categoryName = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => RdtQuestionScreen(categoryTitle: categoryName),
        );

      case rdtResult: // Sonuç sayfası rotası
        return MaterialPageRoute(builder: (_) => const RdtResultScreen());

      case expertScreen:
        return MaterialPageRoute(builder: (_) => const ExpertScreen());

      case teacherHome:
        return MaterialPageRoute(builder: (_) => const TeacherHomeScreen());

      case bepSubjectSelection:
        return MaterialPageRoute(builder: (_) => const BepSubjectScreen());

      case bepPerformance:
        return MaterialPageRoute(builder: (_) => const BepPerformanceScreen());

      case bepPerformanceSummary:
        return MaterialPageRoute(builder: (_) => const BepPerformanceSummaryScreen());  

      case bepGoals:
        return MaterialPageRoute(builder: (_) => const BepGoalsScreen());  



      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
