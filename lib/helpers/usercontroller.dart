

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:qurban_app/models/user_model.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// import '../auth/login.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

    Future<UserModel> fetchUserDetails(String docId) async {
    final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(docId).get();
    if (userSnapshot.exists) {
      return UserModel.fromSnapshot(userSnapshot);
    } else {
      throw Exception('User not found');
    }
  }

  Future<List<UserModel>> allUsers() async {
  final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

  if (usersSnapshot.docs.isNotEmpty) {
    // Convert the list of user documents to a list of UserModel objects
    return usersSnapshot.docs.map((userDocument) {
      return UserModel.fromSnapshot(userDocument);
    }).toList();
  } else {
    throw Exception('No users found');
  }
}

// Updated method to update the getqurban field to true
  Future<void> markUserAsQurban(UserModel user) async {
    try {
      final QuerySnapshot nokkQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('no_kk', isEqualTo: user.nokk)
          .get();

      if (nokkQuery.docs.isNotEmpty) {
        // Get the first document matching the nokk
        final userDoc = nokkQuery.docs[0];

        // Update the user document with getqurban set to true
        await userDoc.reference.update({
          'getqurban': true,
        });
      } else {
        throw Exception('User with nokk not found');
      }
    } catch (e) {
      throw Exception('Error updating user data: $e');
    }
  }
}

