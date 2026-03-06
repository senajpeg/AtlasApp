import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/manager_register_provider.dart';
import 'manager_success_dialog.dart';

class ManagerRegisterScreen extends ConsumerWidget {
  const ManagerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(managerRegisterProvider);
    final viewModel = ref.read(managerRegisterProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Müdür Kaydı")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: viewModel.managerNameController,
              onChanged: (_) => viewModel.checkInputs(),
              decoration: const InputDecoration(
                labelText: "Ad Soyad", 
                prefixIcon: Icon(Icons.person)
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: viewModel.schoolNameController,
              onChanged: (_) => viewModel.checkInputs(),
              decoration: const InputDecoration(
                labelText: "Kurum Adı", 
                prefixIcon: Icon(Icons.business)
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: uiState.isButtonActive ? () {
                  // Dialog'u açarken kodu ViewModel'den istiyoruz
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ManagerSuccessDialog(
                      institutionCode: viewModel.generateInstitutionCode(),
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: uiState.isButtonActive ? Colors.blue : Colors.grey,
                ),
                child: const Text("Kayıt Ol ve Kurum Oluştur"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}