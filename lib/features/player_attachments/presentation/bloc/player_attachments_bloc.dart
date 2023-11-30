import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sth/core/models/models.dart';

import '../../data/models/attachment.dart';
import '../../data/repositories/player_attachments_repo.dart';

part 'player_attachments_event.dart';
part 'player_attachments_state.dart';

class PlayerAttachmentsBloc
    extends Bloc<PlayerAttachmentsEvent, PlayerAttachmentsState> {
  final PlayerAttachmentsRepo playerAttachmentsRepo;
  PlayerAttachmentsBloc({required this.playerAttachmentsRepo})
      : super(PlayerAttachmentsState.init()) {
    on<FetchPlayerAttachments>((event, emit) async {
      emit(state.load());
      final res = await playerAttachmentsRepo.getPlayersAttachments(
        playerId: event.playerId,
        category: event.category,
      );
      emit(state.loaded(data: res));
    });
  }
}
