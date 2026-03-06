import 'package:atlas_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../providers/parent_register_provider.dart';

class ParentRegisterScreen extends ConsumerWidget {
  const ParentRegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(parentRegisterProvider);
    final viewModel = ref.read(parentRegisterProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Yeni Veli Hesabı Oluştur",
          style: TextStyle(color: Colors.black, fontSize: 17.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 7.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h),
              Text("Hoş Geldiniz", 
                style: TextStyle(color: const Color(0xFF2196F3), fontSize: 22.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 1.h),
              Text("Çocuğunuzun gelişimini takip etmek için\nbilgilerinizi giriniz.", 
                style: TextStyle(color: Colors.black54, fontSize: 15.sp)),
              SizedBox(height: 4.h),

              _buildLabel("Ad Soyad"),
              _buildCustomField(
                controller: viewModel.nameController,
                hint: "Örn: Ayşe Demir",
                icon: Icons.person_outline,
                onChanged: viewModel.checkValidation,
              ),

              SizedBox(height: 2.5.h),
              _buildLabel("E-posta Adresi"),
              _buildCustomField(
                controller: viewModel.emailController,
                hint: "ornek@email.com",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onChanged: viewModel.checkValidation,
              ),

              SizedBox(height: 2.5.h),
              _buildLabel("Telefon Numarası"),
              _buildCustomField(
                controller: viewModel.phoneController,
                hint: "0555 123 45 67",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onChanged: viewModel.checkValidation,
              ),

              SizedBox(height: 2.5.h),
              _buildLabel("Şifre Belirleyin"),
              _buildPasswordField(
                controller: viewModel.passwordController,
                hint: "En az 6 karakter",
                obscure: uiState.obscurePassword,
                toggle: viewModel.togglePassword,
                onChanged: viewModel.checkValidation,
              ),

              SizedBox(height: 2.5.h),
              _buildLabel("Şifre Tekrarı"),
              _buildPasswordField(
                controller: viewModel.confirmPasswordController,
                hint: "Şifrenizi tekrar giriniz",
                obscure: uiState.obscureConfirmPassword,
                isCheckIcon: true,
                toggle: viewModel.toggleConfirmPassword,
                onChanged: viewModel.checkValidation,
              ),

              SizedBox(height: 4.h),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: uiState.isFormValid ? () {
                    Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uiState.isFormValid ? const Color(0xFF2196F3) : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Kayıt Ol", 
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              SizedBox(height: 3.h),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 15.sp),
                      children: const [
                        TextSpan(text: "Zaten hesabınız var mı? "),
                        TextSpan(text: "Giriş Yap", 
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI HELPER METODLAR ---
  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
      );

  Widget _buildCustomField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required VoidCallback onChanged,
    TextInputType? keyboardType,
  }) =>
      Container(
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
        child: TextFormField(
          controller: controller,
          onChanged: (_) => onChanged(),
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint, 
            prefixIcon: Icon(icon, color: Colors.black45), 
            border: InputBorder.none, 
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10)
          ),
        ),
      );

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback toggle,
    required VoidCallback onChanged,
    bool isCheckIcon = false,
  }) =>
      Container(
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
        child: TextFormField(
          controller: controller,
          obscureText: obscure,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(isCheckIcon ? Icons.check_circle_outline : Icons.lock_outline, color: Colors.black45),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.black45), 
              onPressed: toggle
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          ),
        ),
      );
}