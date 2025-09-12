import 'package:comptabilite/pages/input/detail_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/input_service.dart';

class InputController {
  final InputService inputService = InputService();

  Future<void> stockDateInput(String? month, String? year, String? idRapport, String? libelle, BuildContext context) async {
    try {
      await inputService.stockDateInput(month, year, idRapport);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailForm(
            month: month,
            year: year,
            idr: idRapport,
            libelle: libelle,
          ),
        ),
      );
    } catch (e, stack) {
      debugPrint('Erreur: $e');
      debugPrint('Stack trace: $stack');
    }
  }

  Future<void> simulation(BuildContext context, String? compte, String? reference, String? amount, String? operation) async {
    try {
      await inputService.stockDetailInputS(compte, reference, amount, operation);
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => DetailForm(
      //       month: month,
      //       year: year,
      //       idr: idRapport,
      //       libelle: libelle,
      //     ),
      //   ),
      // );
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