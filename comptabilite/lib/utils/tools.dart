import 'dart:async';

class Tools {

  static Future<String> monthReferences(String month) async {
    Map<String, String> mapmonth = {
      '1': 'A',
      '2': 'B',
      '3': 'C',
      '4': 'D',
      '5': 'E',
      '6': 'F',
      '7': 'G',
      '8': 'H',
      '9': 'I',
      '10': 'J',
      '11': 'K',
      '12': 'L'
    };

    return mapmonth[month.toString()] ?? '';
  }
  
  static Future<String> oGenerator(int number) async {
    String oo = '';
    while (oo.length < number) {
      oo = '${oo}0';
    }
    return oo;
  }

  static String moneyFormat(dynamic amount, {String currency = 'AR'}) {
    try {
      double number;
      
      if (amount is String) {
        // Nettoyer la string
        String cleanedAmount = amount
            .replaceAll(' ', '')
            .replaceAll(',', '.')
            .replaceAll(RegExp(r'[^0-9.]'), '');
        
        if (cleanedAmount.isEmpty) return '0,00 $currency';
        number = double.parse(cleanedAmount);
      } else if (amount is int) {
        number = amount.toDouble();
      } else if (amount is double) {
        number = amount;
      } else {
        return '0,00 $currency';
      }
      
      // Formater avec 2 décimales
      final parts = number.toStringAsFixed(2).split('.');
      final integerPart = parts[0];
      final decimalPart = parts[1];
      
      // Ajouter les séparateurs de milliers
      final formattedInteger = integerPart.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} ',
      );
      
      return '$formattedInteger,$decimalPart $currency';
    } catch (e) {
      return '0,00 $currency';
    }
  }
}