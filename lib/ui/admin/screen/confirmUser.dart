import 'package:flutter/material.dart';

class ConfirmUser extends StatelessWidget {
  const ConfirmUser({super.key});

  @override
  Widget build(BuildContext context) {
      // Daftar pengguna (gantilah ini dengan data sebenarnya)
  final List<Map<String, String>> users = [
    {'name': 'User 1', 'role': 'Role A'},
    {'name': 'User 2', 'role': 'Role B'},
    {'name': 'User 3', 'role': 'Role C'},
    // Tambahkan pengguna lebih banyak di sini sesuai kebutuhan
  ];
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm User')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Aksi yang akan diambil saat tombol tindakan mengambang ditekan
          },
          child: const Icon(Icons.add), // Ganti ikon dengan ikon yang sesuai
        ),
       body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTile(
                  title: Text(users[index]['name']!),
                  subtitle: Text(users[index]['role']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Aksi yang akan diambil saat tombol Edit ditekan
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Aksi yang akan diambil saat tombol Delete ditekan
                        },
                      ),
                      const Text('Online', ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}