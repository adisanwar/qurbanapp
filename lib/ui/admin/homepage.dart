// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

import 'package:qurban_app/helpers/logincontroller.dart';

import '../../helpers/usercontroller.dart';
import '../../models/user_model.dart';
import 'screen/activeUser.dart';
import 'screen/confirmUser.dart';
import 'screen/resultQurban.dart';

class HomePage extends StatelessWidget {
  final String docId;
  const HomePage({
    Key? key,
    required this.docId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final UserController userController = Get.put(UserController());

   Future<void> scanQR() async {
  String barcodeScanRes;
  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff5722', 'Cancel', true, ScanMode.QR);
    debugPrint(barcodeScanRes);
  } on PlatformException {
    barcodeScanRes = 'Failed to get Platform version';
  }

  Get.snackbar("Barcode", barcodeScanRes);

   // Check if the scanned QR code matches a user's nokk
  // if (barcodeScanRes.isNotEmpty) {
  //   final QuerySnapshot userQuery = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('no_kk', isEqualTo: barcodeScanRes)
  //       .get();

  //   if (userQuery.docs.isNotEmpty) {
  //     // Get the first document matching the nokk
  //     final userDoc = userQuery.docs[0];

  //     // Convert QueryDocumentSnapshot to DocumentSnapshot<Map<String, dynamic>>
  //     final userDocData = userDoc.data() as Map<String, dynamic>;

  //     // Create a DocumentSnapshot from the data
  //     final userDocumentSnapshot = DocumentSnapshot<Map<String, dynamic>>(
  //       data: userDocData,
  //       metadata: userDoc.metadata,
  //       reference: userDoc.reference,
  //     );

  //     // Call the controller function to mark the user as qurban
  //     await userController.markUserAsQurban(UserModel.fromSnapshot(userDocumentSnapshot));

  //     // Display a message to indicate success
  //     Get.snackbar("Success", "User marked as qurban");
  //   } else {
  //     // Display an error message if the user is not found
  //     Get.snackbar("Error", "User not found");
  //   }
  // }
 
}
    
    void logout() {
      loginController.logout();
    }

    return FutureBuilder(
      future: userController.fetchUserDetails(docId),
      builder: (context, snapshot) { 
      if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('User not found'));
          } else {
            final UserModel? user = snapshot.data;
            return
      Scaffold(
          backgroundColor: Colors.blue[800],
          appBar: AppBar(
            elevation: 0.0, // Set the elevation to 0 to remove the shadow
            backgroundColor: Colors.blue[800],
            leading: IconButton(
              icon:
                  const Icon(Icons.logout), // Change the icon to the logout icon
              onPressed: () async {
                dynamic confirmLogout = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: const Text("Confirm Logout"),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Are you sure you want to logout?"),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            logout();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          child: const Text("Yes"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(false); // User canceled logout
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[800]),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          child: const Text("No"),
                        ),
                      ],
                    );
                  },
                );
    
                if (confirmLogout == true) {
                  logout();
                }
              },
            ),
          ),
          body: SafeArea(
              child: Column(children: [
            Container(
              // color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  // alignment: Alignment.center,
                  children: [
                    Align(
                      // alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                50.0), // Sesuaikan radius sudut sesuai kebutuhan
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.blue[800],
                                  size: 40.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),                     
                          Text(
                            "Assalamualaikum Admin Ganteng Alias ${user!.name},",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .white, // Sesuaikan warna teks sesuai kebutuhan
                              fontSize:
                                  22, // Sesuaikan ukuran teks sesuai kebutuhan
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
            const SizedBox(
              height: 20,
            ),
          
            // Baris kedua dengan latar belakang berwarna merah
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => const ActiveUser());
                                // Fungsi yang akan dijalankan ketika ikon pertama ditekan
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: const Icon(
                                  Icons.person_add,
                                  size: 120.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => const ConfirmUser());
                                // Fungsi yang akan dijalankan ketika ikon pertama ditekan
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: const Icon(
                                  Icons.create,
                                  size: 120.0,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height:
                              20.0, // Tambahkan ruang vertikal antara baris ikon
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                scanQR();
                                // Fungsi yang akan dijalankan ketika ikon pertama ditekan
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 120.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => const ResultQurban());
                                // Fungsi yang akan dijalankan ketika ikon pertama ditekan
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: const Icon(
                                  Icons.file_download,
                                  size: 120.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 10,)
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]))
          );
          }
      }
    );
  }
}
