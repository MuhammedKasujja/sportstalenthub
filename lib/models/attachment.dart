import 'package:sth/api/urls.dart';

class Attachment {
  String filename;
  String playerId;

  Attachment({this.playerId, this.filename});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    String file, temp;
    if (json['filename'].toString().contains("http")) {
      temp = json['filename'];
      if (temp.toLowerCase().contains("youtu.be")) {
        file = temp.substring(temp.lastIndexOf("/") + 1);
      } else if (temp.toLowerCase().contains("youtube.com")) {
        file = temp.split("v=")[1];
      } else {
        file = temp.substring(temp.lastIndexOf("/") + 1);
      }
    } else {
      file = Urls.ACTION_PHOTOS_LINKS + json['filename'];
    }

    return Attachment(filename: file, playerId: json['player_id'].toString());
  }

  _getVideoIdFromUrl(String videoUrl) {
    videoUrl = videoUrl.replaceFirst("&feature=youtube.be", "");
    if (videoUrl.toLowerCase().contains("youtube.be")) {
      return videoUrl.substring(videoUrl.lastIndexOf("/") + 1);
    }
  }
}
