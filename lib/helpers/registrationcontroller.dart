import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_app/auth/login.dart';


class RegistrationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxBool isRegistered = false.obs;
  

  Future<void> registerUser(
    
      String email, String password, String noKk, String phone, String wali, String role) async {
    try {
      print('Email: $email');
    print('Password: $password');
    print('No KK: $noKk');
    print('Phone: $phone');
    print('Wali: $wali');
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
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'no_kk': noKk,
            'phone': phone,
            'wali': wali, // Add the "wali" field
            'role': role,
            'getqurban' : false,
            'verifByAdmin' : false
          });

          isRegistered.value = true;
          Get.to(() => const Login());
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
