import 'package:atlas_app/features/auth/screens/login_screen.dart';
import 'package:atlas_app/features/auth/screens/manager_register_screen.dart';
import 'package:atlas_app/features/auth/screens/parent_register_screen.dart';
import 'package:atlas_app/features/auth/screens/teacher_register_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String login = '/';
  static const String managerRegister = '/managerRegister';
  static const String teacherRegister = '/teacherRegister';
  static const String parentRegister = '/parentRegister';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case managerRegister:
        return MaterialPageRoute(builder: (_) => const ManagerRegisterScreen());

      case teacherRegister:
        return MaterialPageRoute(builder: (_) => const TeacherRegisterScreen());

      case parentRegister:
        return MaterialPageRoute(builder: (_) => const ParentRegisterScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
