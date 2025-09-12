import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import 'package:comptabilite/services/account_service.dart';
import 'package:comptabilite/services/rapport_service.dart';

import '../utils/filemanagement.dart';

class InputService {
  FileManagement fileManager = FileManagement();
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

  Future<void> stockDetailInputS(String? compte, String? reference, String? amount, String? operation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String inputdetails = "{\"compte\":\"$compte\",\"ref\":\"$reference\",\"amount\":\"$amount\", \"operation\":\"$operation\"}";
    prefs.setString('detailsinput', inputdetails);

    // Simulation
    String data = "[ ${prefs.getString('myi')}, ${prefs.getString("detailsinput")}]";
    debugPrint(data.toString());

    List<dynamic> jsonData = [];
    // try {
    //   final apiUrl = await FileManagement.apiLink('apisimulation');
    //   debugPrint('API URL: $apiUrl');
    //   final response = await http.post(
    //     Uri.parse(apiUrl),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode({'data' : data})
    //   );
      
    //   if (response.statusCode == 200) {
    //     jsonData = jsonDecode(response.body);
    //   }
    // } catch (e, stack) {
    //   debugPrint('Error occurred: $e');
    //   debugPrint('Stack trace: $stack');
    // }finally{
    //   // ignore: control_flow_in_finally
    //   return jsonData;
    // }

  }

}

