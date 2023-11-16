import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'player_attachments_event.dart';
part 'player_attachments_state.dart';

class PlayerAttachmentsBloc extends Bloc<PlayerAttachmentsEvent, PlayerAttachmentsState> {
  PlayerAttachmentsBloc() : super(PlayerAttachmentsInitial()) {
    on<PlayerAttachmentsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
