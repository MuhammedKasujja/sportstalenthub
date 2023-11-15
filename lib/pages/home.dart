import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/pages/prayer_profiles.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tc;

  List<Map<String, dynamic>> _tabs = [];
  List<String> _views = [];

  @override
  void initState() {
    super.initState();
    this._addTab();
  }

  TabController _makeNewTabController() => TabController(
        vsync: this,
        length: _tabs.length,
        initialIndex: _tabs.length == 1 ? 0 : _tabs.length-2,
        
      );

  void _addTab() {
    setState(() {
      _tabs.add({
        'icon': Icons.star,
        'text': "Tab ${_tabs.length}",
      });
      _views.add("Tab ${_tabs.length}'s view");
      _tc = _makeNewTabController();
      //_tc.animateTo(_tabs.length);
    });
    //_tc.animateTo(_tabs.length);
  }

  void _removeTab() {
    setState(() {
      _tabs.removeLast();
      _views.removeLast();
      _tc = _makeNewTabController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic tabs"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: this._addTab),
          IconButton(icon: Icon(Icons.remove), onPressed: this._removeTab),
        ],
        bottom: TabBar(
          key: Key(Random().nextDouble().toString()),
          controller: _tc,
          isScrollable: true,
          tabs: _tabs
              .map((tab) => Tab(
                    icon: Icon(tab['icon']),
                    text: "Tab ${_tabs.length}",
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tc,
        children: _views
            .map((view) => PrayerProfiles(sport: Sport(name: view),))
            .toList(),
      ),
    );
  }
}