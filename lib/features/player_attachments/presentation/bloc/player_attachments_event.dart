part of 'player_attachments_bloc.dart';

abstract class PlayerAttachmentsEvent extends Equatable {
  const PlayerAttachmentsEvent();

  @override
  List<Object> get props => [];
}

class FetchPlayerAttachments extends PlayerAttachmentsEvent {
  final String playerId;
  final String category;

  const FetchPlayerAttachments({
    required this.playerId,
    required this.category,
  });

  @override
  List<Object> get props => [playerId, category];
}
