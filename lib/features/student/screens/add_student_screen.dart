import 'package:atlas_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../providers/add_student_provider.dart';

class AddStudentScreen extends ConsumerStatefulWidget {
  const AddStudentScreen({super.key});

  @override
  ConsumerState<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends ConsumerState<AddStudentScreen> {
  // Tarih maskesi burada tanımlanır (GG/AA/YYYY)
  final maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(addStudentProvider);
    final viewModel = ref.read(addStudentProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Yeni Öğrenci Ekle",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Öğrenci Bilgileri",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 1.h),
              Text(
                "Değerlendirme sürecine başlamak için lütfen aşağıdaki zorunlu alanları doldurunuz.",
                style: TextStyle(fontSize: 15.sp, color: Colors.black54),
              ),
              SizedBox(height: 4.h),

              _buildFieldLabel("Adı Soyadı"),
              _buildTextField(
                viewModel.nameController,
                "Örn: Ali Yılmaz",
                Icons.person_outline,
                viewModel.checkInputs,
              ),

              SizedBox(height: 2.5.h),
              _buildFieldLabel("Doğum Tarihi"),
              _buildTextField(
                viewModel.dateController,
                "GG/AA/YYYY",
                Icons.calendar_today_outlined,
                viewModel.checkInputs,
                keyboardType: TextInputType.number,
                inputFormatters: [maskFormatter], // MASKE BURADA
              ),

              SizedBox(height: 2.5.h),
              _buildFieldLabel("Varsa Okulu"),
              _buildTextField(
                viewModel.schoolController,
                "Okul adını giriniz...",
                Icons.school_outlined,
                viewModel.checkInputs,
              ),

              SizedBox(height: 2.5.h),
              _buildFieldLabel("Sınıf - Şube"),
              _buildTextField(
                viewModel.classController,
                "Örn: 2/B",
                Icons.meeting_room_outlined,
                viewModel.checkInputs,
              ),

              SizedBox(height: 2.5.h),
              _buildFieldLabel("İl - İlçe"),
              _buildTextField(
                viewModel.locationController,
                "Örn: Ankara, Çankaya",
                Icons.location_on_outlined,
                viewModel.checkInputs,
              ),

              SizedBox(height: 4.h),

              // Bilgi Kutusu
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "Kaydet butonuna bastığınızda girilen doğum tarihine göre öğrencinin yaşı otomatik olarak hesaplanacaktır.",
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5.h),

              // Kaydet Butonu
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: uiState.isButtonActive
                      ? () {
                          viewModel.onSaveAndCalculate(() {
                            _showAgeDialog(
                              context,
                              uiState.calculatedAge ?? "24 Ay",
                            );
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uiState.isButtonActive
                        ? const Color(0xFF1E88E5)
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Kaydet ve Yaş Hesapla",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showAgeDialog(BuildContext context, String age) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, color: Colors.black54, size: 40),
            SizedBox(height: 2.h),
            Text(
              "Bilgilendirme",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              "Çocuğunuzun takvim ay yaşı",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.sp),
            ),
            Text(
              "$age'dır.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.pop(context),
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.parentHome,
                    (route) => false,
                  ),
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Tamam",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        fontSize: 15.sp,
      ),
    ),
  );

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
    VoidCallback onChanged, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) => TextFormField(
    controller: controller,
    onChanged: (_) => onChanged(),
    keyboardType: keyboardType,
    inputFormatters: inputFormatters, // BURAYI EKLEDİK
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey, size: 22),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
