import 'package:flutter/material.dart';

class PostFullArticle extends StatelessWidget {
  final String article;

  const PostFullArticle({Key key, @required this.article}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        article,
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }
}
