import 'package:flutter/material.dart';

class ResultQurban extends StatelessWidget {
  const ResultQurban({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Hasil Penghitungan Qurban'),
    ),
    body: Container(
      child: const Center(
        child: 
        Text("Selamat, Anda telah menyetorkan"))
      ,
    ),
    );
  }
}