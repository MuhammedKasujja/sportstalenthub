import 'dart:convert';

import 'package:sth/api/urls.dart';

class Player{
  
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

  Player({this.playerId, this.fullname,this.gender, this.category,this.lastUpdated, this.nationality, this.contact, this.profilePhoto, this.dob, this.position, this.height,
   this.location, this.weight, this.teamName, this.birthPlace, this.ageGroup});

  factory Player.fromJson(Map<String, dynamic> json){
     return Player(
       playerId: json['player_id'].toString(),
       fullname: json['full_name'],
       weight: json['weight'].toString(),
       height: json['height'].toString(),
       dob: json['birth_date'],
       birthPlace: json['birth_place'],
       nationality: json['country_name'],
       category: json['sport_name'],
       //contact: json['contact'],
       profilePhoto: Urls.PROFILE_PHOTO_LINK+json['profile_photo'],
       gender: json['gender'],
       teamName: json['team_name'],
       position: json['position'],
       ageGroup: json['group_name'],
    );
  }
  
}