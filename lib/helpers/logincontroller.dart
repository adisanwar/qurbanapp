import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qurban_app/ui/admin/homepage.dart';
import 'package:qurban_app/ui/user/user.dart';

import '../auth/login.dart';

class LoginController extends GetxController {
  var isLoggedIn = false.obs;
  var userRole = 'user'.obs;
  var currentUserId = ''.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxMap<String, dynamic> userData = RxMap<String, dynamic>();
  // Rx<User?> currentUser = Rx<User?>();
  // final RxString userData = ''.obs;
  Rx<User?> currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
  
  // final RxString no_kk = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> getUserRole(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        // print(userDoc['wali']);
        return userDoc['role'] ?? '';
      } else {
        return '';
      }
    } catch (e) {
      print("Get User Role Error: $e");
      return '';
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
          Get.to(() => const HomePage());
        } else {
          Get.to(() => const UserPage());
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
      } 
    }
  }

  // Fungsi untuk mengambil detail pengguna dari currentUser
  Future<void> fetchUserDetail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // userDetail.value = user;
        final userDocId = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        userData.value = userDocId.data() ?? {};

        if (userDocId.exists) {
          Map<String, dynamic> userDataMap = userDocId.data() ?? {};
          // Jika dokumen pengguna dengan id yang sesuai ditemukan
          userData.value = userDocId['wali'];
          userData.value = userDocId['no_kk'];

          userData.value = userDataMap;
        }
      }
    } catch (e) {
      print("Fetch User Data Error: $e");
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.to(() =>
          const Login()); // Replace LoginPage() with the page you want to navigate to
    } catch (e) {
      // Handle any errors that occur during the logout process
      print("Error during logout: $e");
    }
  }
}
