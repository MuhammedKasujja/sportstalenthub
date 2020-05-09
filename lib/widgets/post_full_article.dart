import 'package:flutter/material.dart';
import 'package:webview_media/webview_flutter.dart';

class PostFullArticle extends StatefulWidget {
  final String article;
  final bool isClickable;
  const PostFullArticle({Key key, @required this.article, this.isClickable = false}) : super(key: key);

  @override
  _PostFullArticleState createState() => _PostFullArticleState();
}

class _PostFullArticleState extends State<PostFullArticle> {
  // String _articleString;
  // @override
  // void initState() {
  //   super.initState();
  //   _articleString = Uri.dataFromString('<html><body>${widget.article}</body></html>',
  //             mimeType: 'text/html')
  //         .toString();
  // }
  @override
  Widget build(BuildContext context) {
    return WebView(
     // initialUrl: _articleString,
      initialUrl: '',
      // debuggingEnabled: true,
      // initialUrl:'data:text/html;base64,${base64Encode(const Utf8Encoder().convert(widget.article))}',
      javascriptMode: JavascriptMode.unrestricted,
      gestureNavigationEnabled: this.widget.isClickable,
      onWebViewCreated: (controller) {
        controller.loadData(widget.article);
      },
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },
    );
  }
}
