import 'package:flutter/material.dart';
import 'package:sth/models/post.dart';
import 'package:sth/pages/post_info.dart';
import 'package:sth/utils/app_utils.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final String? tag;

  const PostCard({super.key, required this.post, this.tag});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        child: GestureDetector(
          onTap: () {
            AppUtils(
              context: context,
            ).gotoPage(
                page: PostInfoPage(
              post: post,
            ));
          },
          child: Card(
            elevation: 3.0,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 170.0,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.horizontal(left: Radius.circular(5.0)),
                    image: DecorationImage(
                        image: NetworkImage(
                          post.imageUrl,
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 150.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(post.title,
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            post.description ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                            // maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              post.date,
                              //style: Theme.of(context).textTheme.caption,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
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
      ),
    );
  }
}
