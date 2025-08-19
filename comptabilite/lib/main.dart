import 'package:flutter/material.dart';
import 'pages/auth/login.dart';
import 'pages/home/home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comptabilite HJA',
      initialRoute: '/',
      routes: {
        // '/': (context) => Login(),
        // '/acceuil': (context) => Home(),
        '/': (context) => Home(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
