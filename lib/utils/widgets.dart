import 'package:flutter/material.dart';

Widget roundedAppBar(BuildContext context) {
  return PreferredSize(
    child: SafeArea(
      child: Container(
        height: 200.0,
        decoration: new BoxDecoration(
          color: Colors.orange,
          boxShadow: [new BoxShadow(blurRadius: 30.0)],
          borderRadius: new BorderRadius.vertical(
            bottom: new Radius.elliptical(
              MediaQuery.of(context).size.width,
              100.0,
            ),
          ),
        ),
        child: Center(
          child: CircleAvatar(
            child: Image.asset('widget.prayer.imageUrl,'),
          ),
        ),
      ),
    ),
    preferredSize: Size.fromHeight(200),
  );
}
