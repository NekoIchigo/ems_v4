import 'dart:convert';
import 'package:flutter/services.dart';

class JsonUtils {
  // Fetch content from a json file
  Future readJson(String url) async {
    return await rootBundle.loadString(url).then((value) {
      final data = jsonDecode(value);
      return data;
    });
  }
}
