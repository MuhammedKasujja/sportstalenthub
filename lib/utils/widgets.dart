import 'package:flutter/material.dart';

Widget roundedAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(200),
    child: SafeArea(
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.orange,
          boxShadow: const [BoxShadow(blurRadius: 30.0)],
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(
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
  );
}
