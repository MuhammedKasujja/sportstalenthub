import 'package:flutter/material.dart';
import 'package:sth/api/api_service.dart';

class FilesPage extends StatefulWidget {
  final String category;
  final playerId;
  final String playerName;

  const FilesPage({
    Key? key,
    required this.category,
    required this.playerId,
    required this.playerName,
  });
  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  final api = ApiService();
  var photos;
  bool isGridTiles = false;
  final PageController pageController = PageController();
  double currentPage = 0.0;
  @override
  void initState() {
    super.initState();
    photos = api.getPlayersAttachments(
      playerId: widget.playerId.toString(),
      category: widget.category,
    );
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.playerName}'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                isGridTiles ? Icons.menu : Icons.grid_on,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isGridTiles = !isGridTiles;
                });
              })
        ],
      ),
      body: FutureBuilder(
        future: photos,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return isGridTiles
                  ? gridFiles(snapshot.data)
                  : _pagingImages(snapshot.data);
              // return ListView.builder(
              //   itemCount: snapshot.data.length,
              //   itemBuilder: (BuildContext context, int index) =>
              //       GestureDetector(
              //     child: Hero(
              //       tag: snapshot.data[index].filename,
              //       child: Padding(
              //         padding: const EdgeInsets.only(bottom: 8.0),
              //         child: Container(
              //           child: Image.network(snapshot.data[index].filename),
              //         ),
              //       ),
              //     ),
              //     onTap: () {
              //       AppUtils(context: context).gotoPage(
              //           page: ViewImagePage(
              //               tag: snapshot.data[index].filename,
              //               imageUrl: snapshot.data[index].filename));
              //     },
              //   ),
              // );
            } else {
              return Center(child: Text("No data Found"));
            }
          } else {
            return Text("No data Found");
          }
        },
      ),
    );
  }

  Widget _pagingImages(List snapshot) {
    return PageView.builder(
      // physics: BouncingScrollPhysics(),
      controller: pageController,
      itemCount: snapshot.length,
      itemBuilder: (context, index) {
        return Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height:500,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(5.0)),
                    image: DecorationImage(
                      image: NetworkImage(
                        snapshot[index].filename,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  "${index + 1}/${snapshot.length}",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ))
          ],
        );
      },
      onPageChanged: (index) {
        print("Page: $index");
      },
    );
  }

  Widget gridFiles(List snapshot) {
    // var size = MediaQuery.of(context).size;
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    // final double itemWidth = size.width / 3;
    return GridView.builder(
        itemCount: snapshot.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ), //childAspectRatio: (itemWidth/itemHeight)
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              // width: MediaQuery.of(context).size.width,
              // height:500,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(5.0)),
                image: DecorationImage(
                    image: NetworkImage(
                      snapshot[index].filename,
                    ),
                    fit: BoxFit.fill),
              ),
            ),
            onTap: () {
              setState(() {
                isGridTiles = !isGridTiles;
              });
              // pageController.jumpToPage(index);
            },
          );
        });
  }
}
