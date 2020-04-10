import 'package:flutter/material.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/api/database.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/models/sport_pref.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/widgets/retry.dart';

class SettingsPage extends StatefulWidget {
  final ValueChanged<List<Sport>> callbackRemoveTabs;
  final ValueChanged<List<Sport>> callbackClearTabs;
  final int totalSports;
  Future<String> one(List list) => new Future.value("from one");

  const SettingsPage({
    Key key,
    this.totalSports,
    this.callbackRemoveTabs,
    this.callbackClearTabs,
  }) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //Storing sport in SharedPref as Serialized
  var repo = new FuturePreferencesRepository<Sport>(new SportDesSer());

  final api = ApiService();
  final db = DBProvider();
  Future<List<Sport>> sportsList;
  List<Sport> selectedList = List();
  List<Sport> repoList = List();
  @override
  void initState() {
    super.initState();
    repo.findAll().then((sports) {
      widget.callbackClearTabs(sports);
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
      List<Sport> savedList = List();
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
            IconButton(icon: Icon(Icons.save), onPressed: _saveChanges,)
          ],
        ),
        body: FutureBuilder<List<Sport>>(
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
              if (snapshot.data.length > 0) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Sport sport = snapshot.data[index];
                      return CheckboxListTile(
                        title: new Text(sport.name),
                        value: selectedList.contains(sport), //sport.isSelected,
                        onChanged: (bool selected) {
                          _onSportSelected(selected, sport);
                          print(selected);
                        },
                      );
                    });
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
    widget.callbackRemoveTabs(selectedList);
  }
}
