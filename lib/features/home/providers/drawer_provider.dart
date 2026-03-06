import 'package:flutter_riverpod/flutter_riverpod.dart';

// Seçili olan menü index'ini tutan basit bir provider
// Başlangıç değeri 0 (Anasayfa)
final drawerIndexProvider = StateProvider<int>((ref) => 0);