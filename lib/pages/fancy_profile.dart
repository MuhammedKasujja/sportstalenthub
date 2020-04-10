import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/models/achievement.dart';
import 'package:sth/models/player.dart';
import 'package:sth/pages/files_page.dart';
import 'package:sth/pages/player_videos.dart';
import 'package:sth/pages/view_image.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/widgets/loading.dart';
import 'package:sth/widgets/retry.dart';

class FancyProfilePage extends StatefulWidget {
  final Player player;

  const FancyProfilePage({Key key, @required this.player}) : super(key: key);
  @override
  _FancyProfilePageState createState() => _FancyProfilePageState();
}

class _FancyProfilePageState extends State<FancyProfilePage>
    with TickerProviderStateMixin {
  TabController _tabController;
  final api = ApiService();
  var achievements;
  bool isFavourite = false;
  var appTab;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    achievements = api.getPlayersAchievements(playerId: widget.player.playerId);
    appTab = _generateAppTab(isFavourite);
    _checkFavourite();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    elevation: 0.0,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        widget.player.fullname,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      background: GestureDetector(
                        child: Hero(
                          tag: widget.player.playerId,
                          child: Image.network(
                            widget.player.profilePhoto,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onTap: () {
                          print("object");
                          AppUtils(
                            context: context,
                          ).gotoPage(
                              page: ViewImagePage(
                            tag: widget.player.playerId,
                            imageUrl: "${widget.player.profilePhoto}",
                          ));
                        },
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: appTab,
                    pinned: true,
                  )
                ];
              },
              body: Container(
                color: Colors.grey.shade400,
                child: SingleChildScrollView(
                  // physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        margin: EdgeInsets.all(0.0),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                subtitle: Text(Consts.SPORT),
                                title: Text(widget.player.category),
                              ),
                              ListTile(
                                subtitle: Text(Consts.COUNTRY),
                                title: Text(widget.player.nationality),
                              ),
                              ListTile(
                                subtitle: Text(Consts.TEAM),
                                title: Text(widget.player.teamName),
                              ),
                              ListTile(
                                title: Text(Consts.HEIGHT),
                                subtitle: widget.player.height != null
                                    ? Text(widget.player.height + " M")
                                    : Text(''),
                              ),
                              ListTile(
                                title: Text(Consts.WEIGHT),
                                subtitle: widget.player.weight != null
                                    ? Text(widget.player.weight + " kg")
                                    : Text(''),
                              ),
                              ListTile(
                                title: Text(Consts.DATE_OF_BIRTH),
                                subtitle: widget.player.dob != null
                                    ? Text(widget.player.dob)
                                    : Text(''),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              Consts.POSITIONS,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      _sportsCategories(widget.player.position),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              Consts.ACHIEVEMENTS,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: this.achievements,
                          builder: (context,
                              AsyncSnapshot<List<Achievement>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingIcon();
                            }
                            if (snapshot.hasError) {
                              return Container(
                                child: Center(
                                  child: InkWell(
                                    child: RetryIcon(),
                                    onTap: () {
                                      this.achievements =
                                          api.getPlayersAchievements(
                                              playerId: widget.player.playerId);
                                    },
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: EdgeInsets.all(0),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Chip(label: Text('From')),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  snapshot
                                                      .data[index].startDate,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Chip(label: Text('To')),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                    snapshot
                                                        .data[index].endDate,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            Divider(
                                              thickness: 3.0,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Text(snapshot
                                                  .data[index].description),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            snapshot.data[index]
                                                        .achievements !=
                                                    null
                                                ? Text(snapshot
                                                    .data[index].achievements)
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }),
                      SizedBox(
                        height: 10.0,
                      )
                    ],
                  ),
                ),
              )),
          // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          // floatingActionButton: FloatingActionButton(
          //   onPressed: _addRemoveFavourite,
          //   heroTag: null,
          // ),
        ),
      ),
    );
  }

  _generateAppTab(bool checked) {
    return _SliverAppBarDelegate(
        TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.transparent,
          controller: _tabController,
          tabs: [
            Tab(
              child: widget.player.category != null
                  ? Text(widget.player.category)
                  : Container(),
            ),
            Tab(
                text: widget.player.ageGroup == null
                    ? ''
                    : widget.player.ageGroup),
            Tab(
                text: widget.player.gender == null
                    ? ''
                    : widget.player.gender == 'M' ? 'Male' : 'Female'),
          ],
        ),
        widget.player,
        checked ? Icon(Icons.remove) : Icon(Icons.add), _addRemoveFavourite);
  }

  Widget _sportsCategories(String listCategories) {
    if (listCategories == null) {
      return Container();
    }

    var cats = listCategories.split(',');
    List<Widget> names = cats
        .map(
          (c) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Chip(label: Text(c)),
          ),
        )
        .toList();

    return Wrap(
      direction: Axis.horizontal,
      children: names,
    );
  }

  _addRemoveFavourite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> myPlayers =
        prefs.getStringList(Consts.PREF_LIST_FAVOURITE_PLAYERS) == null
            ? List()
            : prefs.getStringList(Consts.PREF_LIST_FAVOURITE_PLAYERS);

    if (myPlayers.contains(widget.player.playerId)) {
      setState(() {
        isFavourite = false;
        appTab = _generateAppTab(isFavourite);
        // AppUtils(context: context).showSnack(message: 'Remove from favourites');
      });
      myPlayers.remove(widget.player.playerId);
    } else {
      myPlayers.add(widget.player.playerId);
      setState(() {
        isFavourite = true;
        appTab = _generateAppTab(isFavourite);
      //  AppUtils(context: context).showSnack(message: 'Added to favourites');
      });
    }

    print("object");

    await prefs.setStringList(Consts.PREF_LIST_FAVOURITE_PLAYERS, myPlayers);
  }

  _checkFavourite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> myPlayers =
        prefs.getStringList(Consts.PREF_LIST_FAVOURITE_PLAYERS) == null
            ? List()
            : prefs.getStringList(Consts.PREF_LIST_FAVOURITE_PLAYERS);

    if (myPlayers.contains(widget.player.playerId)) {
      setState(() {
        isFavourite = true;
        appTab = _generateAppTab(isFavourite);
      });
    } else {
      setState(() {
        isFavourite = false;
        appTab = _generateAppTab(isFavourite);
      });
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Player player;
  Icon icon;
  final Function addFav;

  _SliverAppBarDelegate(this.tabBar, this.player, this.icon, this.addFav);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // print("Tab height: ${this._tabBar.preferredSize.height}");
    return Container(
        color: Colors.red,
        child: Stack(
          alignment: FractionalOffset(0.96, 1.8),
          children: <Widget>[
            Column(
              children: <Widget>[
                this.tabBar,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.photo,
                            color: Colors.white,
                          ),
                          Text(
                            "Photos",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      onTap: () {
                        AppUtils(context: context).gotoPage(
                            page: FilesPage(
                          category: Consts.FILE_TYPE_IMAGES,
                          playerId: this.player.playerId,
                          playerName: this.player.fullname,
                        ));
                      },
                    ),
                    InkWell(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                          Text(
                            "Videos",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      onTap: () {
                        AppUtils(context: context).gotoPage(
                            page: PlayerVideosPage(
                          playerId: this.player.playerId,
                          playerName: this.player.fullname,
                        ));
                      },
                    )
                  ],
                )
              ],
            ),
            FloatingActionButton(
                tooltip: "Add to Favourites",
                heroTag: null,
                child: icon,
                onPressed: addFav)
          ],
        ));
  }

  pressedIcon() {
    print("Hoola....");
  }
  // @override
  // double get maxExtent => this._tabBar.preferredSize.height;

  @override
  double get maxExtent => 90.0;

  @override
  double get minExtent => 90.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
