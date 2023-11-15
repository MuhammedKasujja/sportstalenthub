import 'package:sth/models/player.dart';

class PlayerList {
  final int page;
  final int totalResults;
  final int totalPages;
  final List<Player> players;

  PlayerList({
    required this.page,
    required this.totalResults,
    required this.totalPages,
    required this.players,
  });

  factory PlayerList.fromJson(Map<String, dynamic> json) {
    return PlayerList(
      page: json['page'],
      totalResults: json['total_results'],
      totalPages: json['total_pages'],
      players: new List<Player>.from(
        json['players'].map((p) => Player.fromJson(p)),
      ),
    );
  }
}
