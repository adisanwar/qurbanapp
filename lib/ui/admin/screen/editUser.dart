// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qurban_app/helpers/adminController.dart';
import 'package:qurban_app/models/user_model.dart';

class EditUser extends StatefulWidget {
  final String? userID;

  const EditUser({Key? key, required this.userID}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _noKkController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _confirmPasswordController =
  //     TextEditingController();
  // final TextEditingController _waliController = TextEditingController();
  // final TextEditingController _roleController = TextEditingController();
  final AdminController _adminController = Get.put(AdminController());

  String selectedValue = 'User';
  List<String> dropdownItems = ['Admin', 'User'];

  // bool doPasswordsMatch() {
  //   return _passwordController.text == _confirmPasswordController.text;
  // }

  bool isRegistering = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // String _email = "";
  // String _password = "";

  // void _addUser() async {
  //   // _roleController = selectedValue;
  //   // Call the registerUser method from the RegistrationController
  //   _addUserController.addUser(
  //       _emailController.text,
  //       _passwordController.text,
  //       _noKkController.text,
  //       _phoneController.text,
  //       _waliController.text,
  //       _roleController.text);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User"),
        backgroundColor: Colors.blue[800],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: 
          //  Column(
          //           children: [
          //             Form(child: 
          //             Column(
          //               children: [
          //                 TextFormField(
          //                   // initialValue: user.name,
          //                   decoration: const InputDecoration(labelText: "Name", border: OutlineInputBorder(), fillColor: Colors.amber)

          //                 )

          //               ],
          //             )
                      
          //             ),
          //             Text('Halo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30), textAlign: 
          //             TextAlign.center
          //             ,)
          //           ]
          //         )
          
       FutureBuilder<UserModel?>(
  future: _adminController.getUserById(widget.userID!), // Replace 'userId' with the actual user's ID
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (!snapshot.hasData || snapshot.data == null) {
      return Text('User not found');
    } else {
      final user = snapshot.data!;

      return Column(
        children: [
          TextFormField(
            initialValue: user.name,
            decoration: InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
              fillColor: Colors.amber,
            ),
          ),
          TextFormField(
            initialValue: user.nokk,
            decoration: InputDecoration(
              labelText: "No KK",
              border: OutlineInputBorder(),
              fillColor: Colors.amber,
            ),
          ),
          TextFormField(
            initialValue: user.phone,
            decoration: InputDecoration(
              labelText: "Phone",
              border: OutlineInputBorder(),
              fillColor: Colors.amber,
            ),
          ),
          // Add more TextFormField widgets for other fields
        ],
      );
    }
  },
)




  
        ),
      ),
    );
  }
}
