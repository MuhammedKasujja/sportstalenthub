import 'dart:math';

import 'package:flutter/material.dart';

class DynamicTabsPage extends StatefulWidget {
  @override
  _DynamicTabsPageState createState() => _DynamicTabsPageState();
}

class _DynamicTabsPageState extends State<DynamicTabsPage> with TickerProviderStateMixin {
  TabController _tc;

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
        initialIndex: _tabs.length - 1,
      );

  void _addTab() {
    setState(() {
      _tabs.add({
        'icon': Icons.star,
        'text': "Tab ${_tabs.length}",
      });
      _views.add("Tab ${_tabs.length}'s view");
      _tc = _makeNewTabController();
    });
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
            .map((view) => Center(child: Text("Tab ${_tabs.length}'s view")))
            .toList(),
      ),
    );
  }
}