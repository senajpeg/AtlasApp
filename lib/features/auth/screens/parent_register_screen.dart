import 'package:atlas_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:atlas_app/core/theme.dart';

class ParentRegisterScreen extends StatefulWidget {
  const ParentRegisterScreen({super.key});

  @override
  State<ParentRegisterScreen> createState() => _ParentRegisterScreenState();
}

class _ParentRegisterScreenState extends State<ParentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  bool get _isFormValid {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^05[0-9]{9}$');

    return _nameController.text.isNotEmpty &&
           emailRegex.hasMatch(_emailController.text) &&
           phoneRegex.hasMatch(_phoneController.text.replaceAll(' ', '')) &&
           _passwordController.text.length >= 6 &&
           _passwordController.text == _confirmPasswordController.text;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          // Sadece bir önceki sayfaya döner
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Yeni Veli Hesabı Oluştur",
          style: TextStyle(color: Colors.black, fontSize: 17.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 7.w),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h),
              Text("Hoş Geldiniz", style: TextStyle(color: const Color(0xFF2196F3), fontSize: 22.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 1.h),
              Text("Çocuğunuzun gelişimini takip etmek için\nbilgilerinizi giriniz.", style: TextStyle(color: Colors.black54, fontSize: 15.sp)),
              SizedBox(height: 4.h),

              _buildLabel("Ad Soyad"),
              _buildCustomField(
                controller: _nameController,
                hint: "Örn: Ayşe Demir",
                icon: Icons.person_outline,
                validator: (v) => (v == null || v.isEmpty) ? "Ad Soyad gerekli" : null,
              ),

              SizedBox(height: 2.5.h),
              _buildLabel("E-posta Adresi"),
              _buildCustomField(
                controller: _emailController,
                hint: "ornek@email.com",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return "E-posta gerekli";
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return "Geçersiz format";
                  return null;
                },
              ),

              SizedBox(height: 2.5.h),
              _buildLabel("Telefon Numarası"),
              _buildCustomField(
                controller: _phoneController,
                hint: "0555 123 45 67",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Telefon gerekli";
                  if (!RegExp(r'^05[0-9]{9}$').hasMatch(v.replaceAll(' ', ''))) return "05xx... şeklinde 11 hane girin";
                  return null;
                },
              ),

              SizedBox(height: 2.5.h),
              _buildLabel("Şifre Belirleyin"),
              _buildPasswordField(
                controller: _passwordController,
                hint: "En az 6 karakter",
                obscure: _obscurePassword,
                toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                validator: (v) => (v != null && v.length < 6) ? "En az 6 karakter gerekli" : null,
              ),

              SizedBox(height: 2.5.h),
              _buildLabel("Şifre Tekrarı"),
              _buildPasswordField(
                controller: _confirmPasswordController,
                hint: "Şifrenizi tekrar giriniz",
                obscure: _obscureConfirmPassword,
                isCheckIcon: true,
                toggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                validator: (v) => v != _passwordController.text ? "Şifreler eşleşmiyor" : null,
              ),

              SizedBox(height: 4.h),

              // --- KAYIT OL BUTONU ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isFormValid ? () {
                    // Kayıt başarılı olduktan sonra Login'e tertemiz bir dönüş yapalım
                    Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kayıt Başarılı! Giriş yapabilirsiniz.")));
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid ? const Color(0xFF2196F3) : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Kayıt Ol", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              
              SizedBox(height: 3.h),
              Center(
                child: GestureDetector(
                  // İŞTE KRİTİK DEĞİŞİKLİK: Login sayfasına AppRouter üzerinden dönüyoruz
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 15.sp),
                      children: const [
                        TextSpan(text: "Zaten hesabınız var mı? "),
                        TextSpan(text: "Giriş Yap", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
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

  // --- HELPER METODLAR (Aynı kaldı) ---
  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
      );

  Widget _buildCustomField({required TextEditingController controller, required String hint, required IconData icon, TextInputType? keyboardType, String? Function(String?)? validator}) => Container(
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: Colors.black45), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
        ),
      );

  Widget _buildPasswordField({required TextEditingController controller, required String hint, required bool obscure, required VoidCallback toggle, String? Function(String?)? validator, bool isCheckIcon = false}) => Container(
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
        child: TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(isCheckIcon ? Icons.check_circle_outline : Icons.lock_outline, color: Colors.black45),
            suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.black45), onPressed: toggle),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          ),
        ),
      );
}