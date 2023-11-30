import 'package:sth/core/core.dart';

import '../../domain/entities/attachment.dart';

class AttachmentModel extends Attachment {
  const AttachmentModel({required super.filename, required super.playerId});

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
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

    return AttachmentModel(
        filename: file, playerId: json['player_id'].toString());
  }
}
