import 'package:flutter/material.dart';

class AppUtils {
  BuildContext context;

  AppUtils({Key key, @required this.context});

  gotoPage({@required page}) {
    Navigator.push(this.context,
        MaterialPageRoute(builder: (BuildContext context) => page));
  }

  goBack() {
    Navigator.pop(this.context);
  }

  String getDate() {
    // return DateFormat('dd/MM/yyyy —   HH:mm:ss:S').format(DateTime.now());
    return null;
  }

  showFullArticle(Widget article, title) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        // backgroundColor: Colors.grey.shade400,
        // isScrollControlled: true,
        context: this.context,
        builder: (ctx) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.close), onPressed: (){
                            AppUtils(context: ctx).goBack();
                          }),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Expanded(
                          child: Container(
                              child: article
                      )),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  showSnack({String message = 'Your message'}) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
