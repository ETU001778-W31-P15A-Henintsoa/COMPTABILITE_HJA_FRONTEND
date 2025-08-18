import 'package:flutter/material.dart';

import 'package:comptabilite/services/login_service.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
  }

class _HomeState extends State<Home> {
  final LoginService loginService = LoginService();



  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    var loggedin = await loginService.sessioncCheck();
    if(loggedin == 0) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: const Text('Welcome to the Home Page!'),
      ),
    );
  }
}