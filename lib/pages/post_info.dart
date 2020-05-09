import 'package:flutter/material.dart';
import 'package:sth/api/api_service.dart';
import 'package:sth/models/post.dart';
import 'package:sth/pages/view_image.dart';
import 'package:sth/utils/app_utils.dart';
import 'package:sth/widgets/loading.dart';
import 'package:sth/widgets/retry.dart';

class PostInfoPage extends StatefulWidget {
  final Post post;

  const PostInfoPage({Key key, this.post}) : super(key: key);
  @override
  _PostInfoPageState createState() => _PostInfoPageState();
}

class _PostInfoPageState extends State<PostInfoPage> {
  final api = ApiService();
  var fullArticle;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: SafeArea(
        child: Scaffold(
            body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 210.0,
                floating: false,
                pinned: true,
                leading: IconButton(
                    color: Colors.red,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      AppUtils(context: context).goBack();
                    }),
                actions: <Widget>[
                  IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.share, color: Colors.red),
                      onPressed: null)
                ],
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    //titlePadding: EdgeInsets.only(left: 10),
                    title: Text('News',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        )),
                    background: GestureDetector(
                      child: Hero(
                        tag: widget.post.postId,
                        child: Image.network(
                          widget.post.imageUrl,
                          fit: BoxFit.cover,
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
                    )),
              ),
            ];
          },
          body: Container(
            child: _buildContentContainer(),
          ),
        )),
      ),
    );
  }

  Widget _buildContentContainer() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.post.description}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: 20,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 10, top: 2, bottom: 2),
                      child: Text(
                        '${widget.post.date}',
                        style: TextStyle(color: Colors.red),
                      ),
                    )),
              ),
              FutureBuilder(
                  future: fullArticle,
                  builder: (context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingIcon();
                    }
                    if (snapshot.hasError) {
                      return RetryAgainIcon(onTry: () {
                        _fetchData();
                      });
                    }
                    return Expanded(
                        child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: _articleInfo(snapshot.data)));
                  }),
            ],
          ),
        ),
      ],
    );
  }

  _fetchData() {
    fullArticle = api
        .fetchPostFullArticle(postId: widget.post.postId)
        .catchError((onError) {
      print("$onError");
    });
  }

  Widget _articleInfo(fullArticle) {
    return Text(fullArticle);
  }
}
