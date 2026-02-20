import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod'u testlere de ekliyoruz
import 'package:atlas_app/main.dart'; // Senin projendeki main.dart dosyası

void main() {
  testWidgets('Uygulama açılış ve giriş ekranı testi', (WidgetTester tester) async {
    // 1. UYGULAMAYI BAŞLAT:
    // Riverpod kullandığımız için test ortamında da uygulamayı ProviderScope ile sarmalamak zorundayız.
    await tester.pumpWidget(const ProviderScope(child: OzelEgitimApp()));

    // Ekranın tam çizilmesi ve animasyonların bitmesi için biraz bekle komutu
    await tester.pumpAndSettle();

    // 2. KONTROL ET (Test):
    // Ekranda "Tekrar Hoş Geldiniz" yazısı var mı? (LoginScreen'deki başlığımız)
    expect(find.text('Tekrar Hoş Geldiniz'), findsOneWidget);

    // Ekranda "Giriş Yap" yazan bir buton veya metin var mı?
    expect(find.text('Giriş Yap'), findsWidgets);

    // Eski sayaç mantığındaki "0" yazısının OLMADIĞINI doğrula
    expect(find.text('0'), findsNothing);
  });
}