import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../utils/filereader.dart';

class LoginService {

  Future<int> sessioncCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedIn = prefs.getString('utilisateur');

    if (loggedIn == null || loggedIn == false) {
      return 0; 
    }
    return 1;
  }

  Future<int> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('utilisateur');
    return 1;
  }

  Future<int> login(String id, String mdp) async {
    try {
      final apiUrl = await FileReader().apiLink('apilogin');
      debugPrint('API URL: $apiUrl');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifiant': id, 'mdp': mdp}),
      );

      if (response.statusCode == 200) {
        String user = response.body.toString();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('utilisateur', user);
        return 1;
      }else{
        debugPrint('Login failed: ${response.body}');
        return 0;
      }
    } catch (e, stack) {
      debugPrint('Error occurred: $e');
      debugPrint('Stack trace: $stack');
      return 0;
    }
  }

}
