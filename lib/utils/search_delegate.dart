import 'package:flutter/material.dart';
import 'package:sth/models/player.dart';

class PlayersSearchDelegate extends SearchDelegate {
  final List<Player> players;

  PlayersSearchDelegate(this.players);
  @override
  List<Widget> buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.arrow_menu,
        progress: null,
      ),
      onPressed: () {
        this.close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox();
  }
}
