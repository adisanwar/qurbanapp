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
        email = email.trim();
    try {
      final emailExists = await _checkEmailExists(email);
      final phoneExists = await _checkPhoneExists(phone);
      final no_kkExists = await _checkno_kkExists(no_kk);

      if (emailExists ) {
        Get.snackbar("Error", "Email, phone, or no KK is already in use");
      }if (phoneExists) {
        Get.snackbar("Error","phone, is already in use");
      }
      if (no_kkExists) {
        Get.snackbar("Error", "no KK is already in use");
      } else {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          // Store additional user data in Firestore
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'wali': wali,
            'no_kk': no_kk,
            'phone': phone,
            'role': 'user',
          });

          isRegistered.value = true;
          Get.to(() => Login());
          Get.snackbar("Success","Pendaftaran Berhasil Silahkan Login");
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
}
