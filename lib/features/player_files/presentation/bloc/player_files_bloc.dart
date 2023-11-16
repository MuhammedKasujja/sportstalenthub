import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'player_files_event.dart';
part 'player_files_state.dart';

class PlayerFilesBloc extends Bloc<PlayerFilesEvent, PlayerFilesState> {
  PlayerFilesBloc() : super(PlayerFilesInitial()) {
    on<PlayerFilesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
