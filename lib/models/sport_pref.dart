import 'package:pref_dessert/pref_dessert.dart';
import 'package:sth/models/sport.dart';

class SportDesSer extends DesSer<Sport>{
  @override
  Sport deserialize(String s) {
    var split = s.split(",");
    return new Sport(name :split[0],sportId: split[1]);
  }

  @override
  String serialize(Sport s) {
    return "${s.name},${s.sportId}";
  }

  @override
  String get key => "Sport";

}