import 'package:flutter/material.dart';
import 'manager_success_dialog.dart'; // Oluşturduğumuz dialogu import ettik

class ManagerRegisterScreen extends StatefulWidget {
  const ManagerRegisterScreen({super.key});

  @override
  State<ManagerRegisterScreen> createState() => _ManagerRegisterScreenState();
}

class _ManagerRegisterScreenState extends State<ManagerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _managerName = TextEditingController();
  final _schoolName = TextEditingController();

  // Şimdilik rastgele kod üreten fonksiyon
  String _generateCode() => "MUD-${DateTime.now().millisecond}X";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Müdür Kaydı")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _managerName,
                decoration: const InputDecoration(labelText: "Ad Soyad", prefixIcon: Icon(Icons.person)),
                validator: (v) => v!.isEmpty ? "Ad boş bırakılamaz" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _schoolName,
                decoration: const InputDecoration(labelText: "Kurum Adı", prefixIcon: Icon(Icons.business)),
                validator: (v) => v!.isEmpty ? "Kurum adı boş bırakılamaz" : null,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Kayıt işlemi simülasyonu
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => ManagerSuccessDialog(institutionCode: _generateCode()),
                      );
                    }
                  },
                  child: const Text("Kayıt Ol ve Kurum Oluştur"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}