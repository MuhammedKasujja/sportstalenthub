import 'package:flutter/material.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/utils/consts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerVideosPage extends StatefulWidget {
  final String playerId;
  final String playerName;

  const PlayerVideosPage(
      {Key key, @required this.playerId, @required this.playerName})
      : super(key: key);
  @override
  _PlayerVideosPageState createState() => _PlayerVideosPageState();
}

class _PlayerVideosPageState extends State<PlayerVideosPage> {
  final api = ApiService();
  var futureVideos;
  String videoId;
  // String videoId = YoutubePlayer.convertUrlToId("https://youtu.be/kqyXwSV0rgM");

  final youtubePlayerController = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId("https://youtu.be/kqyXwSV0rgM"));
  @override
  void initState() {
    super.initState();
    futureVideos = api.getPlayersAttachments(
        playerId: widget.playerId, category: Consts.FILE_TYPE_VIDEOS);
  }

  @override
  void dispose() {
    super.dispose();
    youtubePlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playerName),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 220,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: videoId != null
                    ? YoutubePlayer(
                        controller: youtubePlayerController,
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (videoId != null) {
                            setState(() {
                              youtubePlayerController.load(videoId);
                              videoId = videoId;
                            });
                            
                            print("video id $videoId");
                          }
                        }),
              ),
              videoId != null
                  ? Positioned(
                      right: 10,
                      bottom: 8,
                      child: InkWell(
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onTap: () {
                          _shareVided(videoId);
                        },
                      ))
                  : Container()
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: futureVideos,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                        child: InkWell(
                      child: Chip(label: Text("Error: ${snapshot.error}")),
                      onTap: () {
                        this.futureVideos = api.getPlayersAttachments(
                            playerId: widget.playerId,
                            category: Consts.FILE_TYPE_VIDEOS);
                      },
                    )),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    videoId = snapshot.data[0].filename;
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) => Stack(
                        children: <Widget>[
                          GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(5.0)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            "http://img.youtube.com/vi/" +
                                                snapshot.data[index].filename +
                                                "/0.jpg",
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned.fill(
                                      child: Align(
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.play_arrow,
                                          size: 40,
                                          color: Colors.red,
                                        ),
                                        onPressed: null),
                                  ))
                                ],
                              ),
                            ),
                            onTap: () {
                              print(snapshot.data[index].filename);
                              setState(() {
                                videoId = snapshot.data[index].filename;
                                // videoId = YoutubePlayer.convertUrlToId(
                                //     snapshot.data[index].filename);
                                youtubePlayerController.load(videoId);
                              });
                            },
                          ),
                          Positioned(
                              right: 10,
                              bottom: 10,
                              child: InkWell(
                                child: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text("No data Found"));
                  }
                } else {
                  return Text("No data Found");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _shareVided(String videoLink) {
    print("Link: $videoLink");
  }
}
