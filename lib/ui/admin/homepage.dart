// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurban_app/helpers/logincontroller.dart';
import 'package:qurban_app/ui/admin/screen/qrcamera.dart';

import 'screen/activeUser.dart';
import 'screen/confirmUser.dart';
import 'screen/resultQurban.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    // final UserController _userController = Get.put(UserController());
    final currentUser = loginController.currentUser.value;
    // final userId = CurrentUser!.uid;
    // final getDataUser = _userController.fetchUserData(userId);
    // final userData = _loginController.currentUser.value;
    // print(userData!.uid);

    // void getData() {
    //   _userController.fetchUserData(userId);
    // }

    void logout() {
      loginController.logout();
    }

    @override
    void initState() {
      // getData();
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
        body: Obx(() => SafeArea(
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
                                "${currentUser!.email}"), // Spasi antara ikon dan teks
                            Text(currentUser.uid),
                            // Text("${loginController.userData.value['no_kk']}"),
                            // Text("${getUserData}"),
                            const Text(
                              "Assalamualaikum ,",
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
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
                                    Get.to(() => const QrCameraResult());
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]))));
  }
}
