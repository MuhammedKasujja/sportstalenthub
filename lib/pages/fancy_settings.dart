import 'package:flutter/material.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/api/database.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/models/sport_pref.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/widgets/retry.dart';

class FancySettingsPage extends StatefulWidget {
  final ValueChanged<List<Sport>> callbackRemoveTabs;
  final ValueChanged<List<Sport>> callbackClearTabs;
  final int totalSports;

  const FancySettingsPage({
    super.key,
    required this.totalSports,
    required this.callbackRemoveTabs,
    required this.callbackClearTabs,
  });
  @override
  State<FancySettingsPage> createState() => _FancySettingsPageState();
}

class _FancySettingsPageState extends State<FancySettingsPage> {
  //Storing sport in SharedPref as Serialized
  var repo = FuturePreferencesRepository<Sport>(SportDesSer());

  final api = ApiService();
  final db = DBProvider();
  late Future<List<Sport>> sportsList;
  List<Sport> selectedList = [];
  List<Sport> repoList = [];
  Sport? selectedSport;
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
      List<Sport> savedList = [];
      for (Sport s in sports) {
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
          icon: const Icon(Icons.arrow_back),
          onPressed: _saveChanges,
        ),
        title: const Text(Consts.SETTINGS),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          )
        ],
      ),
      body: FutureBuilder<List<Sport>>(
        future: sportsList,
        builder: (BuildContext context, AsyncSnapshot<List<Sport>> snapshot) {
          if (snapshot.hasError) {
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
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("My Sports"),
                  ),
                  Expanded(
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: selectedList
                          .map(
                            (s) => Draggable(
                              data: s,
                              feedback: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Material(
                                    color: Colors.transparent,
                                    child: Chip(label: Text(s.name),),),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.0,
                                child: Container(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Material(
                                    color: Colors.transparent,
                                    child: Chip(
                                      label: Text(s.name),
                                      deleteIcon: const Icon(Icons.delete),
                                      deleteIconColor: Colors.red,
                                    ),),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Other Sports"),
                  ),
                  Expanded(
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: snapshot.data!
                          .map(
                            (s) => Draggable(
                              data: s,
                              feedback: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Chip(
                                    label: Text(s.name),
                                  ),
                                ),
                              ),
                              childWhenDragging: const Opacity(
                                opacity: 0.0,
                                child: SizedBox(),
                              ),
                              child: !s.isSelected
                                  ? Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Material(
                                          color: Colors.transparent,
                                          child: Chip(
                                            label: Text(s.name),
                                            deleteIcon:
                                                const Icon(Icons.rotate_right),
                                            deleteIconColor: Colors.green,
                                          )),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: DragTarget<Sport>(
                      onAccept: (sport) {
                        selectedSport = sport;
                      },
                      onWillAccept: (sport) {
                        return true;
                      },
                      builder: (context, List<Sport?> incomming, rejected) {
                        return selectedSport != null
                            ? Draggable(
                                feedback: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Chip(
                                      label: Text(selectedSport!.name),
                                    ),
                                  ),
                                ),
                                child: Chip(
                                  label: Text(selectedSport!.name),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                  )
                ],
              );
            } else {
              return const Center(child: Text(Consts.NO_DATA_FOUND));
            }
          } else {
            return const Text(Consts.NO_DATA_FOUND);
          }
        },
      ),
    );
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
