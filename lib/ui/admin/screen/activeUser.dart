import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qurban_app/helpers/usercontroller.dart';

import '../../../models/user_model.dart';

class ActiveUser extends StatelessWidget {
  const ActiveUser({super.key});

  @override
  Widget build(BuildContext context) {
     final UserController userController = Get.put(UserController());
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
        appBar:
            AppBar(title: const Text('Active User'), backgroundColor: Colors.blue),
             floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Aksi yang akan diambil saat tombol tindakan mengambang ditekan
          },
          child: const Icon(Icons.add), // Ganti ikon dengan ikon yang sesuai
        ),
       body: FutureBuilder(
        future: userController.allUsers(),
        builder: (context, snapshot) {
          
         if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('User not found'));
          } else {
            final users = snapshot.data;

            return
        ListView.builder(
            itemCount: users!.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(  
                    title: Text(user.name),
                    subtitle: Text(user.role),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            // Aksi yang akan diambil saat tombol Edit ditekan
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red,),
                          onPressed: () {
                            // Aksi yang akan diambil saat tombol Delete ditekan
                          },
                        ),
                        Center(
  child: Icon(
    isOnline ? Icons.circle : Icons.circle,
    color: isOnline ? Colors.green : Colors.grey,
    size: 20, // Adjust the size as needed
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
        }
       ),
      );
            
  }
}

// Table(
//                   border: TableBorder.all(color: Colors.blue),
//                   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                   children: [
//                     TableRow(
//                         decoration: BoxDecoration(
//                           color: Colors.green[200],
//                         ),
//                         children: [
//                           TableCell(
//                             verticalAlignment:
//                                 TableCellVerticalAlignment.middle,
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text('Nama'),
//                             ),
//                           ),
//                           TableCell(
//                             verticalAlignment:
//                                 TableCellVerticalAlignment.middle,
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text('Role User'),
//                             ),
//                           ),
//                           TableCell(
//                             verticalAlignment:
//                                 TableCellVerticalAlignment.middle,
//                             child: Padding(
//                               padding: EdgeInsets.all(5.0),
//                               child: Text('Aksi'),
//                             ),
//                           )
//                         ]),
//                     ...List.generate(
//                       10,
//                       (index) => TableRow(
//                         children: [
//                           TableCell(
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text(
//                                   'Data for Row $index'), // Add your data here
//                             ),
//                           ),
//                           TableCell(
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text(
//                                   'Role for Row $index'), // Add role data here
//                             ),
//                           ),
//                           TableCell(
//   child: Padding(
//     padding: EdgeInsets.all(8.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         InkWell(
//           onTap: () {
//             // Tambahkan fungsi yang akan dijalankan ketika ikon pertama ditekan
//           },
//           child: Icon(Icons.edit, size: 24.0, color: Colors.blue),
//         ),
//         InkWell(
//           onTap: () {
//             // Tambahkan fungsi yang akan dijalankan ketika ikon kedua ditekan
//           },
//           child: Icon(Icons.delete, size: 24.0, color: Colors.red),
//         ),
//       ],
//     ),
//   ),
// ),

//                         ],
//                       ),
//                     ),
//                     // Center(child: Text("This is the active user page")),
//                   ],
//                 ),