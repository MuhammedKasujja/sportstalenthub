import 'package:flutter/foundation.dart';

class Logger {
  Logger._();

  static void debug({dynamic data, String? key}) {
    if (key != null) {
      debugPrint('{ $key : ${data.toString()} }');
    } else {
      debugPrint(data.toString());
    }
  }
}