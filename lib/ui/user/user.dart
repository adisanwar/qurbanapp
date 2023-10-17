import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurban_app/helpers/logincontroller.dart';
import 'package:qurban_app/helpers/usercontroller.dart';

class UserPage extends StatelessWidget {
  
  const UserPage({Key? key});

  @override
  Widget build(BuildContext context) {
    // final String userId;
    // final UserController currentUserController = Get.find<UserController>();
    final UserController currentUserController = Get.put(UserController());
    final LoginController logout = Get.put(LoginController());
    final currentUser = currentUserController.currentUser.value;
    // final userData = currentUserController.getData.value;
    final userData = currentUserController.userData.value;


    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[800],
        body: 
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                if (currentUser == null)
                  Center(child: CircularProgressIndicator())
                else
                  Column(
                    children: [
                      Text("User ID: ${currentUser.uid}"),
                      Text("Email: ${currentUser.email}"),
                       Text("Nama : ${userData['wali']}"),
                      if (userData.isNotEmpty) 
                        Column(
                          children: [
                            Text('hello'),
                            Text("Nama : ${userData['wali']}"),
                            Text("No KK: ${userData['no_kk']}"),
                            Text("No HP: ${userData['phone']}"),
                          ],
                        ),
                        ElevatedButton(
                onPressed: () {
                  logout.logout();
                  // Add logout functionality here
                },
                child: Text("Logout"),
              ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
