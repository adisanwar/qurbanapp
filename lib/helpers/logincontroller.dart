import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qurban_app/ui/admin/homepage.dart';
import 'package:qurban_app/ui/user/user.dart';

class LoginController extends GetxController {
  var isLoggedIn = false.obs;
  var userRole = 'user'.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> getUserRole(String userId) async {
  try {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc['role'] ?? 'user';
    } else {
      return 'user';
    }
  } catch (e) {
    print("Get User Role Error: $e");
    return 'user';
  }
}


  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = _auth.currentUser;

      if (user != null) {
        userRole.value = await getUserRole(user.uid);
        isLoggedIn.value = true;

        // Arahkan pengguna ke halaman yang sesuai
        if (userRole.value == 'admin') {
          Get.to(()=>HomePage());
        } else {
          Get.to(()=> UserPage());
        }
      }
    } catch (e) {
      print(e);

      if (e is FirebaseAuthException) {
        // Jika kesalahan adalah jenis FirebaseAuthException, kita dapat memeriksa kode kesalahan.
        if (e.code == 'user-not-found') {
          // Email tidak ditemukan
          Get.snackbar(
            'Login Gagal',
            'Email tidak terdaftar',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (e.code == 'wrong-password') {
          // Password salah
          Get.snackbar(
            'Login Gagal',
            'Password salah',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          // Kesalahan lain
          Get.snackbar(
            'Login Gagal',
            'Terjadi kesalahan saat login',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Kesalahan umum
        Get.snackbar(
          'Login Gagal',
          'Terjadi kesalahan saat login',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  // Fungsi getUserRole tetap sama seperti sebelumnya.
  
  Future<void> logout() async {
    await _auth.signOut();
    isLoggedIn.value = false;
    userRole.value = 'guest';
  }
}
