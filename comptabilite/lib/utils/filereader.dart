import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class FileReader {
  Future<String> apiLink(String key) async {
    final String response = await rootBundle.loadString('lib/config/api.json');
    final data = json.decode(response);
    return data[key].toString();
  }
  
}