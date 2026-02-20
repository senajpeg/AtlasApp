import 'package:atlas_app/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ManagerSuccessDialog extends StatelessWidget {
  final String institutionCode;

  const ManagerSuccessDialog({super.key, required this.institutionCode});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text("Kayıt Başarılı!", textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 16),
          const Text(
            "Kurumunuz oluşturuldu. Personel ve velilerle paylaşacağınız kod:",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Kodun göründüğü kutu
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueGrey),
            ),
            child: Text(
              institutionCode,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: institutionCode));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Kod kopyalandı!")));
          },
          child: const Text("Kodu Kopyala"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
          },
          child: const Text("Giriş Ekranına Dön"),
        ),
      ],
    );
  }
}
