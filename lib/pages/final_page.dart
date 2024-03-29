import 'package:flutter/material.dart';
import 'package:pref_dessert/pref_dessert_internal.dart';
import 'package:sth/api/database.dart';
import 'package:sth/models/models.dart';
import 'package:sth/pages/feedback.dart';
import 'package:sth/pages/prayer_profiles.dart';
import 'package:sth/pages/search_player.dart';
import 'package:sth/pages/settings.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'drag_drop.dart';
import 'my_players.dart';
import './drag_drop_settings.dart';

class StartPage extends StatefulWidget {
  final List<Sport> sportsList;

  const StartPage({super.key, required this.sportsList});
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<StartPage> {
  late TabController tabController;

  List<DrawerTile> drawerTiles = [
    const DrawerTile(
      title: Consts.search,
      icon: Icons.search,
      page: SearchPlayerPage(),
    ),
    const DrawerTile(
      title: Consts.FAVOURITE_PLAYERS,
      icon: Icons.favorite,
      page: MyPlayersPage(),
    ),
    const DrawerTile(
      title: Consts.LOGIN,
      icon: Icons.list,
    ),
    const DrawerTile(
      title: Consts.CREATE_ACCOUNT,
      icon: Icons.list,
      page: DragDropSettiogsPage(),
    ),
    const DrawerTile(
      title: Consts.feedback,
      icon: Icons.list,
      page: FeedbackPage(),
    ),
  ];

  var repo = FuturePreferencesRepository<Sport>(SportDesSer());
  int _allSports = 0;
  void initTabController(int index) {
    tabController = TabController(
        initialIndex: index, length: widget.sportsList.length, vsync: this);
  }

  _addTab(Sport s) {
    setState(() {
      widget.sportsList.add(s);
    });
  }

  Future<void> changeTabs(Sport s) async {
    await _addTab(s);
  }

  void closeCurrentTab() {
    if (widget.sportsList.length > 2) {
      setState(() {
        widget.sportsList.removeAt(tabController.index);
        if (tabController.index > 0) {
          initTabController(tabController.index - 1);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initTabController(0);

    DBProvider.db.getCount().then((total) {
      setState(() {
        _allSports = total;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95),
        child: AppBar(
          title: const Text(Consts.appName),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                AppUtils(context: context)
                    .gotoPage(page: const MyPlayersPage());
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                AppUtils(context: context)
                    .gotoPage(page: const SearchPlayerPage());
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                AppUtils(context: context).gotoPage(
                    page: SettingsPage(
                  totalSports: _allSports,
                  callbackRemoveTabs: _addRemoveTabs,
                  callbackClearTabs: _removeAllTabs,
                ));
              },
            )
          ],
          bottom: TabBar(
            controller: tabController,

            // labelColor: Colors.redAccent,
            // unselectedLabelColor: Colors.white,
            // indicatorSize: TabBarIndicatorSize.label,
            // indicator: BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            //     color: Colors.white),

            tabs: widget.sportsList
                .map((t) => Tab(
                      text: t.name,
                    ))
                .toList(),
            isScrollable: true,
          ),
        ),
      ),
      body: TabBarView(
          controller: tabController,
          children: widget.sportsList
              .map(
                (s) => PrayerProfiles(
                  sport: s,
                ),
              )
              .toList()),
      drawer: appDrawer(),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.home,
      //         ),
      //         label: 'Home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.favorite), label: 'My Players'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.settings), label: 'Settings'),
      //   ],
      // ),
    );
  }

  Widget appDrawer() {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      color: Colors.red,
      child: SafeArea(
        child: Container(
          color: Consts.DRAWER_COLOR,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 200,
                child: Container(
                  decoration: const BoxDecoration(
                      //color: Colors.grey[100],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                      minHeight: double.infinity,
                    ),
                    child: Image.asset(
                      "assets/images/logo.jpg",
                    ),
                  ),
                  // child: Center(
                  //   child: Text(
                  //     Consts.APP_NAME,
                  //     style: TextStyle(
                  //         fontSize: 24,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.redAccent),
                  //   ),
                  // ),
                ),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: drawerTiles,
                      ),
                      DrawerTile(
                          icon: Icons.settings,
                          title: Consts.settings,
                          page: FinalSettingsPage(
                            totalSports: _allSports,
                            callbackRemoveTabs: _addRemoveTabs,
                            callbackClearTabs: _removeAllTabs,
                          )),
                      const DrawerTile(icon: Icons.info, title: Consts.ABOUT),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _addRemoveTabs(List<Sport> removeSports) {
    _changeTabs(removeSports);
    DBProvider.db.getCount().then((total) {
      setState(() {
        _allSports = total;
      });
    });
  }

  _removeAllTabs(List<Sport> savedTabs) {
    if (savedTabs.isNotEmpty) {
      setState(() {
        widget.sportsList.removeRange(3, widget.sportsList.length);
        //initTabController(tabController.index - 1);
        initTabController(0);
      });
    }
  }

  Future<void> _changeTabs(List<Sport> removeSports) async {
    //await _removeTabs(removeSports);
    // await _removeTabs(removeSports);
    var addedSports = await repo.findAll();
    print('Sports: ${addedSports.length}');
    await _addTabs(addedSports);
  }

  _addTabs(List<Sport>? newSports) {
    if (newSports != null) {
      for (Sport s in newSports) {
        changeTabs(s).then((onValue) {
          initTabController(widget.sportsList.length - 1);
          print(tabController.length);
          tabController.animateTo(tabController.index - 1);
        });
        print("new ${s.sportId}");
      }
    }
  }

  Player player = Player(
      playerId: '5467890',
      fullname: "Kasujja Muhammed",
      //imageUrl: 'http://img.youtube.com/vi/rqahKvZZVdg/0.jpg',
      profilePhoto: "http://img.youtube.com/vi/rqahKvZZVdg/0.jpg",
      lastUpdated: '20/04/2019 10:39 AM',
      category: 'Soccer',
      contact: '0774262923',
      nationality: 'Ugandan',
      position:
          'GoalKeeper, Midfielder,GoalKeeper, Midfielder,GoalKeeper, Midfielder,GoalKeeper, Midfielder',
      dob: '22/07/1992',
      gender: 'Male',
      teamName: 'Barcelona',
      weight: '34',
      height: '5');
}

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? page;

  const DrawerTile({
    super.key,
    required this.title,
    required this.icon,
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            icon,
            color: Colors.red,
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.red),
          ),
          onTap: () {
            AppUtils(context: context).goBack();
            if (page != null) {
              AppUtils(context: context).gotoPage(page: page);
            } else {
              _launchURL();
            }
          },
        ),
        //Divider(),
      ],
    );
  }

  _launchURL() async {
    const url = 'https://www.sportstalenthub.com/login';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
