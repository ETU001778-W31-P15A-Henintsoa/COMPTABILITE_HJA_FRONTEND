import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class LoginService {

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        String responseBody = response.body;
        debugPrint(jsonDecode(responseBody));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('utilisateurs', responseBody);
        return true;
      }else{
        return false;
      }
    } catch (e, stack) {
      debugPrint('Error occurred: $e');
      debugPrint('Stack trace: $stack');
      return false;
    }
  }

}
