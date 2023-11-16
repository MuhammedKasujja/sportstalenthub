import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_players_event.dart';
part 'search_players_state.dart';

class SearchPlayersBloc extends Bloc<SearchPlayersEvent, SearchPlayersState> {
  SearchPlayersBloc() : super(SearchPlayersInitial()) {
    on<SearchPlayersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
