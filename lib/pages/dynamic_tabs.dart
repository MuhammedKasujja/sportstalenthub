import 'package:flutter/material.dart';
import 'package:pref_dessert/pref_dessert_internal.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/models/sport_pref.dart';
import 'package:sth/pages/prayer_profiles.dart';
import 'package:sth/pages/preferences.dart';
import 'package:sth/pages/search_player.dart';
import 'package:sth/pages/settings.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/utils/custom_tab.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicTabsPage extends StatefulWidget {
  final List<Sport> sportsList;

  const DynamicTabsPage({Key? key, required this.sportsList});
  @override
  _DynamicTabsPageState createState() => _DynamicTabsPageState();
}

class _DynamicTabsPageState extends State<DynamicTabsPage>
    with AutomaticKeepAliveClientMixin<DynamicTabsPage> {
  int initPosition = 0;
  var repo = new FuturePreferencesRepository<Sport>(new SportDesSer());
  List<Sport> savedSports = [];

  @override
  void initState() {
    super.initState();
    var list = repo.findAll();
    list.then((onValue) {
      for (Sport s in onValue) {
        print(s.name);
        setState(() {
          savedSports.add(s);
          //sportsList.add(s);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("STH"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              AppUtils(context: context).gotoPage(page: SearchPlayerPage());
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              navigateToSettings();
            },
          )
        ],
      ),
      body: SafeArea(
        child: CustomTabView(
            initPosition: initPosition,
            itemCount: widget.sportsList.length,
            tabBuilder: (context, index) =>
                Tab(text: widget.sportsList[index].name),
            pageBuilder: (context, index) {
              print("ID: " + widget.sportsList[index].sportId.toString());
              return Container(
                  child: PrayerProfiles(
                sport: widget.sportsList[index],
              ));
            },
            onPositionChange: (index) {
              print('current position: $index');
              initPosition = index;
            },
            onScroll: (position) => () {} //print('$position'),
            ),
      ),
      drawer: appDrawer(),
    );
  }

  navigateToSettings() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PreferencesPage(callbackRemoveTabs: _addRemoveTabs)));
  }

  Widget appDrawer() {
    return Drawer(
        child: Container(
      width: MediaQuery.of(context).size.width - 60,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                child: Center(
                  child: Text(
                    Consts.APP_NAME,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
            drawerTile(
              title: 'Login',
            ),
            drawerTile(title: 'Create Account'),
            drawerTile(title: 'Settings', page: SettingsPage()),
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
        Divider(),
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

  _addRemoveTabs(List<Sport> removeSports) {
    _changeTabs(removeSports);
  }

  _removeTabs(List<Sport> removeSports) {
    List<Sport> oldSports = [];

    for (Sport r in widget.sportsList) {
      for (Sport s in removeSports) {
        if (s == r) {
          oldSports.add(s);
          print("saved ${s.name} ids: ${s.sportId}");
        }
      }
    }
    for (Sport s in oldSports) {
      setState(() {
        widget.sportsList.removeWhere((sport) => sport == s);
      });
      print("removed ${s.name} ids: ${s.sportId}");
    }

    if (removeSports.length > 0) {
      setState(() {
        initPosition = 0;
      });
    }
  }

//
//Demo for clearing the list first before adding new Tabs to avoid scrolling to
//
  _removeAllTabs(List<Sport> savedTabs) {
    setState(() {
      // savedTabs.clear();
      widget.sportsList.removeRange(2, widget.sportsList.length);
      initPosition = 0;
    });
  }

  Future<void> _changeTabs(List<Sport> removeSports) async {
    //await _removeTabs(removeSports);
    await _removeAllTabs(removeSports);
    var addedSports = await repo.findAll();
    await _addTabs(addedSports);
  }

  _addTabs(List<Sport>? newSports) {
    if (newSports != null) {
      for (Sport s in newSports) {
        setState(() {
          widget.sportsList.add(s);
        });
        print("new ${s.sportId}");
      }
    }
  }
}
