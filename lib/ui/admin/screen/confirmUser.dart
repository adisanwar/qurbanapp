import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurban_app/helpers/usercontroller.dart';


class ConfirmUser extends StatelessWidget {
  const ConfirmUser({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Daftar Penerima'), backgroundColor: Colors.blue),
      body: FutureBuilder(
          future: userController.allUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('User not found'));
            } else {
              final users = snapshot.data;

              return ListView.builder(
                itemCount: users!.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold,),),
                        subtitle: Text(user.nokk, style: const TextStyle(fontWeight: FontWeight.bold,)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // IconButton(
                           
                            Center(
                              child: user.getqurban
                                  ? const Text('Sudah Menerima',
                                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold,))
                                  : const Text('Belum Menerima',
                                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,)),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
