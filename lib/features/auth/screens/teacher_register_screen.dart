import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:atlas_app/core/app_router.dart';
import '../providers/teacher_register_provider.dart';

class TeacherRegisterScreen extends ConsumerWidget {
  const TeacherRegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(teacherRegisterProvider);
    final viewModel = ref.read(teacherRegisterProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Yeni Öğretmen Kaydı",
          style: TextStyle(color: Colors.black, fontSize: 17.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SENİN ÖZEL BİLGİ KUTUCUĞUN ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.grey),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "Kayıt olabilmek için kurum yöneticinizden aldığınız 6 haneli davet koduna ihtiyacınız vardır.",
                        style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),

              // --- KURUM BİLGİLERİ ---
              _buildSectionTitle("KURUM BİLGİLERİ"),
              _buildFieldLabel("Kurum Davet Kodu"),
              TextFormField(
                controller: viewModel.codeController,
                onChanged: (_) => viewModel.checkValidation(),
                decoration: InputDecoration(
                  hintText: "Örn: ZIL-9X2A",
                  prefixIcon: const Icon(Icons.lock_open_outlined, color: Colors.blue),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
              ),
              const Divider(height: 40),

              // --- KİŞİSEL BİLGİLER ---
              _buildSectionTitle("KİŞİSEL BİLGİLER"),
              _buildFieldLabel("Ad Soyad"),
              _buildTextField(viewModel.nameController, "Örn: Ayşe Demir", Icons.person_outline, viewModel.checkValidation),
              
              SizedBox(height: 2.h),
              _buildFieldLabel("E-posta Adresi"),
              _buildTextField(viewModel.emailController, "ornek@email.com", Icons.email_outlined, viewModel.checkValidation, keyboardType: TextInputType.emailAddress),

              SizedBox(height: 2.h),
              _buildFieldLabel("Telefon Numarası"),
              _buildTextField(viewModel.phoneController, "0555 123 45 67", Icons.phone_outlined, viewModel.checkValidation, keyboardType: TextInputType.phone),
              
              const Divider(height: 40),

              // --- HESAP GÜVENLİĞİ ---
              _buildSectionTitle("HESAP GÜVENLİĞİ"),
              _buildFieldLabel("Şifre"),
              _buildPasswordField(viewModel.passwordController, "••••••••", uiState.obscurePassword, viewModel.togglePassword, viewModel.checkValidation),

              SizedBox(height: 2.h),
              _buildFieldLabel("Şifre Tekrar"),
              _buildPasswordField(viewModel.confirmPasswordController, "••••••••", uiState.obscureConfirmPassword, viewModel.toggleConfirmPassword, viewModel.checkValidation),

              SizedBox(height: 4.h),

              // --- KAYIT BUTONU ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: uiState.isFormValid ? () {
                    Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uiState.isFormValid ? const Color(0xFF1E88E5) : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Öğretmen Olarak Kayıt Ol", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),

              SizedBox(height: 2.h),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 15.sp),
                      children: const [
                        TextSpan(text: "Zaten hesabınız var mı? "),
                        TextSpan(text: "Giriş Yap", style: TextStyle(color: Color(0xFF1E88E5), fontWeight: FontWeight.bold)),
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

  // --- SENİN ÖZEL HELPER METODLARIN ---
  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
      );

  Widget _buildFieldLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
      );

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, VoidCallback onChanged, {TextInputType? keyboardType}) => TextFormField(
        controller: controller,
        onChanged: (_) => onChanged(),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
        ),
      );

  Widget _buildPasswordField(TextEditingController controller, String hint, bool obscure, VoidCallback toggle, VoidCallback onChanged) => TextFormField(
        controller: controller,
        obscureText: obscure,
        onChanged: (_) => onChanged(),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.key_outlined, color: Colors.grey),
          suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: toggle),
        ),
      );
}