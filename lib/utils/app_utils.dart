import 'package:flutter/material.dart';

class AppUtils {
  BuildContext context;

  AppUtils({Key? key, required this.context});

  gotoPage({required page}) {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => page));
  }

  goBack() {
    Navigator.pop(context);
  }

  String getDate() {
    // return DateFormat('dd/MM/yyyy —   HH:mm:ss:S').format(DateTime.now());
    return '';
  }

  showFullArticle(Widget article, title) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        // backgroundColor: Colors.grey.shade400,
        // isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              AppUtils(context: ctx).goBack();
                            }),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    Expanded(child: Container(child: article)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showSnack({String message = 'Your message'}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
