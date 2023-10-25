import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:qurban_app/helpers/logincontroller.dart';
import 'package:qurban_app/models/user_model.dart';

import '../../helpers/usercontroller.dart';

class UserPage extends StatelessWidget {
  final String docId;
  const UserPage({
    Key? key,
    required this.docId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final UserController userController = Get.put(UserController());

    void logout() {
      loginController.logout();
    }

   
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        elevation: 0.0, // Set the elevation to 0 to remove the shadow
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: const Icon(Icons.logout), // Change the icon to the logout icon
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
                        logout(); // User confirmed logout
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
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
      body: FutureBuilder(
        future: userController.fetchUserDetails(docId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('User not found'));
          } else {
            final UserModel user = snapshot.data!;
            return SafeArea(
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
                            // Text("${userNow!.email}"), // Spasi antara ikon dan teks
                            // // Text(userNow.uid),
                            // // Text("${userData.value['wali']}"),
                            // Text("${userDetail!.email}"),
                            Text(
                              "Assalamualaikum ${user.name},",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .white, // Sesuaikan warna teks sesuai kebutuhan
                                fontSize:
                                    22, // Sesuaikan ukuran teks sesuai kebutuhan
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                                'Silahkan Scan untuk mendapatkan bagian kamu',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors
                                      .white, // Sesuaikan warna teks sesuai kebutuhan
                                  fontSize:
                                      16, // Sesuaikan ukuran teks sesuai kebutuhan)
                                ))
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
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (user.nokk != null)
                            QrImageView(
                              data:
                                  "${user.nokk}", // Use qrCodeData here
                              version: QrVersions.auto,
                              size: 350.0,
                            )
                          else
                            const Text(
                              "Verifikasi Dulu", // Display this text if qrCodeData is null
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]),
          );
        }
        }
      ),
      );
    
  }
}
