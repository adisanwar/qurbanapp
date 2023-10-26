import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:qurban_app/ui/admin/screen/userControl.dart';

class AdminController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isRegistered = false.obs;


  Future<void> scanQR() async {
  String barcodeScanRes;
  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff5722', 'Cancel', true, ScanMode.QR);
    debugPrint(barcodeScanRes);

    if (barcodeScanRes.isNotEmpty) {
      // Melakukan pemindaian kode QR yang berhasil. 
      // final userModel = UserModel(nokk: 'no_kk', name: 'wali', phone: 'phone', role: 'user', getqurban: false/* sesuaikan parameter sesuai kebutuhan */);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('no_kk', isEqualTo: barcodeScanRes)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Nomor KK ditemukan di Firebase, maka lakukan pembaruan.
        final userDoc = querySnapshot.docs.first;

        // Lakukan pembaruan pada dokumen pengguna di Firebase.
        await userDoc.reference.update({
          'getqurban': true,
        });

        Get.snackbar("Barcode", "User sudah menerima jatah Qurban", backgroundColor: Colors.green,
          colorText: Colors.white,);
      } else {
        Get.snackbar("Barcode", "No user found with this KK", backgroundColor: Colors.red,
          colorText: Colors.white,);
      }
    }
  } on PlatformException {
    barcodeScanRes = 'Failed to get Platform version';
  } 
}


Future<void> addUser(
    
      String email, String password, String noKk, String phone, String wali, String role) async {
    try {
      print('Email: $email');
    print('Password: $password');
    print('No KK: $noKk');
    print('Phone: $phone');
    print('Wali: $wali');
    print('rolw: $role');
      final emailExists = await _checkEmailExists(email);
      final phoneExists = await _checkPhoneExists(phone);
      final noKkexists = await _checkno_kkExists(noKk);
      final waliExists = await _checkWaliExists(wali);

      if (emailExists || phoneExists || noKkexists || waliExists) {
        Get.snackbar("Error", "Email, phone, no KK, or wali is already in use");
      } else {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          // Store additional user data in Firestore
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'no_kk': noKk,
            'phone': phone,
            'wali': wali, // Add the "wali" field
            'role': role,
            'getqurban' : false,
          });

          isRegistered.value = true;
          Get.to(() => const UserControl());
          Get.snackbar("Success", "Pendaftaran Berhasil Silahkan Login");
        }
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "An error occurred during registration");
    }
  }

  Future<bool> _checkEmailExists(String email) async {
    QuerySnapshot result = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    return result.docs.isNotEmpty;
  }

  Future<bool> _checkPhoneExists(String phone) async {
    QuerySnapshot result = await _firestore
        .collection('users')
        .where('phone', isEqualTo: phone)
        .get();

    return result.docs.isNotEmpty;
  }

  Future<bool> _checkno_kkExists(String noKk) async {
    QuerySnapshot result = await _firestore
        .collection('users')
        .where('no_kk', isEqualTo: noKk)
        .get();

    return result.docs.isNotEmpty;
  }

  Future<bool> _checkWaliExists(String wali) async {
    QuerySnapshot result = await _firestore
        .collection('users')
        .where('wali', isEqualTo: wali)
        .get();

    return result.docs.isNotEmpty;
  }

}