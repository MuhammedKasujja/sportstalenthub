import 'package:flutter/material.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/pages/prayer_profiles.dart';
import 'package:sth/pages/preferences.dart';
import 'package:sth/utils/app_utils.dart';

class StartPage extends StatefulWidget{
  final List<Sport> sportsList;

  const StartPage({Key key, @required this.sportsList}) : super(key: key);
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<StartPage>{
  TabController tabController;
  List<Widget> _tabViews;

  List<Widget> _tabTitles;

  void initTabController(int index, List<Sport> sports) {
    tabController = TabController(initialIndex: index, length: sports.length, vsync: this);
  }

  void newTab() {
    setState(() {
      widget.sportsList.add(new Sport(sportId: "15",name: "Baseball"));
      initTabController(widget.sportsList.length - 1, widget.sportsList);
      //initTabController(0);
    });
  }

  void closeCurrentTab() {
    if (widget.sportsList.length > 1) {
      setState((){
        widget.sportsList.removeAt(tabController.index);
        if (tabController.index > 0) {
          initTabController(tabController.index - 1, widget.sportsList);
        }
      });
    }
  }

  @override void initState() {
    super.initState();
       // initTabController(tabController.index - 1, widget.sportsList);
      _tabTitles =  widget.sportsList.map((s) => InkWell(child: new Tab(text: s.name,))).toList();
      _tabViews = widget.sportsList.map((s) => PrayerProfiles(sport: s,),).toList();
      initTabController(0, widget.sportsList);
      for( Sport s in widget.sportsList){
          print(s.name);
      }
    
  }

  @override void dispose() {
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add), onPressed: newTab),
            IconButton(icon: Icon(Icons.close), onPressed: closeCurrentTab,),
            IconButton(icon: Icon(Icons.settings), onPressed: (){
              AppUtils(context: context).gotoPage(page: PreferencesPage());
            },)
          ],
          bottom: TabBar(controller: tabController,
                  tabs: _tabTitles,
                  isScrollable: true,),
        ),
        body: TabBarView(
          controller: tabController,
          children: _tabViews
        ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}