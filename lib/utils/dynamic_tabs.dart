import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/models/player.dart';
import 'package:sth/pages/search_player.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/widgets/profile_card.dart';
import 'package:sth/widgets/retry.dart';

class MyPlayersPage extends StatefulWidget {
  const MyPlayersPage({super.key});

  @override
  State<MyPlayersPage> createState() => _MyPlayersPageState();
}

class _MyPlayersPageState extends State<MyPlayersPage> {
  final _api = ApiService();
  var futurePlayers;
  late String playerIds;
  late List<Player> apiPlayers;
  late List<Player> filterPlayers;
  @override
  void initState() {
    super.initState();
    _getFavouriteListId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        title: const Text("My Players"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              AppUtils(context: context)
                  .gotoPage(page: const SearchPlayerPage());
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
              future: futurePlayers,
              builder: (context, AsyncSnapshot<List<Player>> playersSnapshot) {
                if (playersSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (playersSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: playersSnapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ProfileCard(
                          player: playersSnapshot.data![index],
                        );
                      },
                    );
                  } else {
                    return RetryAgainIcon(
                      onTry: () {
                        setState(
                          () {
                            futurePlayers = _api.getFavouritePlayers(playerIds);
                          },
                        );
                      },
                    );
                  }
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            AppUtils(context: context).gotoPage(page: const SearchPlayerPage());
          }),
    );
  }

  _getFavouriteListId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? myPlayersIds =
        prefs.getStringList(Consts.PREF_LIST_FAVOURITE_PLAYERS) ?? [];
    String ids = '';
    for (int i = 0; i < myPlayersIds.length; i++) {
      if (i == 0) {
        ids = 'players_ids[$i]=${myPlayersIds[i]}';
      } else {
        ids = '$ids&players_ids[$i]=${myPlayersIds[i]}';
      }
    }

    setState(() {
      playerIds = ids;
    });

    futurePlayers = _api.getFavouritePlayers(ids).then((players) {
      setState(() {
        apiPlayers = players;
      });
    });
  }
}
