import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:comptabilite/services/account_service.dart';
import 'package:comptabilite/services/rapport_service.dart';

import '../utils/filemanagement.dart';
import '../utils/tools.dart';

class InputService {
  FileManagement fileManager = FileManagement();
  Tools tools = Tools();
  RapportService rapportService = RapportService();
  AccountService accountService = AccountService();
  
  // tout les rapports
  Future<List<dynamic>> rapports() async {
    try {
      List<dynamic> rapports = await rapportService.rapports();
      return rapports;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> accounts() async {
    try {
      List<dynamic> accounts = await accountService.accounts();
      return accounts;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> stockDateInput(String? month, String? year, String? idr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myi = "{\"mois\":\"$month\",\"annee\":\"$year\",\"idRapport\":\"$idr\"}";
    prefs.setString('myi', myi);
  }

  Future<String> getDocumentNumber(String? month, String? year, String? libelle) async {
    String prefix = libelle?[0].toUpperCase() ?? 'X';
    String r = 'XXXXXX/XX';
    try {
      final apiUrl = await FileManagement.apiLink('apinombrepiece');
      debugPrint('API URL: $apiUrl');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ 'prefix': prefix })
      );
      
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        String suffix = year != null && year.length >= 2 ? year.substring(year.length - 2) : 'XX';
        int number = int.parse(jsonData[0]['count']) + 1;
        int length = 6 - (2 + number.toString().length);
        String oo = await Tools.oGenerator(length);
        String monthRef = await Tools.monthReferences(month ?? 'X');
        r = '$prefix$monthRef$oo$number/$suffix';
      }else{
        debugPrint('Login failed: ${response.body}');
      }
    } catch (e, stack) {
      debugPrint('Error occurred: $e');
      debugPrint('Stack trace: $stack');
    }
    return r;
  }

  Future<bool> insertInput(Map<String, String> data) async {
    bool r = false;
    try {
      final apiUrl = await FileManagement.apiLink('apiinsertionsaisie');
      debugPrint('API URL: $apiUrl');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ 'data': data })
      );
      
      if (response.statusCode == 200) {
       r = true;
      }else{
        debugPrint('Login failed: ${response.body}');
      }
    } catch (e, stack) {
      debugPrint('Error occurred: $e');
      debugPrint('Stack trace: $stack');
    }
    return r;
  }

}

