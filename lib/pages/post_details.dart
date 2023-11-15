import 'package:flutter/material.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/models/post.dart';
import 'package:sth/pages/view_image.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/widgets/loading.dart';
import 'package:sth/widgets/post_full_article.dart';

class PostDetailsPage extends StatelessWidget {
  final Post post;

  const PostDetailsPage({Key? key, required this.post});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: Stack(
        children: <Widget>[
          _NewsAppBar(
            height: 210.0,
            post: post,
          ),
        ],
      ),
    );
  }
}

class _NewsAppBar extends StatelessWidget {
  final double height;
  final Post post;

  const _NewsAppBar({
    required this.height,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
              /*gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red, const Color(0xFFE64C85)],
            ),
            */
              color: Colors.red),
          height: height,
        ),
        new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: new Text(
            "News",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: null,
            )
          ],
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 40.0,
            ),
            child: new Column(
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                Expanded(
                    child: ContentCard(
                  post: post,
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ContentCard extends StatefulWidget {
  final Post post;

  const ContentCard({Key? key,required this.post});
  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  final api = ApiService();
   String? fullArticle;

  @override
  void initState() {
    super.initState();
    api.fetchPostFullArticle(postId: widget.post.postId).then((article) {
      setState(() {
        fullArticle = article;
      });
    }).catchError((onError) {
      print("$onError");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 4.0,
      // color: Colors.amber,
      margin: const EdgeInsets.all(8.0),
      child: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Column(
            children: <Widget>[
              // _buildTabBar(),
              SizedBox(
                  height: 200,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Hero(
                          tag: widget.post.postId,
                          child: Container(
                            height: 170.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(5.0)),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "${widget.post.imageUrl}",
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        onTap: () {
                          AppUtils(
                            context: context,
                          ).gotoPage(
                              page: ViewImagePage(
                            tag: widget.post.postId,
                            imageUrl: "${widget.post.imageUrl}",
                          ));
                        },
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.post.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 10,
                    ),
                  ),
                  Positioned(
                      left: 10,
                      child: widget.post.category != null
                          ? Text('${widget.post.category}')
                          : Text("")),
                  Positioned(
                      right: 10,
                      child: Text(
                        '${widget.post.date}',
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              ),
              _buildContentContainer(
                viewportConstraints,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContentContainer(BoxConstraints viewportConstraints) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${widget.post.description}",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          fullArticle != null
              ? Expanded(
                  child: GestureDetector(
                  child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: _articleInfo(fullArticle)),
                  onTap: () {
                    AppUtils(context: context).showFullArticle(
                        viewArticle(fullArticle), widget.post.description);
                  },
                  onVerticalDragStart: (dragDetails) {
                    AppUtils(context: context).showFullArticle(
                        viewArticle(fullArticle), widget.post.description);
                  },
                ))
              : LoadingIcon(),
        ],
      ),
    );
  }

  Widget viewArticle(fullArticle) {
    return PostFullArticle(article: fullArticle);
  }

  Widget _articleInfo(fullArticle) {
    return Text(fullArticle);
  }
}
