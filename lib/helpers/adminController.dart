import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:qurban_app/models/user_model.dart';
import 'package:qurban_app/ui/admin/screen/userControl.dart';
import 'package:pdf/widgets.dart' as pw;

class AdminController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isRegistered = false.obs;

  // String userId = 'ID_PENGGUNA_YANG_INGIN_DIEDIT';

// Mengedit data di dokumen pengguna tertentu
  Future<void> editUserData(UserModel user) async {
    try {
      final userRef = _firestore.collection('users').doc(user.id);
      await userRef.update(user.toJson());
      print('User data successfully updated.');
    } catch (e) {
      print('Failed to edit user data: $e');
    }
  }

  Stream<List<UserModel>> allUsers() {
    final userStreamController = StreamController<List<UserModel>>();

    final userCollection = FirebaseFirestore.instance.collection('users');

    final subscription = userCollection.snapshots().listen((querySnapshot) {
      final users = querySnapshot.docs.map((userDocument) {
        return UserModel.fromSnapshot(userDocument);
      }).toList();

      userStreamController.add(users);
    });

    return userStreamController.stream;
  }

//    Future<UserModel> getUserData(String userId) async {
//   try {
//     final userCollection = FirebaseFirestore.instance.collection('users');
//     final userDocument = await userCollection.doc(userId).get();

//     if (userDocument.exists) {
//       final userData = UserModel.fromSnapshot(userDocument);
//       return userData;
//     } else {
//       throw Exception('User not found');
//     }
//   } catch (e) {
//     throw Exception('Failed to get user data: $e');
//   }
// }

//   Future<void> updateUserName(String userId, String newName) async {
//   try {
//     final userCollection = FirebaseFirestore.instance.collection('users');
//     final userDocument = userCollection.doc(userId);

//     await userDocument.update({
//       "wali": newName,
//     });
//   } catch (e) {
//     throw Exception('Failed to update user name: $e');
//   }
// }

//  Future<List<UserModel>> getAllUsers() async {
//   final snapshot = await _firestore.collection('users').get();
//   final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
//   return userData;
// }

// Future<void> updateRecord(UserModel user) async {
//   await _firestore.collection('users').doc(user.id).update(user.toJson());
// }

// Future<UserModel?> getUserData(String userId) async {
//   final users = await getAllUsers();
//   final user = users.firstWhere((user) => user.id == userId, orElse: () => );
//   return user;
// }

