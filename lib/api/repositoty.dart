import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sth/models/sport_json.dart';

class Repository {

  List<String> getSports(result) => (result['sports'] as List)
      .map((map) => SportJson.fromJson(map))
      .map((item) => item.name)
      .toList();

  getPositions(String name, result) => (result['sports'] as List)
      .map((map) => SportJson.fromJson(map))
      .where((item) => item.name == name)
      .map((item) => item.positions)
      .expand((i) => i)
      .toList();

  // Future<List<String>> getPositions() async {
  //   var data = await rootBundle.loadString("assets/sports.json");
  //   var result = json.decode(data);
  //   // print(result);
  //   return (result['sports'] as List)
  //       .map((map) => SportJson.fromJson(map))
  //       .map((item) => item.name)
  //       .toList();
  // }

  loadJson() async {
    var data = await rootBundle.loadString("assets/sports.json");
    return json.decode(data);
  }
}
