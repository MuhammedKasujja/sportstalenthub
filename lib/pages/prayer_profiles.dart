import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/models/models.dart';
import 'package:sth/pages/posts_tab.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/widgets/profile_card.dart';
import 'package:sth/widgets/retry.dart';
import 'package:sth/widgets/shimmers/shimmers.dart';

class PrayerProfiles extends StatefulWidget {
  const PrayerProfiles({Key? key, required this.sport});
  final Sport sport;

  @override
  _PrayerProfilesState createState() => _PrayerProfilesState();
}

class _PrayerProfilesState extends State<PrayerProfiles>
    with AutomaticKeepAliveClientMixin<PrayerProfiles> {
  final api = new ApiService();
  var playerList;
  bool isLoading = true;

  @override
  void initState() {
    // print("${widget.sport.sportId}");
    if (widget.sport.sportId != Consts.POSTS_PAGE_ID) {
      playerList = api.getPlayers(category: widget.sport.sportId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.sport.sportId == Consts.POSTS_PAGE_ID
        ? PostsPage()
        : FutureBuilder<List<Player>>(
            future: this.playerList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Player>> snapshot) {
              if (snapshot.hasError) {
                return Container(
                  child: Center(
                      child: InkWell(
                    child: RetryIcon(),
                    onTap: () {
                      setState(
                        () {
                          playerList =
                              api.getPlayers(category: widget.sport.sportId);
                        },
                      );
                    },
                  )),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShimmerWidget(
                  type: ShimmerType.player,
                );
                // return Container( child: Center(child: CircularProgressIndicator()),);
              }
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  if (widget.sport.sportId == Consts.LATEST_PROFILES_ID) {
                    return _headedList(snapshot.data!);
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ProfileCard(player: snapshot.data![index]),
                  );
                } else {
                  return Center(child: Text("No data Found"));
                }
              } else {
                return Text("No data Found");
              }
            },
          );
  }

  Widget _headedList(List<Player> players) => GroupedListView<Player, String>(
      elements: players,
      groupBy: (player) {
        return player.category;
      },
      groupSeparatorBuilder: (caterory) {
        // we will add this later
        return PlayersGroupSeparator(
          category: caterory,
        );
      },
      // order: GroupedListOrder.ASC,
      itemBuilder: (context, Player p) => ProfileCard(player: p));

  Player player = new Player(
      playerId: '56789',
      teamName: 'Kataka',
      fullname: "Kasujja Muhammed",
      //imageUrl: 'http://img.youtube.com/vi/rqahKvZZVdg/0.jpg',
      profilePhoto: 'lib/images/profile.jpg',
      lastUpdated: '20/04/2019 10:39 AM',
      category: 'Football',
      contact: '0774262923',
      nationality: 'Ugandan',
      position: 'GoalKeeper, Striker, Midfilder',
      dob: '22/07/1992',
      gender: 'Male',
      height: '5');

  @override
  bool get wantKeepAlive => true;
}

class PlayersGroupSeparator extends StatelessWidget {
  final String category;
  PlayersGroupSeparator({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Text(
          "$category",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
