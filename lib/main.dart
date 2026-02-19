import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'core/theme.dart'; // Az önce yazdığımız kendi tema dosyamız

void main() {
  // Uygulamayı Riverpod (State Management) sarmalayıcısı ile başlatıyoruz.
  // Bu sayede uygulamanın her yerinden verilere (örn: öğrencinin yaşına) ulaşabileceğiz.
  runApp(const ProviderScope(child: OzelEgitimApp()));
}

class OzelEgitimApp extends StatelessWidget {
  const OzelEgitimApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tüm ekranlarda (telefon/tablet) boyutların bozulmaması için ResponsiveSizer sarmalayıcısı
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Özel Eğitim BEP',
          debugShowCheckedModeBanner: false, // Sağ üstteki kırmızı "DEBUG" etiketini kaldırır
          theme: AppTheme.lightTheme, // Kendi kurumsal temamızı (Mavi-Gri) sisteme bağladık!
          
          // Şimdilik sistemin çalıştığını görmek için geçici bir boş ekran
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Sistem Hazır'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Mimarimiz Başarıyla Kuruldu! 🎉',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    // Bu buton otomatik olarak theme.dart'taki mavi rengi ve yuvarlak köşeleri alacak
                    child: const Text('Tema Test Butonu'), 
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}