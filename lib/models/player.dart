import 'dart:convert';

import 'package:sth/api/urls.dart';
import 'package:sth/utils/consts.dart';

class Player {
  String playerId;
  String fullname;
  String dob;
  String gender;
  String nationality;
  String location;
  String contact;
  String profilePhoto;
  String category;
  String lastUpdated;
  String position;
  String height;
  String weight;
  String teamName;
  String birthPlace;
  String ageGroup;

  Player(
      {this.playerId,
      this.fullname,
      this.gender,
      this.category,
      this.lastUpdated,
      this.nationality,
      this.contact,
      this.profilePhoto,
      this.dob,
      this.position,
      this.height,
      this.location,
      this.weight,
      this.teamName,
      this.birthPlace,
      this.ageGroup});

  Player.fromJson(Map<String, dynamic> json) {
    // return Player(
    playerId = json['player_id'].toString();
    fullname = json['full_name'];
    weight = json['weight'].toString();
    height = json['height'].toString();
    dob = json['birth_date'];
    birthPlace = json['birth_place'];
    nationality = json['country_name'];
    category = json['sport_name'];
    //contact: json['contact'],
    profilePhoto = Urls.PROFILE_PHOTO_LINK + json['profile_photo'];
    gender = json['gender'];
    teamName = json['team_name'];
    position = json['position'];
    //ageGroup = json['group_name'];
    ageGroup = _getAgeGroup(json['birth_date']);
    // );
  }

  String _getAgeGroup(String birthDate) {
    var birthYear = int.parse(birthDate.substring(0, 4));
    var dateTime = DateTime.now();
    var age = dateTime.year - birthYear;
    String ageGroup;
    if (age >= 0 && age <= 7) {
      ageGroup = Consts.GROUP_U17;
    } else if (age >= 8 && age <= 10) {
      ageGroup = Consts.GROUP_U10;
    } else if (age >= 11 && age <= 13) {
      ageGroup = Consts.GROUP_U13;
    } else if (age >= 14 && age <= 15) {
      ageGroup = Consts.GROUP_U15;
    } else if (age >= 16 && age <= 17) {
      ageGroup = Consts.GROUP_U17;
    } else if (age >= 18 && age <= 20) {
      ageGroup = Consts.GROUP_U20;
    } else if (age >= 21 && age <= 23) {
      ageGroup = Consts.GROUP_U23;
    } else {
      ageGroup = Consts.GROUP_ABOVE23;
    }

    return ageGroup;
  }
}
