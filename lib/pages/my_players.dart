import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/models/models.dart';
import 'package:sth/pages/search_player.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/widgets/profile_card.dart';
import 'package:sth/widgets/retry.dart';
import 'package:sth/widgets/search_widget.dart';
import 'package:sth/widgets/shimmers/index.dart';

class MyPlayersPage extends StatefulWidget {
  @override
  _MyPlayersPageState createState() => _MyPlayersPageState();
}

class _MyPlayersPageState extends State<MyPlayersPage> {
  final _api = ApiService();
  String playerIds;
  List<Player> apiPlayers;
  List<Player> filterPlayers;
  bool hasError = false;
  String filter = '';
  @override
  void initState() {
    super.initState();
    _getFavouriteListId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text("My Players"),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.search),
          //   onPressed: () {
          //     AppUtils(context: context).gotoPage(page: SearchPlayerPage());
          //   },
          // ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SearchWidget(
              onTextChange: _onTextChange,
            ),
            // SizedBox(
            //   height: 5,
            // ),
            apiPlayers != null && apiPlayers.length > 0
                ? filter !=
                        '' //filterPlayers != null && filterPlayers.length > 0
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: filterPlayers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ProfileCard(
                              player: filterPlayers[index],
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: apiPlayers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ProfileCard(
                              player: apiPlayers[index],
                            );
                          },
                        ),
                      )
                : Expanded(
                    child: Container(
                        child: Center(
                            child: hasError
                                ? RetryAgainIcon(
                                    onTry: () {
                                      setState(() {
                                        hasError = false;
                                      });
                                      _fetchPlayers(playerIds);
                                    },
                                  )
                                : ShimmerWidget(
                                    type: ShimmerType.player,
                                  )))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            AppUtils(context: context).gotoPage(page: SearchPlayerPage());
          }),
    );
  }

  _getFavouriteListId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> myPlayersIds =
        prefs.getStringList(Consts.PREF_LIST_FAVOURITE_PLAYERS) == null
            ? List()
            : prefs.getStringList(Consts.PREF_LIST_FAVOURITE_PLAYERS);
    String ids;
    for (int i = 0; i < myPlayersIds.length; i++) {
      if (i == 0) {
        ids = 'players_ids[' + i.toString() + ']=' + myPlayersIds[i];
      } else {
        ids = ids + '&players_ids[' + i.toString() + ']=' + myPlayersIds[i];
      }
    }

    setState(() {
      playerIds = ids;
    });

    _fetchPlayers(playerIds);

    //print("My Ids: " + ids);
  }

  _onTextChange(String value) {
    //print(value);
    setState(() {
      filter = value;
      filterPlayers = apiPlayers.where((p) {
        return p.fullname.toLowerCase().contains(value.toLowerCase()) ||
            p.category.toLowerCase().contains(value.toLowerCase());
      }) //|| p.fullname.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  _fetchPlayers(String ids) {
    _api.getFavouritePlayers(ids).then((players) {
      setState(() {
        apiPlayers = players;
      });
    }).catchError((onError) {
      setState(() {
        hasError = true;
      });
    });
  }
}
