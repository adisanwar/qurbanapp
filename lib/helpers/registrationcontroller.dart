import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_app/ui/login.dart';

class RegistrationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxBool isRegistered = false.obs;

  Future<void> registerUser(
    
      String email, String password, String no_kk, String phone, String wali) async {
    try {
      print('Email: $email');
    print('Password: $password');
    print('No KK: $no_kk');
    print('Phone: $phone');
    print('Wali: $wali');
      final emailExists = await _checkEmailExists(email);
      final phoneExists = await _checkPhoneExists(phone);
      final no_kkExists = await _checkno_kkExists(no_kk);
      final waliExists = await _checkWaliExists(wali);

      if (emailExists || phoneExists || no_kkExists || waliExists) {
        Get.snackbar("Error", "Email, phone, no KK, or wali is already in use");
      } else {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          // Store additional user data in Firestore
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'no_kk': no_kk,
            'phone': phone,
            'wali': wali, // Add the "wali" field
            'role': 'user',
          });

          isRegistered.value = true;
          Get.to(() => Login());
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

  Future<bool> _checkno_kkExists(String no_kk) async {
    QuerySnapshot result = await _firestore
        .collection('users')
        .where('no_kk', isEqualTo: no_kk)
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
