import 'package:flutter/material.dart';
import 'package:comptabilite/services/login_service.dart';

import '../widgets/navbar.dart';
import '../input/date_form.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
  }

class _HomeState extends State<Home> {
  _HomeState();

  final LoginService loginService = LoginService();

  @override
  void initState() {
    super.initState();
    // _checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveNavBar(title: 'Accueil'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildBox(context, 'Saisie', Icons.input, const DateForm()),
              _buildBox(context, 'Utilisateurs', Icons.person, const ProfilePage()),
              _buildBox(context, 'Paramètres', Icons.settings, const SettingsPage()),
              _buildBox(context, 'Aide', Icons.help, const HelpPage()),
              _buildBox(context, 'Aide', Icons.help, const HelpPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox(BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: SizedBox(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Colors.white),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Page Profile')),
    );
  }
}



class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Page Settings')),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      body: const Center(child: Text('Page Aide')),
    );
  }
}


