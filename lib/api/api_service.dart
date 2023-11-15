import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sth/api/urls.dart';
import 'package:sth/core/core.dart';
import 'package:sth/models/models.dart';
import 'dart:convert';

import 'package:sth/utils/consts.dart';

class ApiService {
  Future<List<Sport>> getSports() async {
    final res = await Dio().get(Urls.GET_SPORTS).catchError((onError) {
      print("${onError.toString()}");
    });
    return compute(_parseSports, res.data);
  }

  Future<List<Player>> getPlayers({category}) async {
    final res = await Dio()
        .get(Urls.GET_PLAYERS + category.toString())
        .catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    return compute(_parsePlayers, res.data);
  }

  Future<List<Player>> getFavouritePlayers(playerIds) async {
    print("fetching data: getFavouritePlayers");
    final res = await Dio()
        .get(Urls.MY_FAVOURITE_PLAYERS + playerIds)
        .catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    return compute(_parsePlayers, res.data);
  }

  Future<List<Player>> filterPlayers(
      {sport, String? gender, country, ageGroup}) async {
    String sex = (gender != null && gender.isNotEmpty)
        ? gender == Consts.GENDER_MALE
            ? 'M'
            : 'F'
        : '';
    final res = await Dio()
        .get("${Urls.FILTER_PLAYERS}gender=$sex&sport=$sport&country=$country&age_group=$ageGroup")
        .catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    // print(res.body);
    return compute(_parsePlayers, res.data);
  }

  static List<Player> _parsePlayers(resBody) {
    try{
    final players =
        (resBody['players'] as List).map((p) => Player.fromJson(p));
    return players.toList();
    }catch(error){
      Logger.debug(data:error, key: 'fetching error: getPlayers');
      return [];
    }
  }

  static List<Sport> _parseSports(resBody) {
    final sports =
        (resBody['sports'] as List).map((s) => Sport.fromJson(s));
    return sports.toList();
  }

  Future<List<Attachment>> getPlayersAttachments(
      {@required playerId, @required category}) async {
    final res = await Dio()
        .get("${Urls.GET_PLAYERS_ATTACHMENTS}player_id=$playerId&category=$category")
        .catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    // print(res.body);
    return compute(_parsePlayersPhotos, res.data);
  }

  static List<Attachment> _parsePlayersPhotos( resBody) {
    final photos =
        (resBody['files'] as List).map((p) => Attachment.fromJson(p));
    return photos.toList();
  }

  Future<PlayerList> fetchPlayers({category, page}) async {
    print("fetching paginated data");
    final res = await Dio()
        .get(Urls.GET_PAGING_PLAYERS + category)
        .catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    // print(res.body);
    return compute(_parsePagedPlayers, res.data);
  }

  static PlayerList _parsePagedPlayers( resBody) {
    return PlayerList.fromJson(resBody);
  }

  Future<List<Post>> fetchPosts() async {
    print("fetching data: fetchPosts");
    final res = await  Dio().get(Urls.GET_POSTS).catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    // print(res.body);
    return compute(_parsePosts, res.data);
  }

  static List<Post> _parsePosts( resBody) {
    final posts = (resBody['posts'] as List).map((p) => Post.fromJson(p));
    return posts.toList();
  }

  Future<List<Achievement>> getPlayersAchievements({@required playerId}) async {
    print("Player ID: {$playerId} ");
    final res = await Dio()
        .get("${Urls.GET_PLAYERS_ACHIEVEMENTS}player_id=$playerId")
        .catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    // print(res.body);
    return compute(_parseAchievements, res.data);
  }

  static List<Achievement> _parseAchievements( resBody) {
    final achievements = (resBody['achievements'] as List)
        .map((p) => Achievement.fromJson(p));
    return achievements.toList();
  }

  Future<String> fetchPostFullArticle({required String postId}) async {
    // print("post_id: $postId");
    final res = await Dio()
        .get("${Urls.POST_FULL_ARTICLE}post_id=$postId")
        .catchError((onError) {
      print("CatchError : ${onError.toString()}");
    });
    // print(res.body);
    return compute(_parseArticle, res.data);
  }

  static String _parseArticle( resBody) {
    final responseJson = json.decode(resBody);
    return responseJson['full_article'];
  }
}
