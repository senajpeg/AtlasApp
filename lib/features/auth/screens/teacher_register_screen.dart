import 'package:atlas_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:atlas_app/core/theme.dart';

class TeacherRegisterScreen extends StatefulWidget {
  const TeacherRegisterScreen({super.key});

  @override
  State<TeacherRegisterScreen> createState() => _TeacherRegisterScreenState();
}

class _TeacherRegisterScreenState extends State<TeacherRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Kontrolcüler
  final _codeController = TextEditingController();
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
    _codeController.addListener(() => setState(() {}));
    _nameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  bool get _isFormValid {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^05[0-9]{9}$');

    return _codeController.text.isNotEmpty && 
           _nameController.text.isNotEmpty &&
           emailRegex.hasMatch(_emailController.text) &&
           phoneRegex.hasMatch(_phoneController.text.replaceAll(' ', '')) &&
           _passwordController.text.length >= 6 &&
           _passwordController.text == _confirmPasswordController.text;
  }

  @override
  void dispose() {
    _codeController.dispose();
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BİLGİ KUTUCUĞU ---
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

              _buildSectionTitle("KURUM BİLGİLERİ"),
              _buildFieldLabel("Kurum Davet Kodu"),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  hintText: "Örn: ZIL-9X2A",
                  prefixIcon: const Icon(Icons.lock_open_outlined, color: Colors.blue),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
                validator: (v) => (v == null || v.isEmpty) ? "Davet kodu gerekli" : null,
              ),
              const Divider(height: 40),

              _buildSectionTitle("KİŞİSEL BİLGİLER"),
              _buildFieldLabel("Ad Soyad"),
              _buildTextField(_nameController, "Örn: Ayşe Demir", Icons.person_outline, (v) => v!.isEmpty ? "Ad Soyad gerekli" : null),
              
              SizedBox(height: 2.h),
              _buildFieldLabel("E-posta Adresi"),
              _buildTextField(_emailController, "ornek@email.com", Icons.email_outlined, (v) {
                if (v == null || v.isEmpty) return "E-posta gerekli";
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return "Lütfen doğru email formatında giriniz";
                return null;
              }, keyboardType: TextInputType.emailAddress),

              SizedBox(height: 2.h),
              _buildFieldLabel("Telefon Numarası"),
              _buildTextField(_phoneController, "0555 123 45 67", Icons.phone_outlined, (v) {
                if (v == null || v.isEmpty) return "Telefon gerekli";
                if (!RegExp(r'^05[0-9]{9}$').hasMatch(v.replaceAll(' ', ''))) return "Geçerli bir telefon numarası giriniz (05xx...)";
                return null;
              }, keyboardType: TextInputType.phone),
              
              const Divider(height: 40),

              _buildSectionTitle("HESAP GÜVENLİĞİ"),
              _buildFieldLabel("Şifre"),
              _buildPasswordField(_passwordController, "••••••••", _obscurePassword, () {
                setState(() => _obscurePassword = !_obscurePassword);
              }, (v) => (v != null && v.length < 6) ? "Şifre en az 6 karakter olmalıdır" : null),

              SizedBox(height: 2.h),
              _buildFieldLabel("Şifre Tekrar"),
              _buildPasswordField(_confirmPasswordController, "••••••••", _obscureConfirmPassword, () {
                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
              }, (v) => v != _passwordController.text ? "Şifreler eşleşmiyor" : null),

              SizedBox(height: 4.h),

              // --- KAYIT BUTONU ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isFormValid ? () {
                    // Kayıt başarılı işlemi sonrası Login'e dönüş
                    Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Öğretmen kaydı alındı! Giriş yapabilirsiniz.")));
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid ? const Color(0xFF1E88E5) : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Öğretmen Olarak Kayıt Ol", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),

              SizedBox(height: 2.h),
              Center(
                child: GestureDetector(
                  // İŞTE KRİTİK DEĞİŞİKLİK: Login sayfasına AppRouter üzerinden dönüyoruz
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

  // --- HELPER METODLAR (Aynı kaldı) ---
  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
      );

  Widget _buildFieldLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
      );

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, String? Function(String?)? validator, {TextInputType? keyboardType}) => TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
        ),
      );

  Widget _buildPasswordField(TextEditingController controller, String hint, bool obscure, VoidCallback toggle, String? Function(String?)? validator) => TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.key_outlined, color: Colors.grey),
          suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: toggle),
        ),
      );
}