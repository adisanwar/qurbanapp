import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurban_app/helpers/adminController.dart';
import 'package:qurban_app/helpers/usercontroller.dart';
import 'package:qurban_app/ui/admin/screen/addUser.dart';
import 'package:qurban_app/ui/admin/screen/editUser.dart';

class UserControl extends StatelessWidget {
  const UserControl({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    final AdminController adminController = Get.put(AdminController());
    

    User? user = FirebaseAuth.instance.currentUser;

// Create a local variable isOnline based on the user's login status
    bool isOnline = user != null;

    if (isOnline) {
      // The user is logged in
      print('User is logged in: ${user.uid}');
    } else {
      // The user is not logged in
      print('User is not logged in');
    }
    return Scaffold(
      appBar: AppBar(
        
          title: const Text('User Control'), backgroundColor: Colors.blue[800]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddUser());
          // Aksi yang akan diambil saat tombol tindakan mengambang ditekan
        },
        child: const Icon(Icons.add), // Ganti ikon dengan ikon yang sesuai
      ),
      body: StreamBuilder(
          stream: adminController.allUsers(),
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.role),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                                child: user.verifByAdmin
                                    ? Opacity(
                                      opacity: 0,
                                      child: IconButton(
                                          icon: const Icon(Icons.check,
                                              color: Colors.green),
                                          iconSize: 30,
                                          
                                          onPressed: () {
                                    
                                            // Aksi yang akan diambil saat tombol Edit ditekan
                                          },
                                        ),
                                    )
                                    : GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context:
                                                context, // Pastikan Anda memiliki context yang sesuai
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Verifikasi'),
                                                content: Text(
                                                    'Apakah Anda yakin ingin verifikasi user${user.name} dengan no KK ${user.nokk}?'),
                                                actions: [
                                                  ElevatedButton(
                                                    child: Text('Batal'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red),
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    child: Text('Verifikasi'),
                                                    onPressed: () {
                                                      String noKk = user.nokk;
                                                     adminController.updateVerifByAdmin(noKk);
                                                     Navigator.of(context).pop();
                                                      // Tindakan yang ingin Anda lakukan saat teks diverifikasi
                                                      // Misalnya, simpan status verifikasi, dll.
                                                      // userController.updateEmailVerificationStatus(user.id);
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.green),
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Belum diverifikasi',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      )),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                Get.to(()=>EditUser());
                                // Aksi yang akan diambil saat tombol Edit ditekan
                              },
                            ),
                            InkWell(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: Text('Hapus'),
                                            content: Text(
                                                'Yakin Ingin Menghapus ${user.name}?'),
                                            actions: [
                                              ElevatedButton(
                                                child: Text('Hapus'),
                                                onPressed: () {
                                                  // String userNow  =  FirebaseAuth.instance.currentUser!.uid;
                                                  String? userId = user.id;
                                                  String? name = user.name;
                                                  // print("akun : ${userNow}");
                                                  print("docID : ${userId} ");
                                                  try {
                                                    adminController
                                                        .deleteUserData(
                                                            userId!, name);
                                                    Navigator.of(context).pop();
                                                    Get.to(() => UserControl());
                                                    // Tambahkan logika lain yang perlu dilakukan jika penghapusan berhasil
                                                  } catch (e) {
                                                    print(
                                                        'Terjadi kesalahan saat menghapus data: $e');
                                                    // Tambahkan penanganan kesalahan sesuai kebutuhan Anda, misalnya menampilkan pesan kesalahan kepada pengguna
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                child: Text('Batal'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ));
                                  // Aksi yang akan diambil saat tombol Delete ditekan
                                },
                              ),
                            ),
                            Center(
                              child: Icon(
                                user.verifByAdmin ? Icons.circle : Icons.circle,
                                color:  user.verifByAdmin ? Colors.green : Colors.grey,
                                size: 15, // Adjust the size as needed
                              ),
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
