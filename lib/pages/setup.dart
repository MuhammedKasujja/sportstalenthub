import 'package:flutter/material.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/api/database.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/models/sport_pref.dart';

class SetupPage extends StatefulWidget {
  final ValueChanged<List<Sport>> callbackRemoveTabs;
  final ValueChanged<List<Sport>> callbackClearTabs;
  final int totalSports;
  Future<String> one(List list) => Future.value("from one");

  const SetupPage({super.key, 
    required this.totalSports,
    required this.callbackRemoveTabs,
    required this.callbackClearTabs,
  });
  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  //Storing sport in SharedPref as Serialized
  var repo = FuturePreferencesRepository<Sport>(SportDesSer());

  final api = ApiService();
  final db = DBProvider();
  late Future<List<Sport>> sportsList;
  // List<Sport> selectedList = List();
  List<int> selectedList = [];
  @override
  void initState() {
    super.initState();
    // repo.findAll().then((sports){
    //   widget.callbackClearTabs(sports);
    //   repo.removeAll();
    // });
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
      List<int> savedList = [];
      for (Sport s in sports) {
        if (s.isSelected) {
          savedList.add(int.parse(s.sportId!));
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              //    repo.saveAll(selectedList).then((list){
              //     Navigator.pop(context, selectedList);
              //   });
              //  widget.callbackRemoveTabs(selectedList);
            },
          ),
          title: const Text('Settings'),
        ),
        body: FutureBuilder<List<Sport>>(
          future: sportsList,
          builder: (BuildContext context, AsyncSnapshot<List<Sport>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "No internet connection",
                    style: TextStyle(fontSize: 18.0),
                  ),
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
              ));
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
                        value: selectedList.contains(
                            int.parse(sport.sportId!)), //sport.isSelected,
                        onChanged: (selected) {
                          _onSportSelected(selected ?? false, sport);
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

  void _onSportSelected(bool selected, Sport sport) {
    if (selected) {
      setState(() {
        sport.isSelected = true;
        selectedList.add(int.parse(sport.sportId!));

        //repo.removeAll();
      });
    } else {
      setState(() {
        sport.isSelected = false;
        selectedList.remove(int.parse(sport.sportId!));
      });
    }
    DBProvider.db.updateSport(sport);
    print('object: ${sport.isSelected} ID: ${sport.sportId}');
    // for(Sport s in selectedList){
    //    print(s.name);
    // }
  }

  void loadLocalSports() async {
    var _cars = await db.getAllSports();
    print(_cars);

    setState(() {
      //sportsList = _cars;
    });
  }
}
