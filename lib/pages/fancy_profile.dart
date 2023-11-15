import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/models/models.dart';
import 'package:sth/pages/files_page.dart';
import 'package:sth/pages/player_videos.dart';
import 'package:sth/pages/view_image.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/widgets/shimmers/shimmers.dart';
import 'package:sth/widgets/retry.dart';

class FancyProfilePage extends StatefulWidget {
  final Player player;

  const FancyProfilePage({Key? key, required this.player});
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
    _tabController = TabController(length: 3, vsync: this);
    achievements = api.getPlayersAchievements(playerId: widget.player.playerId);
    appTab = _generateAppTab(isFavourite);
    _checkFavourite();
    super.initState();
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
                    expandedHeight: 220.0,
                    floating: false,
                    pinned: true,
                    elevation: 0.0,
                    leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(context)),
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
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        onTap: () {
                          AppUtils(
                            context: context,
                          ).gotoPage(
                              page: ViewImagePage(
                            title: widget.player.fullname,
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
                color: Colors.grey.shade300,
                child: SingleChildScrollView(
                  // physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Flexible(
                                    child: ListTile(
                                      subtitle: Text(widget.player.category),
                                      title: Text(Consts.SPORT),
                                    ),
                                  ),
                                  Flexible(
                                    child: ListTile(
                                      subtitle: Text(widget.player.nationality),
                                      title: Text(Consts.COUNTRY),
                                    ),
                                  ),
                                ],
                              ),
                              ListTile(
                                subtitle: Text(Consts.TEAM),
                                title: Text(widget.player.teamName),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: ListTile(
                                      title: Text(Consts.HEIGHT),
                                      subtitle: (widget.player.height != null &&
                                                  widget.player.height
                                                      .isNotEmpty ||
                                              widget.player.height != 'null')
                                          ? Text(widget.player.height + " M")
                                          : Text('-'),
                                    ),
                                  ),
                                  Flexible(
                                    child: ListTile(
                                      title: Text(Consts.WEIGHT),
                                      subtitle: (widget.player.weight != null &&
                                              widget.player.weight.isNotEmpty)
                                          ? Text(widget.player.weight + " kg")
                                          : Text('-'),
                                    ),
                                  ),
                                  Flexible(
                                    child: ListTile(
                                      title: Text(Consts.DATE_OF_BIRTH),
                                      subtitle: widget.player.dob != null
                                          ? Text(widget.player.dob)
                                          : Text(''),
                                    ),
                                  ),
                                ],
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
                              return ShimmerWidget(
                                itemLength: 3,
                                type: ShimmerType.careerPath,
                              );
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
                                    elevation: 5,
                                    margin:
                                        EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Chip(
                                                  elevation: 8,
                                                  label: Text(
                                                    'From',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      Colors.red[400],
                                                ),
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
                                                Chip(
                                                    elevation: 8,
                                                    label: Text(
                                                      'To',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        Colors.red[400]),
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
                                              thickness: 1.0,
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
                                            snapshot.data[index].achievements !=
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
          floatingActionButton: _itemsButton(), //_buildFloatingActionButton(),
          // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          // floatingActionButton: FloatingActionButton(
          //   onPressed: _addRemoveFavourite,
          //   heroTag: null,
          // ),
        ),
      ),
    );
  }

  Widget _itemsButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          tooltip: 'photos',
          child: Icon(Icons.photo),
          onPressed: () {
            AppUtils(context: context).gotoPage(
                page: FilesPage(
              category: Consts.FILE_TYPE_IMAGES,
              playerId: widget.player.playerId,
              playerName: widget.player.fullname,
            ));
          },
          heroTag: null,
        ),
        SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          tooltip: 'videos',
          child: Icon(Icons.videocam),
          onPressed: () {
            AppUtils(context: context).gotoPage(
                page: PlayerVideosPage(
              playerId: widget.player.playerId,
              playerName: widget.player.fullname,
            ));
          },
          heroTag: null,
        ),
      ],
    );
  }

  Widget _tabItem(String value) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
          color: Colors.red[300], borderRadius: BorderRadius.circular(5)),
      child: Center(child: Text(value ?? '')),
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
            _tabItem(widget.player.category),
            _tabItem(widget.player.ageGroup),
            _tabItem(widget.player.gender == 'M' ? 'Male' : 'Female'),
          ],
        ),
        widget.player,
        checked ? 'Unfollow' : 'Follow',
        _addRemoveFavourite);
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
            child: Chip(
              label: Text(
                c,
                style: TextStyle(color: Colors.red),
              ),
              backgroundColor: Colors.white,
            ),
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
  String type;
  final Function addFav;

  _SliverAppBarDelegate(this.tabBar, this.player, this.type, this.addFav);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // print("Tab height: ${this._tabBar.preferredSize.height}");
    return Container(
        padding: EdgeInsets.only(top: 8),
        color: Colors.white,
        child: Stack(
          alignment: FractionalOffset(0.96, 1.8),
          overflow: Overflow.visible,
          children: <Widget>[
            Column(
              children: <Widget>[
                this.tabBar,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: <Widget>[
                //     InkWell(
                //       child: Column(
                //         children: <Widget>[
                //           Icon(
                //             Icons.photo,
                //             color: Colors.white,
                //           ),
                //           Text(
                //             "Photos",
                //             style: TextStyle(color: Colors.white),
                //           )
                //         ],
                //       ),
                //       onTap: () {
                //         AppUtils(context: context).gotoPage(
                //             page: FilesPage(
                //           category: Consts.FILE_TYPE_IMAGES,
                //           playerId: this.player.playerId,
                //           playerName: this.player.fullname,
                //         ));
                //       },
                //     ),
                //     InkWell(
                //       child: Column(
                //         children: <Widget>[
                //           Icon(
                //             Icons.videocam,
                //             color: Colors.white,
                //           ),
                //           Text(
                //             "Videos",
                //             style: TextStyle(color: Colors.white),
                //           )
                //         ],
                //       ),
                //       onTap: () {
                //         AppUtils(context: context).gotoPage(
                //             page: PlayerVideosPage(
                //           playerId: this.player.playerId,
                //           playerName: this.player.fullname,
                //         ));
                //       },
                //     )
                //   ],
                // )
              ],
            ),
            Positioned(
              right: 10,
              bottom: -15,
              child: InkWell(
                onTap: addFav,
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  elevation: 10,
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        this.type,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
            // FloatingActionButton(
            //   backgroundColor: Colors.transparent,
            //     tooltip: "Add to Favourites",
            //     heroTag: null,
            //     child: Container(
            //       height: 30,
            //       width: 100,
            //       decoration: BoxDecoration(
            //           color: Colors.grey,
            //           borderRadius: BorderRadius.circular(10)),
            //       child: Center(
            //         child: Text('Follow'),
            //       ),
            //     ),
            //     onPressed: addFav)
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
