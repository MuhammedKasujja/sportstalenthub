import '../entities/attachment.dart';

abstract class IPlayerAttachmentsRepo {
  Future<List<Attachment>> getPlayersAttachments({
    required String playerId,
    required String category,
  });
}
