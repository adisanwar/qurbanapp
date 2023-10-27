// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurban_app/auth/login.dart';
import 'package:qurban_app/helpers/adminController.dart';
import 'package:qurban_app/helpers/registrationcontroller.dart';
import 'package:qurban_app/models/user_model.dart';

class EditUser extends StatefulWidget {
  const EditUser({Key? key}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _noKkController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _waliController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  final AdminController _adminController = Get.put(AdminController());

  String selectedValue = 'User';
  List<String> dropdownItems = ['Admin', 'User'];

  bool doPasswordsMatch() {
    return _passwordController.text == _confirmPasswordController.text;
  }

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
        title: Text("Tambah User"),
        backgroundColor: Colors.blue[800],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20),
          child: FutureBuilder<List<UserModel>>(
              future: _adminController.getallUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('User not found'));
                }
                UserModel user = snapshot.data as UserModel;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const SizedBox(height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              controller: _noKkController,
                              initialValue: user.nokk,
                              keyboardType: TextInputType.number,
                              maxLength: 16,
                              decoration: InputDecoration(
                                hintText: "No KK (cth. 2170xxx)",
                                prefixIcon: const Icon(Icons.perm_identity),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Masukan No KK!";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              controller: _phoneController,
                              initialValue: user.phone,
                              keyboardType: TextInputType.number,
                              maxLength: 14,
                              decoration: InputDecoration(
                                hintText: "Nomor HP (cth. +62812xxx)",
                                prefixIcon: const Icon(Icons.phone),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Masukan No Hp!";
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              initialValue: user.name,
                              controller: _waliController,
                              // maxLength: 16,
                              decoration: InputDecoration(
                                hintText: "Masukan Nama",
                                prefixIcon: const Icon(Icons.perm_identity),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Masukan Nama!";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(5.0),
                            child: DropdownButton<String>(
                              value: selectedValue,
                              items: dropdownItems.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Icon(Icons
                                          .person_2_outlined), // Ganti dengan ikon yang sesuai
                                      SizedBox(width: 8.0),
                                      Text(value),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue ?? '';
                                  _roleController.text = selectedValue;
                                  print(_roleController);
                                });
                              },
                            ),
                          ),

                          
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isRegistering =
                                      true; // Set the loading state to true
                                });

                                // _addUser(); // Call the registration function

                                setState(() {
                                  isRegistering =
                                      false; // Set the loading state back to false when registration is completed
                                });
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                              child:
                                  isRegistering // Show loading indicator if isRegistering is true
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          "Tambah User"), // Show "Register" button when not loading
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
