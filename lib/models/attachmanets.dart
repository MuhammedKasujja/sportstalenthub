import 'package:sth/api/urls.dart';

class Attachments{
  String filename;
  String playerId;

  Attachments({this.playerId,this.filename});

  factory Attachments.fromJson(Map<String, dynamic> json){
    return Attachments(
      filename: Urls.ACTION_PHOTOS_LINKS+json['filename'],
      playerId: json['player_id'].toString()
    );
  }

}