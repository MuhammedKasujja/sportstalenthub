import 'package:flutter/material.dart';
import 'package:sth/models/post.dart';

class ViewPostPage extends StatelessWidget {
  final Post post;

  const ViewPostPage({Key key, @required this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  const _NewsAppBar({Key key, this.height, this.post}) : super(key: key);

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
            post.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40.0),
            child: new Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
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

  const ContentCard({Key key, this.post}) : super(key: key);
  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
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
                      Container(
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
                    ],
                  )),
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 15,
                    ),
                  ),
                  Positioned(
                      left: 10,
                      child: widget.post.category != null
                          ? Text('${widget.post.category}')
                          : Text("")),
                  Positioned(right: 10, child: Text('${widget.post.date}'))
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
      child: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.post.description}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              // Expanded(child: Container()),
            ],
          ),
        ),
      ]),
    );
  }
}
