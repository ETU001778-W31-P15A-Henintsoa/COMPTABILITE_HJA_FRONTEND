import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'dart:convert';

class FileManagement {

  static Future<String> apiLink(String key) async {
    final String response = await rootBundle.loadString('lib/config/api.json');
    final data = json.decode(response);
    return data[key].toString();
  }

  Future<String?> readContent(String filePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      debugPrint(directory.path);
      // final file = File(filePath);
      // if (await file.exists()) {
      //   return await file.readAsString();
      // }
      throw Exception('File does not exist');
    } catch (e) {
      debugPrint('Error reading file: $e');
      return null;
    }
  }

  Future<void> appendToFile(String filepath, String content) async {
    try {
      String? initialContents = await readContent(filepath);
      await File(filepath).writeAsString("$initialContents//$content");
    } catch (e) {
      debugPrint('Error writing file: $e');
    }
  }
  
}