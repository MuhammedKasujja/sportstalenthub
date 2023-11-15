import 'package:flutter/material.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/api/database.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/models/sport_pref.dart';

//typedef FutureCallback = void Function(Future);

class PreferencesPage extends StatefulWidget {
  final ValueChanged<List<Sport>>? callbackRemoveTabs;
  final ValueChanged<List<Sport>>? callbackClearTabs;
  Future<String> one(List list) => Future.value("from one");

  const PreferencesPage({super.key, 
    this.callbackRemoveTabs,
    this.callbackClearTabs,
  });
  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  //Storing sport in SharedPref as Serialized
  var repo = FuturePreferencesRepository<Sport>(SportDesSer());

  final api = ApiService();
  final db = DBProvider();
  var sportsList;
  List<Sport> selectedList = [];
  List<Sport> savedList = [];
  @override
  void initState() {
    super.initState();
    sportsList = api.getSports();
    repo.findAll().then((sports) {
      savedList.addAll(sports);
      if (widget.callbackClearTabs != null) {
        widget.callbackClearTabs!(sports);
      }
      repo.removeAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              repo.saveAll(selectedList).then((list) {
                Navigator.pop(context, selectedList);
              });
              if (widget.callbackRemoveTabs != null) {
                widget.callbackRemoveTabs!(selectedList);
              }
            },
          ),
          title: const Text('Settings'),
          /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){
               
              // repo.removeAll();
               repo.saveAll(selectedList).then((list){
                 Navigator.pop(context, selectedList);
               });
               widget.callbackRemoveTabs(selectedList);
            },
          )
        ],*/
        ),
        body: FutureBuilder<List<Sport>>(
          future: sportsList,
          builder: (BuildContext context, AsyncSnapshot<List<Sport>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Error: ${snapshot.error}"),
                    IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(
                            () {
                              sportsList = api.getSports();
                            },
                          );
                        })
                  ],
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Sport sport = snapshot.data![index];
                      return CheckboxListTile(
                        title: Text(sport.name),
                        value: selectedList.contains(sport),
                        onChanged: (selected) {
                          if (selected != null)
                            _onSportSelected(selected, sport);
                        },
                      );
                    });
              } else {
                return const Center(child: Text("No data Found"));
              }
            } else {
              return const Text("No data Found");
            }
          },
        ));
  }

  void _onSportSelected(bool selected, sport) {
    if (selected) {
      setState(() {
        selectedList.add(sport);
        //repo.removeAll();
      });
    } else {
      setState(() {
        selectedList.remove(sport);
      });
    }
    for (Sport s in selectedList) {
      print(s.name);
    }
  }

  Future<void> removeAddTabs() async {
    if (widget.callbackRemoveTabs != null) {
      widget.callbackRemoveTabs!(savedList);
    }
    await repo.saveAll(selectedList);
    if (widget.callbackClearTabs != null) {
      widget.callbackClearTabs!(selectedList);
    }
  }

  void loadLocalSports() async {
    var _cars = await db.getAllSports();
    print(_cars);

    setState(() {
      sportsList = _cars;
    });
  }
}
