import 'package:flutter/material.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/models/attachment.dart';
import 'package:sth/utils/consts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerVideosPage extends StatefulWidget {
  final String playerId;
  final String playerName;

  const PlayerVideosPage({super.key,
    required this.playerId,
    required this.playerName,
  });
  @override
  State<PlayerVideosPage> createState() => _PlayerVideosPageState();
}

class _PlayerVideosPageState extends State<PlayerVideosPage> {
  final api = ApiService();
  late Future<List<Attachment>> futureVideos;
 String? videoId;
  // String videoId = YoutubePlayer.convertUrlToId("https://youtu.be/kqyXwSV0rgM");
  List<Attachment>? listVideos;
  int videoPosition = 0;
  bool isLoading = true;
  bool isError = false;

  final youtubePlayerController = YoutubePlayerController(
    initialVideoId:
        YoutubePlayer.convertUrlToId("https://youtu.be/kqyXwSV0rgM") ?? '',
  );
  @override
  void initState() {
    futureVideos = api.getPlayersAttachments(
        playerId: widget.playerId, category: Consts.FILE_TYPE_VIDEOS);
    super.initState();
  }

  loadVideos() {
    setState(() {
      isError = false;
    });
    api
        .getPlayersAttachments(
            playerId: widget.playerId, category: Consts.FILE_TYPE_VIDEOS)
        .then((videos) {
      setState(() {
        isLoading = false;
        listVideos = videos;
        videoPosition = 0;
        videoId = videos.elementAt(0).filename;
        // youtubePlayerController.load(videoId);
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    });
  }

  @override
  void dispose() {
    youtubePlayerController.dispose();
    super.dispose();
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
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (videoId != null) {
                            setState(() {
                              youtubePlayerController.load(videoId!);
                            });
                          }
                        }),
              ),
              videoId != null
                  ? Positioned(
                      right: 10,
                      bottom: 8,
                      child: InkWell(
                        child: const Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onTap: () {
                          _shareVideo(videoId!);
                        },
                      ))
                  : Container(),
              playPreviousVideo(),
              playNextVideo()
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: futureVideos,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: InkWell(
                    child: Chip(label: Text("Error: ${snapshot.error}")),
                    onTap: () {
                      loadVideos();
                      // this.futureVideos = api.getPlayersAttachments(
                      //     playerId: widget.playerId,
                      //     category: Consts.FILE_TYPE_VIDEOS);
                    },
                  ));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    // videoId = snapshot.data[0].filename;
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) => Stack(
                        children: <Widget>[
                          GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8.0, left: 4, right: 4.0, top: 4),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: videoId ==
                                                  snapshot.data![0].filename
                                              ? 1
                                              : 0,
                                          color: videoId ==
                                                  snapshot.data![0].filename
                                              ? Colors.red
                                              : Colors.transparent),
                                      borderRadius: BorderRadius.circular(5.0),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "http://img.youtube.com/vi/${snapshot.data![index].filename}/0.jpg",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const Positioned.fill(
                                    child: Align(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.play_arrow,
                                          size: 40,
                                          color: Colors.red,
                                        ),
                                        onPressed: null,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              print(snapshot.data![index].filename);
                              setState(() {
                                videoPosition = index;
                                videoId = snapshot.data![index].filename;
                                // videoId = YoutubePlayer.convertUrlToId(
                                //     snapshot.data[index].filename);
                                youtubePlayerController.load(videoId!);
                              });
                            },
                          ),
                          const Positioned(
                            right: 10,
                            bottom: 10,
                            child: InkWell(
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                        child: Text(
                      "Player has no videos",
                      style: TextStyle(color: Colors.grey),
                    ));
                  }
                } else {
                  return const Text("Player has no videos",
                      style: TextStyle(color: Colors.grey));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget playPreviousVideo() {
    return Positioned(
        left: 20,
        bottom: 6,
        child: IconButton(
            icon: Icon(
              Icons.skip_previous,
              color: (listVideos != null && listVideos!.isNotEmpty)
                  ? Colors.red
                  : Colors.grey,
            ),
            onPressed: () {
              if (listVideos != null && listVideos!.isNotEmpty) {
                if (listVideos!.length == 1) {
                } else {
                  if (videoPosition == 0) {
                    // TODO disable button
                  } else if (videoPosition > 0) {
                    int position = videoPosition - 1;
                    setState(() {
                      videoId = listVideos!.elementAt(position).filename;
                      videoPosition = position;
                      youtubePlayerController.load(videoId!);
                    });
                  }
                }
              }
            }));
  }

  Widget playNextVideo() {
    return Positioned(
      right: 20,
      bottom: 6,
      child: IconButton(
        icon: Icon(
          Icons.skip_next,
          color: (listVideos != null && listVideos!.isNotEmpty)
              ? Colors.red
              : Colors.grey,
        ),
        onPressed: () {
          if (listVideos != null && listVideos!.isNotEmpty) {
            if (listVideos!.length == 1) {
            } else {
              if (videoPosition == listVideos!.length - 1) {
                // TODO disable button
              } else if (videoPosition > 0) {
                int position = videoPosition + 1;
                setState(() {
                  videoId = listVideos!.elementAt(position).filename;
                  videoPosition = position;
                  youtubePlayerController.load(videoId!);
                });
              }
            }
          }
        },
      ),
    );
  }

  _shareVideo(String videoLink) {
    print("Link: $videoLink");
  }
}
