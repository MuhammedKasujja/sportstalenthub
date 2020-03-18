import 'package:flutter/material.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/models/player.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/pages/posts_tab.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/widgets/profile_card.dart';

class PrayerProfiles extends StatefulWidget{

  const PrayerProfiles({Key key, this.sport}) : super(key: key);
  final Sport sport;

  @override
  _PrayerProfilesState createState() => _PrayerProfilesState();
}

class _PrayerProfilesState extends State<PrayerProfiles> with AutomaticKeepAliveClientMixin<PrayerProfiles>{
  final api = new ApiService();
  var playerList;

  @override
  void initState() {
    super.initState();
    print("${widget.sport.sportId}");
    playerList = api.getPlayers(category:  widget.sport.sportId);
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.sport.sportId == "000111000" ? PostsPage() : FutureBuilder<List<Player>>(
        future: this.playerList,
        builder: (BuildContext context, AsyncSnapshot<List<Player>> snapshot) {
          if(snapshot.hasError){
            return Container(child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Text("Error: ${snapshot.error}"),
                Text(Consts.ERROR_MESSAGE),
                IconButton(icon: Icon(Icons.refresh, size: 30,),
                      onPressed: (){
                        setState(() {
                          playerList = api.getPlayers(category:  widget.sport.sportId);
                        },);
                    })
              ],
            )),);
          }
          if(snapshot.connectionState ==ConnectionState.waiting){
            return Container(child: Center(child: CircularProgressIndicator()),);
          }
          if(snapshot.hasData){
            if(snapshot.data.length > 0){
                return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) => ProfileCard(player : snapshot.data[index]),
                      );
            }else{
               return Center(child: Text("No data Found"));
            }
          }else{
            return Text("No data Found");
          }
        },

      );
    
  }

  Player player = new Player(fullname: "Kasujja Muhammed",
                                //imageUrl: 'http://img.youtube.com/vi/rqahKvZZVdg/0.jpg',
                                profilePhoto: 'lib/images/profile.jpg',
                                lastUpdated: '20/04/2019 10:39 AM',
                                category: 'Football',
                                contact: '0774262923',
                                nationality: 'Ugandan',
                                position: 'GoalKeeper',
                                dob: '22/07/1992',
                                gender: 'Male',
                                height: '5'
                                );

  @override
  bool get wantKeepAlive => true;

}