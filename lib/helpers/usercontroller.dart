

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// import '../auth/login.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  Rx<User?> currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
  Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>({});
  Rx<Map<String, dynamic>> getData = Rx<Map<String, dynamic>>({});
  
  RxMap<String, dynamic> documentData = RxMap<String, dynamic>();

   @override
  void onInit() {
    super.onInit();
    // Panggil fungsi untuk mengambil data Firestore saat controller diinisialisasi.
    fetchUserDetail();
  }

  Future<void> refreshCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      currentUser.value = user;
    } catch (e) {
      // Handle the error as needed
      print("Error in refreshCurrentUser: $e");
    }
  }

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
          // Jika dokumen pengguna dengan id yang sesuai ditemukan
          userData.value = userDocId['wali'];
          userData.value = userDocId['no_kk'];
        }
      }
    } catch (e) {
      print("Fetch User Data Error: $e");
    }
  }

//  Future<void> fetchUserData(String userId) async {
//   try {
    
//     final userDoc = await _firestore.collection('users').doc(userId).get();
//     final currentUser = FirebaseAuth.instance.currentUser;

//     if (userDoc.id == currentUser!.uid) {
//       userData.value = userDoc.data() ?? {};
//     } else {
//       userData.value = {};
//     }
//   } catch (e) {
//     print("Fetch User Data Error: $e");
//   }



// }
// final FirebaseAuth _auth = FirebaseAuth.instance;
//   Future<String> getUserRole(String userId) async {
//   try {
//     final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     if (userDoc.exists) {
//       print(userDoc['wali']);
//       return userDoc['role'] ?? '';
//     } else {
//       return '';
//     }
//   } catch (e) {
//     print("Get User Role Error: $e");
//     return '';
//   }
// }

}

// class FirestoreService {
// // get collection note
//   final CollectionReference users =
//       FirebaseFirestore.instance.collection('users');

// // create add new notes
//   Future<void> addNotes(String note) {
//     return users.add({'note': note, 'timestamp': Timestamp.now()});

//   }
//   // reaad notes from database
//     Stream<QuerySnapshot> getUsersStream() {
//       final usersStream =
//           users.snapshots();
//       return usersStream;
//     }

//   // update: update notes given a doc
//   Future < void >updateNote ( String docId , String newNote) {
//     return  users.doc(docId).update({
//       'note' : newNote,
//       'timestamp': Timestamp.now(),
//     });
// }

//     // delete

//     Future<void> deleteNote(String docID) {
//       return users.doc(docID).delete();
//     }
// }

// body: StreamBuilder<QuerySnapshot>(
//           stream: firestoreService.getNotesStream(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return ListView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot document = snapshot.data!.docs[index];
//                     String docID = document.id;

//                     Map<String, dynamic> data =
//                         document.data() as Map<String, dynamic>;
//                     String noteText = data['note'];