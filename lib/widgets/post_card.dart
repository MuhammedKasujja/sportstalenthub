import 'package:flutter/material.dart';
import 'package:sth/models/post.dart';
import 'package:sth/pages/view_image.dart';
import 'package:sth/pages/view_post.dart';
import 'package:sth/utils/app_utils.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final String tag;

  const PostCard({Key key, @required this.post, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      child: GestureDetector(
        onTap: () {
          AppUtils(context: context,).gotoPage( page: ViewPostPage(post: post,));
        },
        child: Card(
          elevation: 3.0,
          child: Row(
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: Hero(
                  tag: tag,
                  child: Container(
                    width: 120.0,
                    height: 170.0,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(5.0)),
                      image: DecorationImage(
                          image: NetworkImage(
                            "${post.imageUrl}",
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                onTap: (){
                  AppUtils(context: context,).gotoPage( page: ViewImagePage(tag: tag, imageUrl: "${post.imageUrl}",));
                },
              ),
              Expanded(
                child: Container(
                  height: 170.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(post.title,
                            style: Theme.of(context).textTheme.subhead),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          post.description,
                          style: Theme.of(context).textTheme.body1,
                         // maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Align(alignment: Alignment.bottomRight,
                          child: Text('${post.date}',
                              style: Theme.of(context).textTheme.caption,),
                          ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}