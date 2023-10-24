import 'package:flutter/material.dart';

class ActiveUser extends StatelessWidget {
  const ActiveUser({super.key});

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
        appBar:
            AppBar(title: const Text('Active User'), backgroundColor: Colors.blue),
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