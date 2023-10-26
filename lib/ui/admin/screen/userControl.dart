import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurban_app/auth/addUser.dart';
import 'package:qurban_app/helpers/usercontroller.dart';

class UserControl extends StatelessWidget {
  const UserControl({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    final bool verifikasiUser =
        FirebaseAuth.instance.currentUser!.emailVerified;

    User? user = FirebaseAuth.instance.currentUser;

    // Future<void> deleteUserAndDocument(idUser) async {
    //   final FirebaseAuth auth = FirebaseAuth.instance;
    //   final User? user = auth.currentUser;

    //   if (user != null) {
    //     // Mendapatkan UID pengguna
    //     final String userId = user.uid;

    //     if (userId == idUser) {
    //       // Menghapus dokumen pengguna dari Firestore
    //       final CollectionReference usersCollection =
    //           FirebaseFirestore.instance.collection('users');
    //       await usersCollection.doc(userId).delete();

    //       // Menghapus pengguna dari Firebase Authentication
    //       await user.delete();

    //       print('Pengguna dan dokumen telah dihapus.');
    //     } else {
    //       print(
    //           'UID pengguna tidak sesuai dengan user.id. Tindakan dibatalkan.');
    //     }
    //   } else {
    //     print('Tidak ada pengguna yang masuk.');
    //   }
    // }

    Future<void> deleteUserData(String docId) async {
  try {
    // Hapus dokumen pengguna berdasarkan docId
    String userId = docId;
    
    await FirebaseFirestore.instance.collection('users').doc(docId).delete();

    // Hapus akun pengguna dari Firebase Authentication
    await FirebaseAuth.instance.currentUser!.delete();

    print('User dengan docId $docId berhasil dihapus');
  } catch (e) {
    throw Exception('Error deleting user and data: $e');
  }
}


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
          title: const Text('User Control'), backgroundColor: Colors.blue),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddUser());
          // Aksi yang akan diambil saat tombol tindakan mengambang ditekan
        },
        child: const Icon(Icons.add), // Ganti ikon dengan ikon yang sesuai
      ),
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.role),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                                child: verifikasiUser
                                    ? IconButton(
                                        icon: const Icon(Icons.check,
                                            color: Colors.green),
                                        iconSize: 30,
                                        onPressed: () {
                                          // Aksi yang akan diambil saat tombol Edit ditekan
                                        },
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
                                                    'Apakah Anda yakin ingin verifikasi user${user.name} dengan no KK ${user.nokk}  ${user.id} ?'),
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
                                                'Yakin Ingin Menghapus ${user.name} ${user.id} ?'),
                                            actions: [
                                              ElevatedButton(
                                                child: Text('Hapus'),
                                                onPressed: () {
                                                  String userNow  =  FirebaseAuth.instance.currentUser!.uid;
                                                  String? userId = user.id;
                                                  print("akun : ${userNow}");
                                                  print("docID : ${userId} ");
                                                  try {
                                                    // deleteUserData(userId!);
                                                    print('user berhasil diihapus');
                                                  } catch (e) {
                                                    
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
                                isOnline ? Icons.circle : Icons.circle,
                                color: isOnline ? Colors.green : Colors.grey,
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
