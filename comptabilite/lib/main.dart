import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/auth/login.dart';
import 'pages/home/home.dart';
import 'pages/input/date_form.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Forcer l'orientation portrait (optionnel)
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Define route titles
  static const Map<String, String> routeTitles = {
    '/': 'Accueil',
    '/login': 'Connexion',
    '/home': 'Tableau de bord',
    // '/date-form': 'Saisie de date',
    // '/saisie': 'Saisie',
    // '/contact': 'Contact',
    // '/settings': 'Paramètres',
  };

  // Get title for current route
  static String getTitleForRoute(String route) {
    debugPrint(route);
    return routeTitles[route] ?? 'HJA';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        primarySwatch: Colors.teal,
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
          ),
        ),
      ),
      title : getTitleForRoute(ModalRoute.of(context)?.settings.name ?? ''),
      initialRoute: '/date-form',
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const Login(),
        '/date-form': (context) => const DateForm(),
        '/settings': (context) => const SettingsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Utility function to get current page title
String getCurrentPageTitle(route) {
  debugPrint("route $route");
  debugPrint('Current route: $route');
  return MyApp.getTitleForRoute(route.toString());
}