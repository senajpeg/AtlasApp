import 'package:atlas_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../core/theme.dart';

enum AppRole { veli, ogretmen, yonetici }

final selectedRoleProvider = StateProvider<AppRole>((ref) => AppRole.veli);

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(selectedRoleProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      // İŞTE ÇÖZÜM: Klavye açıldığında içeriğin kaydırılmasını sağlar!
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 6.h), // Üstten biraz daha fazla boşluk
              // --- BAŞLIK KISMI (Visily stili) ---
              Text(
                'Tekrar Hoşgeldiniz',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark, // Visily'deki gibi koyu renk
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

              // --- "GİRİŞ ROLÜ" ETİKETİ ---
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

              // --- ROL SEÇİMİ KUTUSU (Kenarlıklı ve beyaz zemin) ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    _buildRoleButton(
                      context,
                      ref,
                      AppRole.veli,
                      'Veli',
                      currentRole,
                    ),
                    _buildRoleButton(
                      context,
                      ref,
                      AppRole.ogretmen,
                      'Öğretmen',
                      currentRole,
                    ),
                    _buildRoleButton(
                      context,
                      ref,
                      AppRole.yonetici,
                      'Yönetici',
                      currentRole,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // --- FORM KISMI (Visily'deki gibi ikonlu) ---
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-posta Adresi',
                  hintText: 'ornek@eposta.com',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  hintText: '••••••••',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.textGrey,
                  ),
                ),
              ),

              // --- ŞİFREMİ UNUTTUM (Sağa Dayalı) ---
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

              // --- GİRİŞ YAP BUTONU ---
              ElevatedButton(
                onPressed: () {},
                child: const Text('Giriş Yap', style: TextStyle(fontSize: 16)),
              ),

              SizedBox(height: 3.h),

              // --- KAYIT OL LİNKİ (İki renkli Visily stili) ---
              Center(
                child: TextButton(
                  // ... LoginScreen içindeki ilgili onPressed kısmı
                  onPressed: () {
                    final currentRole = ref.read(selectedRoleProvider);

                    if (currentRole == AppRole.yonetici) {
                      Navigator.pushNamed(context, AppRouter.managerRegister);
                    } else if (currentRole == AppRole.ogretmen) {
                      Navigator.pushNamed(context, AppRouter.teacherRegister);
                    } else {
                      Navigator.pushNamed(context, AppRouter.parentRegister);
                    }
                  },
                  child: RichText(
                    text: TextSpan(
                      text: currentRole == AppRole.veli
                          ? 'Hesabınız yok mu? '
                          : currentRole == AppRole.ogretmen
                          ? 'Kurum kodunuz var mı? '
                          : 'Kurumunuzu eklemek mi istiyorsunuz? ',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 15.sp,
                      ),
                      children: [
                        TextSpan(
                          text: currentRole == AppRole.veli
                              ? 'Hemen Kaydolun'
                              : currentRole == AppRole.ogretmen
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

  // --- ROL BUTONU ÇİZİCİ ---
  Widget _buildRoleButton(
    BuildContext context,
    WidgetRef ref,
    AppRole role,
    String text,
    AppRole currentRole,
  ) {
    final isSelected = currentRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(selectedRoleProvider.notifier).state = role;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(
              10,
            ), // Köşeleri hafif yuvarlattık
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
