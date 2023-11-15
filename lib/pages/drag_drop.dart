import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/api/database.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/models/sport_pref.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/widgets/retry.dart';

class FinalSettingsPage extends StatefulWidget {
  final ValueChanged<List<Sport>>? callbackRemoveTabs;
  final ValueChanged<List<Sport>>? callbackClearTabs;
  final int totalSports;
  Future<String> one(List list) => new Future.value("from one");

  const FinalSettingsPage({
    Key? key,
    required this.totalSports,
    this.callbackRemoveTabs,
    this.callbackClearTabs,
  });
  @override
  _FinalSettingsPageState createState() => _FinalSettingsPageState();
}

class _FinalSettingsPageState extends State<FinalSettingsPage> {
  //Storing sport in SharedPref as Serialized
  var repo = new FuturePreferencesRepository<Sport>(new SportDesSer());

  List<DragAndDropList> _contents = <DragAndDropList>[];

  final api = ApiService();
  final db = DBProvider();
  late Future<List<Sport>> sportsList;
  List<Sport> selectedList = [];
  List<Sport> repoList = [];
  @override
  void initState() {
    super.initState();
    repo.findAll().then((sports) {
      if (widget.callbackClearTabs != null) {
        widget.callbackClearTabs!(sports);
      }
      repoList.addAll(sports);
      repo.removeAll();
    });
    if (widget.totalSports > 0) {
      sportsList = db.getAllSports();
    } else {
      sportsList = api.getSports();
      sportsList.then((sports) {
        for (Sport s in sports) {
          s.isSelected = false;
          db.newSport(s);
        }
        // setState(() {});
      });
    }

    db.getAllSports().then((sports) {
      List<Sport> savedList = [];
      for (Sport s in sports) {
        print("Name: ${s.name}, Selected: ${s.isSelected}, ID: ${s.sportId}");
        if (s.isSelected) {
          savedList.add(s);
        }
      }
      setState(() {
        selectedList.addAll(savedList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _saveChanges,
          ),
          title: Text(Consts.SETTINGS),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveChanges,
            )
          ],
        ),
        body: FutureBuilder(
          future: sportsList,
          builder: (BuildContext context, AsyncSnapshot<List<Sport>> snapshot) {
            if (snapshot.hasError) {
              print("${snapshot.error}");
              return RetryAgainIcon(
                onTry: () {
                  setState(
                    () {
                      sportsList = api.getSports();
                    },
                  );
                },
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                var listSports = snapshot.data!;

                return dragDropBoard(listSports);
                // ListView.builder(
                //     itemCount: snapshot.data.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       Sport sport = snapshot.data[index];
                //       return CheckboxListTile(
                //         title: new Text(sport.name),
                //         value: selectedList.contains(sport), //sport.isSelected,
                //         onChanged: (bool selected) {
                //           _onSportSelected(selected, sport);
                //           print(selected);
                //         },
                //       );
                //     });
              } else {
                return Center(child: Text(Consts.NO_DATA_FOUND));
              }
            } else {
              return Text(Consts.NO_DATA_FOUND);
            }
          },
        ));
  }

  void _onSportSelected(bool selected, Sport sport) {
    if (selected) {
      setState(() {
        sport.isSelected = true;
        selectedList.add(sport);
      });
    } else {
      setState(() {
        sport.isSelected = false;
        selectedList.remove(sport);
      });
    }
    DBProvider.db.updateSport(sport);
    print('object: ${sport.isSelected}');
    for (Sport s in selectedList) {
      print(s.name);
    }
  }

  void loadLocalSports() async {
    var _cars = await db.getAllSports();
    print(_cars);

    setState(() {
      //sportsList = _cars;
    });
  }

  _saveChanges() {
    repo.saveAll(selectedList).then((list) {
      Navigator.pop(context, selectedList);
    });
    //if(repoList.length > selectedList.length){

    //}
    if (widget.callbackRemoveTabs != null) {
      widget.callbackRemoveTabs!(selectedList);
    }
  }

  Widget dragDropBoard(List<Sport> listSports) {
    List<DragAndDropItem> mySports = [];
    List<DragAndDropItem> otherSports = [];
    listSports.forEach((sport) {
      if (sport.isSelected) {
        mySports.add(DragAndDropItem(
            child: Chip(
          key: Key(sport.sportId!),
          label: Text(
            sport.name,
          ),
        )));
      } else {
        otherSports.add(
          DragAndDropItem(
            child: Chip(
              key: Key(sport.sportId!),
              label: Text(
                sport.name,
              ),
            ),
          ),
        );
      }
    });
    _contents = [
      DragAndDropList(
        header: Text('My Sports'),
        canDrag: false,
        children: mySports,
      ),
      DragAndDropList(
        header: Text('Other Sports'),
        canDrag: false,
        children: otherSports,
      )
    ];

    return Column(
      children: <Widget>[
        Flexible(
          flex: 10,
          child: DragAndDropLists(
            children: _contents,
            onItemReorder: _onItemReorder,
            onListReorder: _onListReorder,
            onItemAdd: _onItemAdd,
            onListAdd: _onListAdd,
            listGhost: Container(
              height: 50,
              width: 100,
              child: Center(
                child: Icon(Icons.add),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }

  _onItemAdd(DragAndDropItem newItem, int listIndex, int itemIndex) {
    print('adding new item');
    setState(() {
      if (itemIndex == -1)
        _contents[listIndex].children.add(newItem);
      else
        _contents[listIndex].children.insert(itemIndex, newItem);
    });
  }

  _onListAdd(DragAndDropListInterface newList, int listIndex) {
    print('adding new list');
    setState(() {
      if (listIndex == -1)
        _contents.add(newList as DragAndDropList);
      else
        _contents.insert(listIndex, newList as DragAndDropList);
    });
  }
}
