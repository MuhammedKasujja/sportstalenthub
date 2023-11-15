import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/api/database.dart';
import 'package:sth/api/repositoty.dart';

import 'package:sth/models/player.dart';
import 'package:sth/models/sport.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/utils/consts.dart';
import 'package:sth/widgets/player_shimmer.dart';
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
  List<Player> players = [];
  bool isLoading = false;
  final db = DBProvider();
  List<Sport> repoList = [];

  final api = ApiService();

  List<String> _sportsArr = [Consts.SELECTED_SPORT];
  List<String> _positions = [Consts.SELECTED_POSITION];

  List<String> _gender = [
    Consts.SELECTED_GENDER,
    Consts.GENDER_MALE,
    Consts.GENDER_FEMALE
  ];
  List<String> _ageGroup = [
    Consts.SELECTED_AGE_GROUP,
    Consts.GROUP_ABOVE23,
    Consts.GROUP_U23,
    Consts.GROUP_U20,
    Consts.GROUP_U17,
    Consts.GROUP_U15,
    Consts.GROUP_U13,
    Consts.GROUP_U10,
    Consts.GROUP_U7
  ];
  String _selectedGender = Consts.SELECTED_GENDER;
  String _selectedSport = Consts.SELECTED_SPORT;
  String _selectedCountry = 'UG';
  String _selectedAgeGroup = Consts.SELECTED_AGE_GROUP;
  String _selectedPosition = Consts.SELECTED_POSITION;

  final repo = Repository();
  var jsonResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey[100],
            // appBar: AppBar(
            //   title: TextField(
            //     style: TextStyle(color: Colors.white, fontSize: 18.0),
            //     decoration: InputDecoration(
            //         hintText: "Search Player",
            //         hintStyle: TextStyle(color: Colors.white)),
            //     onChanged: (query) {
            //       subject.add(query);
            //     },
            //   ),
            //   actions: <Widget>[
            //     IconButton(
            //       icon: Icon(
            //         Icons.clear,
            //         color: Colors.white,
            //       ),
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //       },
            //     )
            //   ],
            // ),
            body: Column(
              children: <Widget>[
                _createSearchBar(context),
                Expanded(
                  child: isLoading
                      ? PlayerShimmer()
                      : players.length > 0
                          ? ListView.builder(
                              itemCount: players.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ProfileCard(
                                  player: players[index],
                                );
                              },
                            )
                          : _playerFilter(),
                ),
              ],
            )),
      ),
    );
  }

  void _searchPlayers(String query) {
    if (query.isEmpty) {
      _changeState(false);
      _clearPlayers();
      return;
    }

    _changeState(true);
    _clearPlayers();
    Dio()
        .get(Urls.SEARCH_PLAYERS + query)
        .then((res) => res.data)
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
    repo.loadJson().then((result) {
      setState(() {
        _sportsArr.addAll(repo.getSports(result));
        jsonResult = result;
      });
    }).catchError((onError) {
      print("Error: $onError");
    });
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
      // subject.
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
    List<String>? searchStrings =
        prefs.getStringList(Consts.PREF_LIST_SEARCH_STRINGS) == null
            ? []
            : prefs.getStringList(Consts.PREF_LIST_SEARCH_STRINGS);
    if (searchStrings == null) return;
    searchStrings.add(query);
    await prefs.setStringList(Consts.PREF_LIST_SEARCH_STRINGS, searchStrings);
  }

  Widget _createSearchBar(context) {
    return Card(
      margin: EdgeInsets.all(0.0),
      elevation: 9.0,
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.red),
              onPressed: () {
                if (players.length > 0) {
                  _clearPlayers();
                } else {
                  AppUtils(context: context).goBack();
                }
              }),
          Expanded(
              child: TextField(
            textInputAction: TextInputAction.search,
            // autofocus: true,
            decoration: InputDecoration(
                // suffix: Icon(
                //   Icons.search,
                //   color: Colors.grey[400],
                // ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16.0),
                hintText: "Search Players"),
            onChanged: (str) => (subject.add(str)),
          ))
        ],
      ),
    );
  }

  Widget _playerFilter() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(0),
                child: DropdownButton<String>(
                  underline: Container(),
                  isExpanded: true,
                  items: _sportsArr.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  onChanged: (value) => _onSelectedSport(value),
                  value: _selectedSport,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.all(0),
                child: DropdownButton<String>(
                  underline: Container(),
                  isExpanded: true,
                  items: _positions.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  // onChanged: (value) => print(value),
                  onChanged: (value) => _onSelectedPostion(value),
                  value: _selectedPosition,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.all(0),
                child: DropdownButton<String>(
                  underline: Container(),
                  isExpanded: true,
                  items: _gender.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  onChanged: (value) => _onSelectedGender(value),
                  value: _selectedGender,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.all(0),
                child: DropdownButton<String>(
                  underline: Container(),
                  isExpanded: true,
                  items: _ageGroup.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  onChanged: (value) => _onSelectedAgeGroup(value),
                  value: _selectedAgeGroup,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.all(0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: CountryPickerDropdown(
                    initialValue: _selectedCountry,
                    // isExpanded: true,
                    itemBuilder: (Country country) {
                      return Container(
                        child: Row(
                          children: <Widget>[
                            CountryPickerUtils.getDefaultFlagImage(country),
                            SizedBox(width: 8.0),
                            Text("${country.name}")
                          ],
                        ),
                      );
                    },
                    onValuePicked: (country) =>
                        _onSelectedCountry(country.isoCode),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Center(
                child: InkWell(
                  child: Chip(
                    elevation: 8,
                    label: Text(
                      "Filter Players",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                  onTap: () {
                    _clearPlayers();
                    api
                        .filterPlayers(
                            sport: _selectedSport,
                            gender: _selectedGender,
                            country: _selectedCountry,
                            ageGroup: _selectedAgeGroup)
                        .then((playersList) {
                      setState(() {
                        players = playersList;
                        isLoading = false;
                      });
                    }).catchError((onError) {
                      _changeState(false);
                    });
                    setState(() {
                      isLoading = true;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelectedSport(String? value) {
    if (value == null) return;
    setState(() {
      _selectedPosition = Consts.SELECTED_POSITION;
      _positions = [Consts.SELECTED_POSITION];
      _selectedSport = value;
      _positions = List.from(_positions)
        ..addAll(repo.getPositions(value, jsonResult));
    });
  }

  void _onSelectedPostion(String? value) {
    if (value == null) return;
    setState(() => _selectedPosition = value);
  }

  void _onSelectedGender(String? value) {
    if (value == null) return;
    setState(() => _selectedGender = value);
  }

  void _onSelectedCountry(String? value) {
    if (value == null) return;
    setState(() => _selectedCountry = value);
  }

  void _onSelectedAgeGroup(String? value) {
    if (value == null) return;
    setState(() => _selectedAgeGroup = value);
  }
}
