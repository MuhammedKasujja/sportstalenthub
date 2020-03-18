import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sth/models/player.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/widgets/profile_card.dart';
import 'package:sth/api/urls.dart';

class SearchPlayerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPlayerPageState();
  }
}

class _SearchPlayerPageState extends State<SearchPlayerPage> {
  var subject = PublishSubject<String>();
  List<Player> players = List();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: AppBar(
          title: TextField(
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            decoration: InputDecoration(
                hintText: "Search Player",
                hintStyle: TextStyle(color: Colors.white)),
            onChanged: (query) {
              subject.add(query);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: players.length > 0
                    ? ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ProfileCard(
                            player: players[index],
                          );
                        },
                      )
                    : Container(
                        child: Center(child: Text("Holla")),
                      )));
  }

  void _searchPlayers(String query) {
    if (query.isEmpty) {
      _changeState(false);
      _clearPlayers();
      return;
    }

    _changeState(true);
    _clearPlayers();
    http
        .get(Urls.SEARCH_PLAYERS + query)
        .then((res) => res.body)
        .then(json.decode)
        .then((map) => map['players'])
        .then((players) => players.forEach(_addPlayer))
        .then((e) {
      _changeState(false);
    });
  }

  @override
  void initState() {
    super.initState();
    subject
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 600)))
        .listen(_searchPlayers);
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  void _changeState(bool _isLoading) {
    setState(() {
      isLoading = _isLoading;
    });
  }

  void _clearPlayers() {
    setState(() {
      players.clear();
    });
  }

  void _addPlayer(item) {
    setState(() {
      players.add(Player.fromJson(item));
    });
    print("${players.map((s) => s.fullname)}");
  }

  _saveSearchQuery({query}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> searchStrings =
        prefs.getStringList(Consts.PREF_LIST_SEARCH_STRINGS) == null
            ? List()
            : prefs.getStringList(Consts.PREF_LIST_SEARCH_STRINGS);
    searchStrings.add(query);
    await prefs.setStringList(Consts.PREF_LIST_SEARCH_STRINGS, searchStrings);
  }
}
