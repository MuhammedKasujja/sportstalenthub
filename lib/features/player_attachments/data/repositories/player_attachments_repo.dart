import 'package:flutter/foundation.dart';
import 'package:sth/core/core.dart';

import '../../domain/repositories/i_player_attachments_repo.dart';
import '../models/attachment.dart';

class PlayerAttachmentsRepo extends IPlayerAttachmentsRepo {
  final ApiClient apiClient;
  PlayerAttachmentsRepo({required this.apiClient});

  @override
  Future<List<AttachmentModel>> getPlayersAttachments({
    required String playerId,
    required String category,
  }) async {
    final res = await apiClient.dio
        .get(
            "${Urls.GET_PLAYERS_ATTACHMENTS}player_id=$playerId&category=$category")
        .catchError((onError) {
      Logger.debug(key: "CatchError", data: onError.toString());
    });
    return compute(_parsePlayersPhotos, res.data);
  }

  static List<AttachmentModel> _parsePlayersPhotos(resBody) {
    final photos =
        (resBody['files'] as List).map((p) => AttachmentModel.fromJson(p));
    return photos.toList();
  }
}
