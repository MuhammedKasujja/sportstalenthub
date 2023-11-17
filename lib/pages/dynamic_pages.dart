import 'package:flutter/material.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/pages/prayer_profiles.dart';
import 'package:sth/pages/search_player.dart';
import 'package:sth/pages/settings.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/utils/dynamo_tabs.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  PageController pageController = PageController();
  var currentPageValue = 0.0;

  late List<Widget> _tabTitles;

  List<Sport> sportsList = [
    Sport(name: Consts.FEATURED_PROFILES, sportId: '11001'),
    Sport(
      name: Consts.LATEST_PROFILES,
    ),
    Sport(name: Consts.FOOTBALL, sportId: '1'),
    Sport(name: Consts.NETBALL, sportId: '2'),
    Sport(name: Consts.VOLLEYBALL, sportId: '6'),
    Sport(name: "American Football", sportId: '13'),
    Sport(name: "Basketball", sportId: '3'),
    Sport(name: "Baseball", sportId: '15'),
    Sport(name: Consts.DARTS, sportId: '11'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: sportsList.length);

    _tabTitles = sportsList
        .map((s) => InkWell(
                child: Tab(
              text: s.name,
            )))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("STH"),
        bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.amber,
            tabs: _tabTitles),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              AppUtils(context: context).gotoPage(page: const SearchPlayerPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              navigateToSettings();
            },
          )
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        itemBuilder: (context, position) {
          return PrayerProfiles(
            sport: sportsList[position],
          );
        },
        itemCount: sportsList.length, // Can be null
      ),
      drawer: appDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //AppUtils(context: context).gotoPage(page: HomePage());
          setState(() {
            Sport sport = Sport(name: 'Bad Minton', sportId: '1');
            sportsList.add(sport);
            // _tabTitles.add(Tab(text: sport.name,));
            pageController.animateToPage((sportsList.length),
                duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
          });
        },
      ),
    );
  }

  navigateToSettings() async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => const CardStack()))
        .then((onValue) {
      setState(() {
        //tabList = onValue;
      });
    });
  }

  Widget appDrawer() {
    return Drawer(
        child: Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                child: const Center(
                  child: Text(
                    Consts.APP_NAME,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
            drawerTile(title: 'Create Account'),
            drawerTile(title: 'Settings', page: const SettingsPage()),
            drawerTile(title: 'About'),
          ],
        ),
      ),
    ));
  }

  Widget drawerTile({title, page}) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          onTap: () {
            AppUtils(context: context).goBack();
            _launchURL();
            if (page != null) {
              AppUtils(context: context).gotoPage(page: page);
            }
          },
        ),
        const Divider(),
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

  @override
  bool get wantKeepAlive => true;
}
