import 'package:flutter/material.dart';

class RetryIcon extends StatelessWidget {
  final String message ="Try Again";
  @override
  Widget build(BuildContext context) {
    return Chip(
        backgroundColor: Colors.red,
        label: Text(
          this.message,
          style: TextStyle(color: Colors.white, ),
        ));
  }
}

class RetryAgainIcon extends StatelessWidget {
  final String message ="Try Again";
  final Function onTry;

  const RetryAgainIcon({Key key, @required this.onTry}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: InkWell(
          child: Chip(
              backgroundColor: Colors.red,
              label: Text(
                this.message,
                style: TextStyle(color: Colors.white, ),
              )),
              onTap: onTry,
        ),
      ),
    );
  }
}
