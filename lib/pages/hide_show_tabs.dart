import 'package:flutter/material.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/pages/prayer_profiles.dart';
import 'package:sth/pages/search_player.dart';
import 'package:sth/pages/settings.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/utils/dynamo_tabs.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowTabsTage extends StatefulWidget {
  const ShowTabsTage({super.key});

  @override
  State<ShowTabsTage> createState() => _ShowTabsTageState();
}

class _ShowTabsTageState extends State<ShowTabsTage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  late List<Widget> _tabViews;

  late List<Widget> _tabTitles;

  List<Sport> sportsList = [
    Sport(name: Consts.FEATURED_PROFILES, sportId: '11001', isSelected: true),
    Sport(name: Consts.LATEST_PROFILES, isSelected: true),
    Sport(name: Consts.FOOTBALL, sportId: '1', isSelected: true),
    Sport(name: Consts.NETBALL, sportId: '2', isSelected: true),
    Sport(name: Consts.VOLLEYBALL, sportId: '6', isSelected: true),
    Sport(name: "American Football", sportId: '13', isSelected: false),
    Sport(name: "Basketball", sportId: '3', isSelected: false),
    Sport(name: "Baseball", sportId: '15', isSelected: true),
    Sport(name: Consts.DARTS, sportId: '11', isSelected: false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: sportsList.length);

    _tabViews = sportsList
        .map(
          (s) => s.isSelected
              ? PrayerProfiles(
                  sport: s,
                )
              : const Opacity(
                  opacity: 0.0,
                ),
        )
        .toList();

    _tabTitles = sportsList
        .map((t) => t.isSelected
            ? Tab(
                text: t.name,
              )
            : Visibility(visible: false, child: Tab(text: t.name)))
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
      body: TabBarView(
        controller: _tabController,
        children: _tabViews,
      ),
      drawer: appDrawer(),
      /* floatingActionButton: FloatingActionButton(
        onPressed: (){
          AppUtils(context: context).gotoPage(page: HomePage());
        },
      ),
      */
    );
  }

  navigateToSettings() async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => CardStack()))
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