Future<UserModel> getUserById(String userId) async {
  print(userId);
  final QuerySnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: userId)
          .get();

  if (userSnapshot.docs.isNotEmpty) {
    final userData = userSnapshot.docs.first.data();
    return UserModel(
      id: userId,
      name: userData['name'] ?? '',
      nokk: userData['no_kk'] ?? '',
      phone: userData['phone'] ?? '',
      role: userData['role'] ?? '',
      getqurban: userData['getqurban'] ?? false,
      verifByAdmin: userData['verifByAdmin'] ?? false,
    );
  } else {
    throw Exception('User with the specified userId not found');
  }
}


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

          Get.snackbar(
            "Barcode",
            "User sudah menerima jatah Qurban",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Barcode",
            "No user found with this KK",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get Platform version';
    }
  }

  Future<void> getPdf() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: <pw.Widget>[
                pw.Header(
                  level: 0,
                  child:
                      pw.Text('Daftar Penerima Qurban', textScaleFactor: 2.0),
                ),
                pw.TableHelper.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    // Header
                    <String>[
                      'Kepala Keluarga',
                      'Nomor KK',
                      'Telepon',
                      'Status Penerima'
                    ],
                    // Data from Firestore
                    ...querySnapshot.docs.map((doc) {
                      final data = doc.data();
                      final status = data['getqurban'] == true
                          ? 'Sudah Menerima'
                          : 'Belum Menerima';
                      return <String>[
                        data['wali'] ??
                            '', // You can provide a default value here
                        data['no_kk'] ?? '',
                        data['phone'] ?? '',
                        status,
                      ];
                    }),
                  ],
                ),
              ],
            );
          },
        ),
      );
      final bytes = await pdf.save();
      final dir = await getDownloadsDirectory();
      final file = File('${dir!.path}/Laporan_qurban.pdf');
      print('File disimpan di: ${file.path}');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
      print('file dibuka');
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  Future<void> updateVerifByAdmin(String noKk) async {
    try {
      await FirebaseFirestore.instance
          .collection('users') // Ganti dengan nama koleksi yang sesuai
          .where('no_kk', isEqualTo: noKk) // Filter berdasarkan nomor KK
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          // Loop melalui semua dokumen yang cocok
          doc.reference.update({
            'verifByAdmin': true,
          });
        }
      });

      print('Data berhasil diupdate.');
      // Tambahkan tindakan lain yang perlu dilakukan jika pembaruan berhasil
    } catch (e) {
      print('Terjadi kesalahan saat mengupdate data: $e');
      // Tambahkan penanganan kesalahan sesuai kebutuhan Anda
    }
  }

  Future<void> deleteUserData(String docId, String name) async {
    try {
      // Hapus dokumen pengguna berdasarkan docId
      // String userId = docId;
      print(docId);

      await FirebaseFirestore.instance.collection('users').doc(docId).delete();

      // Hapus akun pengguna dari Firebase Authentication
      // await FirebaseAuth.instance.currentUser!.delete();
      Get.snackbar("Sukses", "Data $name Berhasil Dihapus");
      // Get.to(()=> const UserControl());

      print('User dengan docId $docId berhasil dihapus');
    } catch (e) {
      throw Exception('Error deleting user and data: $e');
    }
  }

  Future<void> addUser(String email, String password, String noKk, String phone,
      String wali, String role) async {
    try {
      print('Email: $email');
      print('Password: $password');
      print('No KK: $noKk');
      print('Phone: $phone');
      print('Wali: $wali');
      print('role: $role');
      final emailExists = await _checkEmailExists(email);
      final phoneExists = await _checkPhoneExists(phone);
      final noKkexists = await _checkno_kkExists(noKk);
      final waliExists = await _checkWaliExists(wali);

      if (emailExists || phoneExists || noKkexists || waliExists) {
        Get.snackbar("Error", "Email, phone, no KK, or wali is already in use");
      }
      if (role == '') {
        Get.snackbar("Error", "Pilih Role Dulu");
      } else {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        try {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phone,
            verificationCompleted: (PhoneAuthCredential credential) async {
              // Tidak digunakan dalam kasus ini karena tidak ada verifikasi otomatis.
            },
            verificationFailed: (FirebaseAuthException e) {
              print('Verifikasi gagal: $e');
            },
            codeSent: (String verificationId, int? resendToken) async {
              // Tidak digunakan dalam kasus ini karena tidak ada kode verifikasi otomatis.
              // Anda bisa menyimpan verificationId dan resendToken untuk digunakan nanti, atau abaikan saja.
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              // Tidak digunakan dalam kasus ini karena tidak ada verifikasi otomatis.
            },
          );

          // Jika Anda tidak ingin menggunakan kode verifikasi, Anda dapat mendaftarkan pengguna langsung di sini
          // Disini Anda dapat melanjutkan dengan tindakan lain yang diperlukan setelah mendaftarkan nomor telepon.
        } catch (e) {
          print('Error: $e');
        }

        if (userCredential.user != null) {
          // Store additional user data in Firestore
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'no_kk': noKk,
            'phone': phone,
            'wali': wali, // Add the "wali" field
            'role': role,
            'getqurban': false,
          });

          isRegistered.value = true;
          Get.to(() => const UserControl());
          Get.snackbar("Success", "User Berhasil Dittambahkan");
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
