import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sports_event.dart';
part 'sports_state.dart';

class SportsBloc extends Bloc<SportsEvent, SportsState> {
  SportsBloc() : super(SportsInitial()) {
    on<SportsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
