import 'package:sth/api/urls.dart';

class Attachment{
  String filename;
  String playerId;

  Attachment({this.playerId,this.filename});

  factory Attachment.fromJson(Map<String, dynamic> json){
    return Attachment(
      filename: Urls.ACTION_PHOTOS_LINKS+json['filename'],
      playerId: json['player_id'].toString()
    );
  }

}