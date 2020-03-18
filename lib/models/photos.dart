import 'package:sth/api/urls.dart';

class Photo{
  String filename;
  String playerId;

  Photo({this.playerId,this.filename});

  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
      filename: Urls.ACTION_PHOTOS_LINKS+json['filename'],
      playerId: json['player_id'].toString()
    );
  }

}