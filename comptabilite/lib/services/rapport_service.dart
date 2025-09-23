import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../utils/filemanagement.dart';

class RapportService {

  Future<List<dynamic>> rapports() async {
    List<dynamic> jsonData = [];
    try {
      final apiUrl = await FileManagement.apiLink('apirapports');
      debugPrint('API URL: $apiUrl');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        jsonData = jsonDecode(response.body);
      }else{
        debugPrint('Login failed: ${response.body}');
      }
    } catch (e, stack) {
      debugPrint('Error occurred: $e');
      debugPrint('Stack trace: $stack');
    }finally{
      // ignore: control_flow_in_finally
      return jsonData;
    }
  }

}