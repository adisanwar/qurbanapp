import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qurban_app/helpers/adminController.dart';

class ResultQurban extends StatelessWidget {
  const ResultQurban({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.put(AdminController());
    return Scaffold(
    appBar: AppBar(
      title: const Text('Hasil Penghitungan Qurban'),
    ),
    body: Container(
      child: const Center(
        child: 
        Text("Selamat, Anda telah menyetorkan")),
        
      
    ),
    floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          adminController.getPdf();
        //
        },
        ),
    
    );
  }
}