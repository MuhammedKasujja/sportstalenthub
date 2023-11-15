import 'package:flutter/material.dart';

class ViewImagePage extends StatelessWidget {
  final String tag;
  final String? title;
  final String imageUrl;

  const ViewImagePage({
    Key? key,
    required this.tag,
    required this.imageUrl,
    this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(this.title ?? ''),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Hero(
            tag: tag,
            //child: Image.network(imageUrl),
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
