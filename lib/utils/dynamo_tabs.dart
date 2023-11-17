import 'package:flutter/material.dart';

class DynamicTabContent {
  IconData icon;
  String tooTip;

  DynamicTabContent.name(this.icon, this.tooTip);
}

class CardStack extends StatefulWidget {
  const CardStack({super.key});

  @override
  State<CardStack> createState() => _MainState();
}

class _MainState extends State<CardStack> with TickerProviderStateMixin {
  List<DynamicTabContent> myList = [];

  late TabController _cardController;

  late TabPageSelector _tabPageSelector;

  @override
  void initState() {
    super.initState();

    myList.add(DynamicTabContent.name(Icons.favorite, "Favorited"));
    myList.add(DynamicTabContent.name(Icons.local_pizza, "local pizza"));

    _cardController = TabController(vsync: this, length: myList.length);
    _tabPageSelector = TabPageSelector(controller: _cardController);
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: IconButton(
              icon: const Icon(
                Icons.add,
                size: 30.0,
                color: Colors.white,
              ),
              tooltip: 'Add Tabs',
              onPressed: () {
                List<DynamicTabContent> tempList = [];

                for (var dynamicContent in myList) {
                  tempList.add(dynamicContent);
                }

                setState(() {
                  myList.clear();
                });

                if (tempList.length % 2 == 0) {
                  myList.add(
                    DynamicTabContent.name(
                      Icons.shopping_cart,
                      "shopping cart",
                    ),
                  );
                } else {
                  myList.add(
                    DynamicTabContent.name(
                      Icons.camera,
                      "camera",
                    ),
                  );
                }

                for (var dynamicContent in tempList) {
                  myList.add(dynamicContent);
                }

                setState(() {
                  _cardController =
                      TabController(vsync: this, length: myList.length);
                  _tabPageSelector =
                      TabPageSelector(controller: _cardController);
                });
              },
            ),
          ),
        ],
        title: const Text("Title Here"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Theme(
            data: Theme.of(context)
                .copyWith(scaffoldBackgroundColor: Colors.grey),
            child: myList.isEmpty
                ? Container(
                    height: 30.0,
                  )
                : Container(
                    height: 30.0,
                    alignment: Alignment.center,
                    child: _tabPageSelector,
                  ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _cardController,
        children: myList.isEmpty
            ? <Widget>[]
            : myList.map(
                (dynamicContent) {
                  return Card(
                    child: SizedBox(
                      height: 450.0,
                      width: 300.0,
                      child: IconButton(
                        icon: Icon(dynamicContent.icon, size: 100.0),
                        tooltip: dynamicContent.tooTip,
                        onPressed: null,
                      ),
                    ),
                  );
                },
              ).toList(),
      ),
    );
  }
}
