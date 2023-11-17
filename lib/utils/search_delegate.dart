import 'package:flutter/material.dart';
import 'package:sth/models/player.dart';

class PlayersSearchDelegate extends SearchDelegate {
  final List<Player> players;

  PlayersSearchDelegate(this.players);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      // icon: AnimatedIcon(
      //   icon: AnimatedIcons.arrow_menu,
      //   progress: null,
      // ),
      icon: const Icon(Icons.menu_open),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }
}
