import 'package:flutter/foundation.dart';
import 'package:sth/api/urls.dart';
import 'package:sth/models/photos.dart';
import 'package:sth/models/player.dart';
import 'package:sth/models/player_list.dart';
import 'package:sth/models/post.dart';
import 'package:sth/models/sport.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<List<Sport>> getSports() async {
    final res = await http.get(Urls.GET_SPORTS).catchError((onError) {
      print("${onError.toString()}");
    });
    print(res.body);
    return compute(_parseSports, res.body);
  }

  Future<List<Player>> getPlayers({category}) async {
    print("fetching data");
    final res = await http
        .get(Urls.GET_PLAYERS + category.toString())
        .catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    print(res.body);
    return compute(_parsePlayers, res.body);
  }

  Future<List<Player>> getFavouritePlayers(playerIds) async {
    print("fetching data");
    final res = await http
        .get(Urls.MY_FAVOURITE_PLAYERS + playerIds)
        .catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    print(res.body);
    return compute(_parsePlayers, res.body);
  }

  static List<Player> _parsePlayers(String resBody) {
    final responseJson = json.decode(resBody);
    final players =
        (responseJson['players'] as List).map((p) => new Player.fromJson(p));
    return players.toList();
  }

  static List<Sport> _parseSports(String resBody) {
    final responseJson = json.decode(resBody);
    final sports =
        (responseJson['sports'] as List).map((s) => new Sport.fromJson(s));
    return sports.toList();
  }

  Future<List<Photo>> getPlayersAttachments(
      {@required playerId, @required category}) async {
    final res = await http
        .get(Urls.GET_PLAYERS_ATTACHMENTS +
            "player_id={$playerId}&category={$category}")
        .catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    print(res.body);
    return compute(_parsePlayersPhotos, res.body);
  }

  static List<Photo> _parsePlayersPhotos(String resBody) {
    final responseJson = json.decode(resBody);
    final photos =
        (responseJson['files'] as List).map((p) => new Photo.fromJson(p));
    return photos.toList();
  }

  Future<PlayerList> fetchPlayers({category, page}) async {
    print("fetching paginated data");
    final res = await http
        .get(Urls.GET_PAGING_PLAYERS + category)
        .catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    print(res.body);
    return compute(_parsePagedPlayers, res.body);
  }

  static PlayerList _parsePagedPlayers(String resBody) {
    final responseJson = json.decode(resBody);
    final players = PlayerList.fromJson(responseJson);
    return players;
  }

  Future<List<Post>> fetchPosts() async {
    print("fetching data");
    final res = await http.get(Urls.GET_POSTS).catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    print(res.body);
    return compute(_parsePosts, res.body);
  }

  static List<Post> _parsePosts(String resBody) {
    final responseJson = json.decode(resBody);
    final posts =
        (responseJson['posts'] as List).map((p) => new Post.fromJson(p));
    return posts.toList();
  }
}
