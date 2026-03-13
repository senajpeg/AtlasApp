import 'package:atlas_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:atlas_app/core/theme.dart';
import '../providers/login_provider.dart';

enum AppRole { veli, ogretmen, yonetici }

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModel ve State bağlantısı
    final uiState = ref.watch(loginProvider);
    final viewModel = ref.read(loginProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 6.h),
              Text(
                'Tekrar Hoşgeldiniz',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),
              Text(
                'Lütfen giriş yapmak için rolünüzü seçin\nve bilgilerinizi girin.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),

              Text(
                'GİRİŞ ROLÜ',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGrey,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 1.5.h),

              // ROL SEÇİMİ
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    _buildRoleButton(
                      ref,
                      AppRole.veli,
                      'Veli',
                      uiState.selectedRole,
                    ),
                    _buildRoleButton(
                      ref,
                      AppRole.ogretmen,
                      'Öğretmen',
                      uiState.selectedRole,
                    ),
                    _buildRoleButton(
                      ref,
                      AppRole.yonetici,
                      'Yönetici',
                      uiState.selectedRole,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // E-POSTA
              TextField(
                controller: viewModel.emailController,
                onChanged: (_) => viewModel.checkInputs(),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-posta Adresi',
                  hintText: 'ornek@eposta.com',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // ŞİFRE
              TextField(
                controller: viewModel.passwordController,
                onChanged: (_) => viewModel.checkInputs(),
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  hintText: '••••••••',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.textGrey,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Şifremi Unuttum',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 1.h),

              // GİRİŞ BUTONU
              ElevatedButton(
                onPressed: uiState.isButtonActive
                    ? () {
                        // Seçili role göre ilgili ana sayfaya yönlendirme yapıyoruz
                        if (uiState.selectedRole == AppRole.veli) {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.parentHome,
                          );
                        } else if (uiState.selectedRole == AppRole.ogretmen) {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.teacherHome,
                          );
                        } else if (uiState.selectedRole == AppRole.yonetici) {
                          // Yönetici ana sayfası henüz yoksa geçici olarak Teacher Home'a atıyoruz
                          // İleride burayı AppRouter.managerHome olarak güncelleyebilirsin
                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.teacherHome,
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: uiState.isButtonActive
                      ? AppColors.primaryBlue
                      : Colors.grey.shade400,
                ),
                child: const Text('Giriş Yap', style: TextStyle(fontSize: 16)),
              ),

              SizedBox(height: 3.h),

              // KAYIT OL LİNKİ
              Center(
                child: TextButton(
                  onPressed: () {
                    if (uiState.selectedRole == AppRole.yonetici) {
                      Navigator.pushNamed(context, AppRouter.managerRegister);
                    } else if (uiState.selectedRole == AppRole.ogretmen) {
                      Navigator.pushNamed(context, AppRouter.teacherRegister);
                    } else {
                      Navigator.pushNamed(context, AppRouter.parentRegister);
                    }
                  },
                  child: RichText(
                    text: TextSpan(
                      text: uiState.selectedRole == AppRole.veli
                          ? 'Hesabınız yok mu? '
                          : uiState.selectedRole == AppRole.ogretmen
                          ? 'Kurum kodunuz var mı? '
                          : 'Kurumunuzu eklemek mi istiyorsunuz? ',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 15.sp,
                      ),
                      children: [
                        TextSpan(
                          text: uiState.selectedRole == AppRole.veli
                              ? 'Hemen Kaydolun'
                              : uiState.selectedRole == AppRole.ogretmen
                              ? 'Öğretmen Kaydı'
                              : 'Kurum Kaydet',
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(
    WidgetRef ref,
    AppRole role,
    String text,
    AppRole selectedRole,
  ) {
    final isSelected = selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(loginProvider.notifier).setRole(role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textGrey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}
