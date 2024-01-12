import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_app/ui/admin/screen/userControl.dart';

class EditUser extends StatefulWidget {
  final String? userID;

  const EditUser({Key? key, required this.userID}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final TextEditingController _noKkController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _waliController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isRegistering = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    fetchData(widget.userID ?? ''); // Fetch data when the widget initializes
  }

  Future<void> fetchData(String userID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userID)
          .get();

      if (userData.exists) {
        // Populate form fields with retrieved data
        setState(() {
          _noKkController.text = userData['no_kk'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _waliController.text = userData['wali'] ?? '';
          _emailController.text = userData['email'] ?? '';
          // Add more fields based on your Firestore document structure

          // Adding getQurban and verifByAdmin fields
          bool getQurban = userData['getqurban'] ?? false;
          bool verifByAdmin = userData['verifByAdmin'] ?? false;

          // Use these boolean values as needed in your UI or logic
        });
      } else {
        // Handle case where the document doesn't exist for the given user ID
        // Show an error message or handle this case accordingly
      }
    } catch (e) {
      // Handle errors
      print('Error fetching user data: $e');
      // Show an error message or handle the error accordingly
    }
  }

  Future<void> updateUserData(String userID) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userID).update({
        'no_kk': _noKkController.text,
        'phone': _phoneController.text,
        'wali': _waliController.text,
        'email': _emailController.text,
      });

      // Show a success message or perform actions after successful update
    } catch (e) {
      // Handle errors
      print('Error updating user data: $e');
      // Show an error message or handle the error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User"),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _noKkController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              decoration: InputDecoration(
                labelText: 'No KK',
                hintText: 'No KK (cth. 2170xxx)',
                // Add other properties as needed
              ),
            ),
            TextFormField(
              controller: _waliController,
              // maxLength: 16,
              decoration: InputDecoration(
                labelText: 'Kepala Keluarga',
                hintText: 'Masukkan Nama Kepala Keluarga',
                // Add other properties as needed
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              maxLength: 14,
              decoration: InputDecoration(
                labelText: 'Nomor HP',
                hintText: 'Nomor HP (cth. +62812xxx)',
                // Add other properties as needed
              ),
            ),

            // Continue with other form fields using similar TextFormField widgets
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                updateUserData(widget.userID ?? '');
                Get.to(() => const UserControl());
                Get.snackbar(
                  'Success',
                  'User data has been updated',
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: const Text("Update User"),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:qurban_app/helpers/adminController.dart';
// import 'package:qurban_app/models/user_model.dart';

// class EditUser extends StatefulWidget {
//   final String? userID;

//   const EditUser({Key? key, required this.userID}) : super(key: key);

//   @override
//   State<EditUser> createState() => _EditUserState();
// }

// class _EditUserState extends State<EditUser> {
//    Stream<List<UserModel>>? _usersStream;
//   // final FirebaseAuth _auth = FirebaseAuth.instance;
//   // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _noKkController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final TextEditingController _waliController = TextEditingController();
//   final TextEditingController _roleController = TextEditingController();
//   final AdminController _addUserController = Get.put(AdminController());

//   bool isRegistering = false;
//   bool isPasswordVisible = false;
//   bool isConfirmPasswordVisible = false;

//    bool doPasswordsMatch() {
//     return _passwordController.text == _confirmPasswordController.text;
//   }

//   String selectedValue = 'User';
//   List<String> dropdownItems = ['Admin', 'User'];
//   final AdminController _adminController = Get.put(AdminController());

//   Future<void> fetchData(String userID) async {
//     try {
//       DocumentSnapshot<Map<String, dynamic>> userData =
//           await FirebaseFirestore.instance.collection('users').doc(userID).get();

//       if (userData.exists) {
//         // Populate form fields with retrieved data
//         setState(() {
//           _noKkController.text = userData['no_kk'] ?? '';
//           _phoneController.text = userData['phone'] ?? '';
//           _waliController.text = userData['wali'] ?? '';
//           _emailController.text = userData['email'] ?? '';
//           // Add more fields based on your Firestore document structure
//         });
//       } else {
//         // Handle case where the document doesn't exist for the given user ID
//         // Show an error message or handle this case accordingly
//       }
//     } catch (e) {
//       // Handle errors
//       print('Error fetching user data: $e');
//       // Show an error message or handle the error accordingly
//     }
//   }

//   Future<void> updateUserData(String userID) async {
//     try {
//       await FirebaseFirestore.instance.collection('users').doc(userID).update({
//         'no_kk': _noKkController.text,
//         'phone': _phoneController.text,
//         'wali': _waliController.text,
//         'email': _emailController.text,
//         // Add more fields as necessary based on your Firestore document structure
//       });

//       // Show a success message or perform actions after successful update
//     } catch (e) {
//       // Handle errors
//       print('Error updating user data: $e');
//       // Show an error message or handle the error accordingly
//     }
//   }

//    @override
//   void initState() {
//     super.initState();
//     _usersStream = _adminController.allUsers();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit User"),
//         backgroundColor: Colors.blue[800],
//       ),
//       body: StreamBuilder<List<UserModel>>(
//         stream: _usersStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No user data available'));
//           } else {
//             final users = snapshot.data!;
//             final user = users.firstWhere((user) => user.id == widget.userID, orElse: () => UserModel(id: '', name: '', nokk: '', phone: '', role: '', getqurban: false, verifByAdmin: false )); // Replace 'name' with your desired user property
//             return SingleChildScrollView(
//          padding: const EdgeInsets.only(top: 20),
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 32),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // const SizedBox(height: 50),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // const SizedBox(height: 10),
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: TextFormField(

//                         controller: _noKkController,
                        
//                         keyboardType: TextInputType.number,
//                         maxLength: 16,
//                         decoration: InputDecoration(
//                           hintText: "No KK (cth. 2170xxx)",
//                           prefixIcon: const Icon(Icons.perm_identity),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Masukan No KK!";
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: TextFormField(
//                         // controller: _phoneController,
//                         keyboardType: TextInputType.number,
//                         maxLength: 14,
//                         decoration: InputDecoration(
//                           hintText: "Nomor HP (cth. +62812xxx)",
//                           prefixIcon: const Icon(Icons.phone),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Masukan No Hp!";
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: TextFormField(
//                         // controller: _waliController,
//                         // maxLength: 16,
//                         decoration: InputDecoration(
//                           hintText: "Masukan Nama",
//                           prefixIcon: const Icon(Icons.perm_identity),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Masukan Nama!";
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: TextFormField(
//                         // keyboardType: TextInputType.emailAddress,
//                         // controller: _emailController,
//                         decoration: InputDecoration(
//                           hintText:
//                               "Email", // Add a space as a placeholder for the hint text
//                           prefixIcon: const Icon(Icons.mail),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                               color: Colors.grey,
//                             ), // Gray border when focused
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                               color: Colors.grey,
//                             ), // Gray border when enabled
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           // Set the floating label behavior to "always"
//                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Masukan Email!";
//                           }
//                           return null;
//                         },
//                         // onChanged: (value) {
//                         //   setState(() {
//                         //     _email = value;
//                         //   });
//                         // },
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       padding: const EdgeInsets.all(5.0),
//                       child: DropdownButton<String>(
//                         value: selectedValue,
//                         items: dropdownItems.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Row(
//                               children: [
//                                 const Icon(Icons
//                                     .person_2_outlined), // Ganti dengan ikon yang sesuai
//                                 const SizedBox(width: 8.0),
//                                 Text(value),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedValue = newValue ?? '';
//                             _roleController.text = selectedValue;
//                             print(_roleController);
//                           });
//                         },
//                       ),
//                     ),

//                     const SizedBox(height: 10),
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: TextFormField(
//                         controller: _passwordController,
//                         obscureText: !isPasswordVisible,
//                         decoration: InputDecoration(
//                           hintText: "Password",
//                           prefixIcon: const Icon(Icons.lock),
//                           suffixIcon: IconButton(
//                             icon: Icon(isPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off),
//                             onPressed: () {
//                               setState(() {
//                                 isPasswordVisible = !isPasswordVisible;
//                               });
//                             },
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(0),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Masukan Password!";
//                           }
//                           return null;
//                         },
//                       ),
//                     ),

//                     const SizedBox(height: 10),
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: TextFormField(
//                         controller: _confirmPasswordController,
//                         obscureText: !isConfirmPasswordVisible,
//                         decoration: InputDecoration(
//                           hintText: "Konfirmasi Password",
//                           prefixIcon: const Icon(Icons.lock),
//                           suffixIcon: IconButton(
//                             icon: Icon(isConfirmPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off),
//                             onPressed: () {
//                               setState(() {
//                                 isConfirmPasswordVisible =
//                                     !isConfirmPasswordVisible;
//                               });
//                             },
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Masukan konfirmasi Password!";
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     if (!doPasswordsMatch())
//                       const Text(
//                         "Password tidak sama",
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     // SizedBox(height: 12),
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.end,
//                     //   children: [
//                     //     Text(
//                     //       "Lupa Password?",
//                     //       style: TextStyle(color: Colors.blue),
//                     //     )
//                     //   ],
//                     // ),
//                     const SizedBox(height: 12),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             isRegistering =
//                                 true; // Set the loading state to true
//                           });

//                           // _addUser(); // Call the registration function

//                           setState(() {
//                             isRegistering =
//                                 false; // Set the loading state back to false when registration is completed
//                           });
//                         },
//                         style: ButtonStyle(
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30.0),
//                             ),
//                           ),
//                         ),
//                         child:
//                             isRegistering // Show loading indicator if isRegistering is true
//                                 ? const CircularProgressIndicator()
//                                 : const Text(
//                                     "Update User"), // Show "Register" button when not loading
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
        
//       );
      
//     }
      
// }
//       )
//     );
//   }
// }
