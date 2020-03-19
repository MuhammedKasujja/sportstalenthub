import 'package:flutter/material.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/models/achievement.dart';
import 'package:sth/models/player.dart';
import 'package:sth/pages/files_page.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    achievements = api.getPlayersAchievements(playerId: widget.player.playerId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      widget.player.fullname,
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    background: Image.network(
                      widget.player.profilePhoto,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Colors.transparent,
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: widget.player.height == null
                            ? Text('')
                            : Text(widget.player.height + " M"),
                      ),
                      Tab(
                          text: widget.player.dob == null
                              ? ''
                              : widget.player.dob),
                      Tab(
                          text: widget.player.gender == null
                              ? ''
                              : widget.player.gender),
                    ],
                  )),
                  pinned: true,
                )
              ];
            },
            body: Container(
              color: Colors.grey.shade400,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                subtitle: Text("Sport"),
                                title: Text(widget.player.category),
                              ),
                              ListTile(
                                subtitle: Text("Country"),
                                title: Text(widget.player.nationality),
                              ),
                              ListTile(
                                subtitle: Text("Team"),
                                title: Text(widget.player.teamName),
                              ),
                              ListTile(
                                title: Text("Weight"),
                                subtitle: widget.player.weight != null
                                    ? Text(widget.player.weight + " kg")
                                    : Text(''),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text("Positions", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    _sportsCategories(widget.player.position),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text("Achievements", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    FutureBuilder(
                        future: this.achievements,
                        builder: (context,
                            AsyncSnapshot<List<Achievement>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                                snapshot.data[index].startDate),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(snapshot.data[index].endDate),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(snapshot
                                                .data[index].description),
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
      ),
    );
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
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // print("Tab height: ${this._tabBar.preferredSize.height}");
    return Container(color: Colors.indigoAccent, child: Column(
      children: <Widget>[
        this._tabBar,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(child: Icon(Icons.photo), onTap: (){
              AppUtils(context: context).gotoPage(
                    page: FilesPage(
                  category: Consts.FILE_TYPE_IMAGES,
                ));
            },),
            InkWell(child: Icon(Icons.videocam), onTap: (){
              AppUtils(context: context).gotoPage(
                    page: FilesPage(
                  category: Consts.FILE_TYPE_VIDEOS,
                ));
            },)
          ],
        )
      ],
    ));
  }

  // @override
  // double get maxExtent => this._tabBar.preferredSize.height;

  @override
  double get maxExtent => 80.0;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
