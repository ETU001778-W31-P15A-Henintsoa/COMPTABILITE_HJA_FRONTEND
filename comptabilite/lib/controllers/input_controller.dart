import 'package:flutter/material.dart';

import 'package:comptabilite/pages/home/home.dart';
import 'package:comptabilite/pages/input/detail_form.dart';
import '../services/input_service.dart';

class InputController {
  final InputService inputService = InputService();

  Future<void> stockDateInput(String? month, String? year, String? idRapport, String? libelle, BuildContext context) async {
    try {
      await inputService.stockDateInput(month, year, idRapport);
      String numeropiece = await inputService.getDocumentNumber(month, year, libelle);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailForm(
            month: month,
            year: year,
            idr: idRapport,
            libelle: libelle,
            npiece: numeropiece,
          ),
        ),
      );
    } catch (e, stack) {
      debugPrint('Erreur: $e');
      debugPrint('Stack trace: $stack');
    }
  }

  Future<void> insertInput(BuildContext context, Map<String, String> data) async {
    try {
      bool r = await inputService.insertInput(data);
      if(r) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text.rich(
            TextSpan(
                text: "Une erreur c'est produite",
                style: TextStyle(color: Colors.white),
              ),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }      
    } catch (e, stack) {
      debugPrint('Erreur: $e');
      debugPrint('Stack trace: $stack');
    }
  }

  Future<List<dynamic>> rapports() async {
    try {
      List<dynamic> rapports = await inputService.rapports();
      return rapports;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> accounts() async {
    try {
      List<dynamic> accounts = await inputService.accounts();
      return accounts;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

}