import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sth/models/player.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';

import 'files_page.dart';

class ProfilePage extends StatefulWidget {
  final Player player;

  const ProfilePage({super.key, required this.player});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late ScrollController scrollController;
  late TabController tabController;
  final _myTabbedPageKey = GlobalKey<_ProfilePageState>();
  int selectedTab = 0;
  bool isFavourite = false;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    tabController = TabController(length: 3, vsync: this);
    _checkFavourite();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: roundedAppBar(),
      key: _myTabbedPageKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            stackedAppBar(widget.player),
            Expanded(
              child: details(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: isFavourite ? const Icon(Icons.remove) : const Icon(Icons.add),
          onPressed: () {
            _addRemoveFavourite();
          }),
    );
  }

  Widget details() {
    return Column(
      children: <Widget>[
        Container(
            color: Colors.transparent,
            constraints: const BoxConstraints.expand(height: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedTab == 0 ? Colors.teal : Colors.white,
                  ),
                  child: const Text("Details"),
                  onPressed: () {
                    //tabController.animateTo((tabController.index + 1) % 2);
                    tabController.animateTo(0);
                    setState(() {
                      selectedTab = 0;
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedTab == 1 ? Colors.green : Colors.white,
                  ),
                  child: const Text("Career"),
                  onPressed: () {
                    tabController.animateTo(1);
                    setState(() {
                      selectedTab = 1;
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedTab == 2 ? Colors.yellow : Colors.white,
                  ),
                  child: const Text("Achievements"),
                  onPressed: () {
                    tabController.animateTo(2);
                    setState(() {
                      selectedTab = 2;
                    });
                  },
                )
              ],
            )),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: const <Widget>[
              Center(child: Text('Details')),
              Center(child: Text('Career')),
              Center(child: Text('Achievements')),
            ],
          ),
        )
      ],
    );
  }

  Widget stackedAppBar(Player player) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: <Widget>[
          Container(
            height: 220,
            //color: Colors.green,
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),),),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  AppUtils(
                    context: context,
                  ).goBack();
                },
              )),
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.player.profilePhoto),
              minRadius: 60,
              maxRadius: 60,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                share(
                    message: '${widget.player.fullname} \n${widget.player.nationality}');
              },
            ),
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    widget.player.fullname,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(widget.player.nationality),
                  Text(widget.player.category),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(FontAwesomeIcons.cameraRetro),
              onPressed: () {
                AppUtils(context: context).gotoPage(
                    page: FilesPage(
                  category: Consts.FILE_TYPE_IMAGES,
                  playerId: widget.player.playerId,
                  playerName: widget.player.fullname,
                ));
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(FontAwesomeIcons.video),
              onPressed: () {
                AppUtils(context: context).gotoPage(
                    page: FilesPage(
                  category: Consts.FILE_TYPE_VIDEOS,
                  playerId: widget.player.playerId,
                  playerName: widget.player.fullname,
                ));
              },
            ),
          ),
          Positioned(
              top: 200,
              left: 15,
              right: 15,
              child: Card(
                color: Colors.red,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.tealAccent,
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            flex: 3,
                            child: Text(
                              "Height",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child:
                                Text("D.O.B", style: TextStyle(fontSize: 16)),
                          ),
                          Flexible(
                            flex: 3,
                            child:
                                Text("Gender", style: TextStyle(fontSize: 16)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            flex: 3,
                            child: Text(
                              player.height ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Text(
                              player.dob,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Text(
                              player.gender,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget bottomContainer() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),),
              child: const SizedBox(
                width: 250.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            color: Colors.red,
                          ),
                          Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              " Tasks",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              "Holla",
                              style: TextStyle(fontSize: 28.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'hi',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx > 0) {
              if (index > 0) index--;
            } else {
              if (index < 2) index++;
            }
            setState(() {
              scrollController.animateTo((index) * 256.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn);
            });
          },
        );
      },
    );
  }

  Widget topContainer() {
    var prayer = widget.player;
    return Expanded(
      child: Container(
        height: 400,
        color: Colors.red,
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              SizedBox(
                  height: 180,
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        child: Image.asset(
                      widget.player.profilePhoto,
                    )),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    prayer.fullname,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(prayer.nationality),
                  Text(prayer.category),
                  Text(prayer.dob),
                  Text(prayer.contact ?? '')
                ],
              )
            ]),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.teal,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: Text("Postion"),
                  ),
                  Flexible(
                    child: Text("Nationality"),
                  ),
                  Flexible(
                    child: Text("Gender"),
                  ),
                  Flexible(
                    child: Text("Age"),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: Text(prayer.position),
                  ),
                  Flexible(
                    child: Text(prayer.nationality),
                  ),
                  Flexible(
                    child: Text(prayer.gender),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  share({title = 'Share', message}) {
    //  SimpleShare.share(
    //     title: title,
    //     msg: message,
    //     uri: 'http://google.com'
    // );
  }

  _addRemoveFavourite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? myPlayers =
        prefs.getStringList(Consts.PREF_LIST_FAVOURITE_PLAYERS) ?? [];

    if (myPlayers.contains(widget.player.playerId)) {
      setState(() {
        isFavourite = false;
      });
      myPlayers.remove(widget.player.playerId);
    } else {
      myPlayers.add(widget.player.playerId);
      setState(() {
        isFavourite = true;
      });
    }

    await prefs.setStringList(Consts.PREF_LIST_FAVOURITE_PLAYERS, myPlayers);
  }

  _checkFavourite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? myPlayers =
        prefs.getStringList(Consts.PREF_LIST_FAVOURITE_PLAYERS) ?? [];

    if (myPlayers.contains(widget.player.playerId)) {
      setState(() {
        isFavourite = true;
      });
    } else {
      setState(() {
        isFavourite = false;
      });
    }
  }
}
