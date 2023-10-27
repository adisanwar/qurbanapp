// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurban_app/helpers/adminController.dart';

import 'package:qurban_app/helpers/logincontroller.dart';

import '../../helpers/usercontroller.dart';
import '../../models/user_model.dart';
import 'screen/userControl.dart';
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
    final AdminController adminController = Get.put(AdminController());    
    void logout() {
      loginController.logout();
    }

    return FutureBuilder(
      future: userController.fetchUserDetails(docId),
      builder: (context, snapshot) { 
      if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('User not found'));
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
            SingleChildScrollView(
              child: Container(
                
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
                              "Assalamualaikum ${user!.name},",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .white, // Sesuaikan warna teks sesuai kebutuhan
                                fontSize:
                                    22, // Sesuaikan ukuran teks sesuai kebutuhan
                              ),
                            ),
                            Text(
                              "Have a nice Day and Always Grateful",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
            ),
          
            const SizedBox(
              height: 40,
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
                                Get.to(() => const UserControl());
                                // Fungsi yang akan dijalankan ketika ikon pertama ditekan
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: const Icon(
                                  Icons.person_search,
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
                                  Icons.list,
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
                                adminController.scanQR();
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
                                adminController.getPdf();
                                
                                // Get.to(() => const ResultQurban());
                                // Fungsi yang akan dijalankan ketika ikon pertama ditekan
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: const Icon(
                                  Icons.picture_as_pdf,
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
