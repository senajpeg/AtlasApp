// lib/features/expert/providers/expert_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/expert_model.dart';

// Uzman listesini yöneten provider [cite: 220-234]
final expertListProvider = Provider<List<ExpertModel>>((ref) {
  return [
    ExpertModel(
      id: "1",
      name: "Dr. Ahmet Yılmaz",
      title: "Kıdemli Özel Eğitim Uzmanı",
      experience: "12 Yıl Deneyim",
      rating: "4.8",
      phoneNumber: "905551234567",
      category: "Özel Eğitim",
    ),
    ExpertModel(
      id: "2",
      name: "Zeynep Demir",
      title: "Dil ve Konuşma Terapisti",
      experience: "8 Yıl Deneyim",
      rating: "4.7",
      phoneNumber: "905559876543",
      category: "Dil Terapisi",
    ),
    ExpertModel(
      id: "3",
      name: "Murat Can Esen",
      title: "Çocuk Psikoloğu",
      experience: "10 Yıl Deneyim",
      rating: "4.9",
      phoneNumber: "905550001122",
      category: "Psikolog",
    ),
  ];
});

// WhatsApp yönlendirme aksiyonları
final expertActionsProvider = Provider((ref) => ExpertActions());

class ExpertActions {
  Future<void> launchWhatsApp(String phone, String expertName) async {
    final message = "Merhaba $expertName, Atlas uygulaması üzerinden size ulaşıyorum. Çocuğumun gelişim süreci hakkında bilgi almak istiyorum.";
    final url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";
    
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}