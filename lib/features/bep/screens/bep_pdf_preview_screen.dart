import 'package:atlas_app/features/bep/providers/bep_provider.dart';
import 'package:atlas_app/features/bep/utills/bep_pdf_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart'; // Eklendi

class BepPdfPreviewScreen extends ConsumerWidget {
  const BepPdfPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bepState = ref.watch(bepProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rapor Önizleme", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      // PdfPreview widget'ı printing paketinden gelir, paylaşma/yazdırma ikonlarını otomatik sunar
      body: PdfPreview(
        build: (format) => BepPdfGenerator.generateBepPdf(bepState),
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
    );
  }
}