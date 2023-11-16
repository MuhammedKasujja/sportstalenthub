import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'player_profile_event.dart';
part 'player_profile_state.dart';

class PlayerProfileBloc extends Bloc<PlayerProfileEvent, PlayerProfileState> {
  PlayerProfileBloc() : super(PlayerProfileInitial()) {
    on<PlayerProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
