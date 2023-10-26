import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qurban_app/auth/register.dart';
import 'package:qurban_app/helpers/logincontroller.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
   final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController _loginController =
      Get.put(LoginController());
final _formkey = GlobalKey<FormState>();
void _handleLogin() async {
    // Call the registerUser method from the RegistrationController
    _loginController.login(
     
      _emailController.text,
      _passwordController.text,
      
    );
  }

late String email, password, role;
  bool isPasswordVisible = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Let's go!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("Login",
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.bold,
                  //     )),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      key: _formkey,
                      decoration: InputDecoration(
                        hintText:
                            "Masukan Email", // Add a space as a placeholder for the hint text
                        prefixIcon: const Icon(Icons.person),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ), // Gray border when focused
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ), // Gray border when enabled
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // Set the floating label behavior to "always"
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    
                  ),
                  // SizedBox(
                  //   height: 12,
                  // ),
                  // Text("Password",
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.bold,
                  //     )),
                  const SizedBox(
                    height: 10,
                  ),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      obscureText:
                          !isPasswordVisible, // Ini mengubahnya menjadi password field
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ), // Gray border when focused
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ), // Gray border when enabled
                          borderRadius: BorderRadius.circular(20),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            builder: (context) => Container(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  const Padding(padding: EdgeInsets.all(10)),
                                  const Text("Reset Password",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText:
                                            "Masukan No Handphone", // Add a space as a placeholder for the hint text
                                        prefixIcon: const Icon(Icons.phone),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ), // Gray border when focused
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ), // Gray border when enabled
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        // Set the floating label behavior to "always"
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      maxLength:
                                          12, // Batasi input hingga 12 karakter
                                      maxLines: 1, // Tetapkan maxLines ke 1
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Add your onPressed function here
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                              ),
                                            ),
                                            child: const Text("Reset Password"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )

                                  // Tambahkan teks atau widget lainnya di sini jika diperlukan
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Column(
                          children: [
                            Text(
                              "Lupa Password",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      )

                      // Text(
                      //   "Lupa Password?",
                      //   style: TextStyle(color: Colors.blue),
                      // )
                    ],
                  ),
                  

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
  onPressed: () {
    _handleLogin(); // Fungsi untuk melakukan login
  },
  style: ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Sesuaikan radius sesuai kebutuhan
      ),
    ),
  ),
  icon: Icon(Icons.login), // Ikon default sebelum diklik
  label: Text("Login"),
),

                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum punya Akun? "),
                      InkWell(
                        onTap: () {
                          Get.to(() =>const Register());
                        },
                        child: const Text(
                          "Daftar dulu Bro!",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

