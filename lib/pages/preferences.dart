import 'package:flutter/material.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/api/database.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/models/sport_pref.dart';

//typedef FutureCallback = void Function(Future);

class PreferencesPage extends StatefulWidget{
  final ValueChanged<List<Sport>> callbackRemoveTabs;
  final ValueChanged<List<Sport>> callbackClearTabs;
  Future<String> one(List list)   => new Future.value("from one");
  
  const PreferencesPage({Key key, this.callbackRemoveTabs, this.callbackClearTabs,}) : super(key: key);
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  //Storing sport in SharedPref as Serialized
  var repo = new FuturePreferencesRepository<Sport>(new SportDesSer());

  final api = ApiService();
  final db = DBProvider();
  var sportsList;
  List<Sport> selectedList = List();
  List<Sport> savedList = List();
  @override
  void initState() {
    super.initState();
    sportsList = api.getSports();
    repo.findAll().then((sports){
      savedList.addAll(sports);
      widget.callbackClearTabs(sports);
      repo.removeAll();
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
               repo.saveAll(selectedList).then((list){
                 Navigator.pop(context, selectedList);
               });
               widget.callbackRemoveTabs(selectedList);
          },
        ),
        title: Text('Settings'),
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
          if(snapshot.hasError){
            return Container(child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Error: ${snapshot.error}"),
                IconButton(icon: Icon(Icons.refresh, size: 30,),
                      onPressed: (){
                        setState(() {
                          sportsList = api.getSports();
                        },);
                    })
              ],
            )),);
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Container(child: Center(child: CircularProgressIndicator()),);
          }
          if(snapshot.hasData){
            if(snapshot.data.length > 0){
                return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index){
                            Sport sport = snapshot.data[index];
                           return  CheckboxListTile(
                                    title: new Text(sport.name),
                                    value: selectedList.contains(sport),
                                    onChanged: (bool selected) {
                                       _onSportSelected(selected,sport);
                                    },
                                );    
                          }
                );
            }else{
               return Center(child: Text("No data Found"));
            }
          }else{
            return Text("No data Found");
          }
        },
      )
    );
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
    for(Sport s in selectedList){
       print(s.name);
    }
  }

  Future<void> removeAddTabs() async{
     await widget.callbackRemoveTabs(savedList);
     await repo.saveAll(selectedList);
     await widget.callbackClearTabs(selectedList);

  }
 
  void loadLocalSports() async {
    var _cars = await db.getAllSports();
    print(_cars);

    setState(() {
      sportsList = _cars;
    });
  }
}