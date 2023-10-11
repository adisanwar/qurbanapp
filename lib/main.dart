import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qurban_app/helpers/firebase_options.dart';
import 'package:qurban_app/ui/login.dart';
import 'package:qurban_app/ui/register.dart';
import 'package:qurban_app/ui/admin/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}