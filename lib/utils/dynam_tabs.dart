// TabController scroll exception when deleting tabs in a dynamic tab layout
// https://github.com/flutter/flutter/issues/24424

// This bug can be worked around for now by only resetting the tab
// controller after it has stopped changing. Here's a version of the
// original test case that does that:
// https://gist.github.com/HansMuller/15d7f306139ec92e5ecefb58f85a3d3f

import 'package:flutter/material.dart';

class DynamoTabs extends StatefulWidget {
  const DynamoTabs({super.key});

  @override
  DynamoTabsState createState() => DynamoTabsState();
}

class DynamoTabsState extends State<DynamoTabs> with TickerProviderStateMixin {
  late TabController tabController;
  List<Tab> tabs = <Tab>[const Tab(text: '0')];

  void initTabController(int index) {
    tabController =
        TabController(initialIndex: index, length: tabs.length, vsync: this);
  }

  void newTab() {
    setState(() {
      tabs.add(Tab(text: '${tabs.length}'));
      initTabController(tabs.length - 1);
      //initTabController(0);
    });
  }

  void closeCurrentTab() {
    if (tabs.length > 1) {
      setState(() {
        tabs.removeAt(tabController.index);
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
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: newTab,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: closeCurrentTab,
          )
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: tabs.map((tab) => tab).toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children:
            tabs.map((tab) => Center(child: Text(tab.text ?? ''))).toList(),
      ),
    );
  }
}
