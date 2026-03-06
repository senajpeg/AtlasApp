// lib/features/expert/screens/expert_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../providers/expert_provider.dart';
import '../models/expert_model.dart';

class ExpertScreen extends ConsumerWidget {
  const ExpertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experts = ref.watch(expertListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Uzmanlarımız"), 
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // 1. Arama Çubuğu [cite: 213]
          Padding(
            padding: EdgeInsets.all(4.w),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Uzman veya branş ara...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 2. Kategori Çipler [cite: 214-217]
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                _buildCategoryChip("Hepsi", true),
                _buildCategoryChip("Özel Eğitim", false),
                _buildCategoryChip("Dil Terapisi", false),
                _buildCategoryChip("Psikolog", false),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // 3. Uzman Listesi
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: experts.length,
              itemBuilder: (context, index) {
                final expert = experts[index];
                return _buildExpertCard(context, ref, expert);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 14.sp
        ),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildExpertCard(BuildContext context, WidgetRef ref, ExpertModel expert) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            // Profil İkonu [cite: 220]
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade50,
              child: Icon(Icons.person, size: 35, color: Colors.blue.shade400),
            ),
            SizedBox(width: 4.w),
            // Uzman Bilgileri [cite: 220-222, 231]
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expert.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  Text(expert.title, style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp)),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      Text(" ${expert.rating} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("• ${expert.experience}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13.sp)),
                    ],
                  ),
                ],
              ),
            ),
            // WhatsApp Yönlendirme (Telefon İkonu)
            IconButton(
              icon: const Icon(Icons.phone_android, color: Colors.green),
              onPressed: () {
                ref.read(expertActionsProvider).launchWhatsApp(expert.phoneNumber, expert.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}