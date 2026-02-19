import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Visily tasarımındaki kurumsal renklerimiz
  static const Color primaryBlue = Color(0xFF1E88E5); // Marka mavisi
  static const Color backgroundGrey = Color(0xFFF5F7FA); // Arka plan açık gri
  static const Color white = Colors.white; // Kartlar ve formlar için
  
  // Metin Renkleri
  static const Color textDark = Color(0xFF2D3748); // Koyu başlıklar için
  static const Color textGrey = Color(0xFF718096); // Alt yazılar için
  
  // Durum Renkleri (Yapar/Yapamaz butonları ve uyarılar için)
  static const Color successGreen = Color(0xFF38A169); // Yapar - Başarılı
  static const Color errorRed = Color(0xFFE53E3E); // Yapamaz - Risk
  static const Color warningOrange = Color(0xFFDD6B20); // Bekleyen durumlar
}

class AppTheme {
  // Tüm uygulamanın standart tasarım ayarları
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundGrey,
      primaryColor: AppColors.primaryBlue,
      
      // Modern Google Font'u (Inter veya Nunito çok yakışır)
      textTheme: GoogleFonts.nunitoTextTheme().apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      
      // Butonların standart görünümü
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Visily'deki yumuşak köşeler
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // TextField (Girdi alanları) standart görünümü
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}