// main.dart
import 'package:atlas_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'core/theme.dart';


void main() {
  runApp(const ProviderScope(child: OzelEgitimApp()));
}

class OzelEgitimApp extends StatelessWidget {
  const OzelEgitimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Özel Eğitim BEP',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          
          // --- NAVİGASYON AYARLARI ---
          initialRoute: AppRouter.rdtResult, // Uygulama hangi sayfayla başlasın?
          onGenerateRoute: AppRouter.generateRoute, // Rotaları kim yönetsin?
        );
      },
    );
  }
}