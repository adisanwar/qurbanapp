import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qurban_app/helpers/logincontroller.dart';

import '../../helpers/usercontroller.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final userData = loginController.userData;
    final userNow = FirebaseAuth.instance.currentUser;

    // print(userData.value['wali']);
    // print(userNow);
    final UserController userController = Get.put(UserController());
    // final userData = loginController.userData;
    // final currentUser = loginController.currentUser.value;
    // final userDetail = loginController.fetchUserDetail();
    
    final userDetail = userController.currentUser.value;
    // print(userData!.uid);

    // void getData() {
    //   _userController.fetchUserData(userId);
    // }

    void logout() {
      loginController.logout();
    }

    @override
    void initState() {
      // loginController.getUserData();
      // getUserData(currentUser!.uid);
      initState();
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
      body: Obx(
        
        () => SafeArea(
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
                          Text("${userNow!.email}"), // Spasi antara ikon dan teks
                          // Text(userNow.uid),
                          // Text("${userData.value['wali']}"),
                          Text("${userDetail!.email}"),
                          Text(
                            "Assalamualaikum ${userData.value['wali']},",
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
                        if (userData.value['no_kk'] != null)
                          QrImageView(
                            data:
                                "${userData.value['no_kk']}", // Use qrCodeData here
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
        ),
      ),
    );
  }
}
